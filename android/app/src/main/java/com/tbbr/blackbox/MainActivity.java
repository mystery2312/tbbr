package com.tbbr.blackbox;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.DownloadManager;
import android.content.BroadcastReceiver;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.provider.Settings;
import android.util.Base64;
import android.view.View;
import android.view.WindowManager;
import android.webkit.JavascriptInterface;
import android.webkit.ValueCallback;
import android.webkit.WebChromeClient;
import android.webkit.WebResourceRequest;
import android.webkit.WebResourceResponse;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Toast;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;

/**
 * BlackBox TBBR pour Android : l'éditeur (interface/app, copié dans les assets) dans une WebView, servi depuis
 * https://appassets.androidplatform.net/app/ (origine stable : localStorage et IndexedDB persistent).
 * La WebView d'Android n'a pas WebMIDI : MidiBridge (API android.media.midi, appareils USB MIDI en OTG) le fournit,
 * et assets/app/android-midi.js recrée navigator.requestMIDIAccess par-dessus.
 */
public class MainActivity extends Activity {
    static final String HOST = "appassets.androidplatform.net";
    static final String START = "https://" + HOST + "/app/index.html";
    static final String API = "https://api.github.com/repos/mystery2312/tbbr/releases/latest";
    private static final int PICK_FILE = 41;
    private static final long CHECK_EVERY = 6 * 60 * 60 * 1000L;      // 6 h entre deux vérifications

    private WebView web;
    private MidiBridge midi;
    private ValueCallback<Uri[]> pending;
    private long updateDownload = -1;
    private String pendingUrl, pendingTag;
    private Uri pendingApk;
    private BroadcastReceiver downloadDone;

    @Override
    protected void onCreate(Bundle state) {
        super.onCreate(state);
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
        web = new WebView(this);
        web.setBackgroundColor(0xFF08090B);
        setContentView(web);

        WebSettings s = web.getSettings();
        s.setJavaScriptEnabled(true);
        s.setDomStorageEnabled(true);
        s.setDatabaseEnabled(true);
        s.setAllowFileAccess(false);
        s.setAllowContentAccess(true);
        s.setMediaPlaybackRequiresUserGesture(false);
        s.setTextZoom(100);

        midi = new MidiBridge(this, web);
        web.addJavascriptInterface(midi, "TBBRMidi");
        web.addJavascriptInterface(new AppBridge(), "TBBRAndroid");

        web.setWebViewClient(new WebViewClient() {
            @Override
            public WebResourceResponse shouldInterceptRequest(WebView v, WebResourceRequest r) {
                Uri u = r.getUrl();
                if (!HOST.equals(u.getHost())) return null;
                String path = u.getPath() == null ? "" : u.getPath();
                if (path.startsWith("/")) path = path.substring(1);
                if (path.isEmpty() || path.endsWith("/")) path += "index.html";
                try {
                    InputStream in = getAssets().open(path);
                    WebResourceResponse res = new WebResourceResponse(mime(path), mime(path).startsWith("text/") || mime(path).contains("javascript") || mime(path).contains("json") ? "utf-8" : null, in);
                    java.util.HashMap<String, String> h = new java.util.HashMap<>();
                    h.put("Cache-Control", "no-store");
                    res.setResponseHeaders(h);
                    return res;
                } catch (Exception e) {
                    return new WebResourceResponse("text/plain", "utf-8", 404, "Not found", null, null);
                }
            }

            @Override
            public boolean shouldOverrideUrlLoading(WebView v, WebResourceRequest r) {
                Uri u = r.getUrl();
                if (HOST.equals(u.getHost())) return false;
                openExternal(u.toString());                        // liens externes : navigateur du téléphone
                return true;
            }
        });

        web.setWebChromeClient(new WebChromeClient() {
            @Override
            public boolean onShowFileChooser(WebView v, ValueCallback<Uri[]> cb, FileChooserParams p) {
                if (pending != null) pending.onReceiveValue(null);
                pending = cb;
                Intent i = new Intent(Intent.ACTION_GET_CONTENT);
                i.addCategory(Intent.CATEGORY_OPENABLE);
                i.setType("*/*");                                   // .nam, .wav, .json : types MIME peu fiables sur Android
                i.putExtra(Intent.EXTRA_ALLOW_MULTIPLE, p.getMode() == FileChooserParams.MODE_OPEN_MULTIPLE);
                try { startActivityForResult(Intent.createChooser(i, "Choisir un fichier"), PICK_FILE); }
                catch (Exception e) { pending = null; return false; }
                return true;
            }
        });

        registerDownloadReceiver();
        if (state != null) web.restoreState(state); else web.loadUrl(START);
        checkUpdates(false);
    }

    @Override
    protected void onResume() {
        super.onResume();
        /* Retour de « installer des applis inconnues » : reprend le téléchargement ou l'installation. */
        if (pendingUrl != null && canInstallPackages()) {
            String url = pendingUrl, tag = pendingTag;
            pendingUrl = null; pendingTag = null;
            startDownload(url, tag);
        }
        if (pendingApk != null && canInstallPackages()) {
            Uri apk = pendingApk; pendingApk = null;
            installApk(apk);
        }
        checkUpdates(false);
    }

    /* ---------------- mises à jour de l'app Android (GitHub Releases) ---------------- */

    String appVersion() {
        try { return getPackageManager().getPackageInfo(getPackageName(), 0).versionName; }
        catch (Exception e) { return "0.0.0"; }
    }

    void checkUpdates(boolean force) {
        SharedPreferences p = getSharedPreferences("tbbr", MODE_PRIVATE);
        long now = System.currentTimeMillis();
        if (!force && now - p.getLong("lastCheck", 0) < CHECK_EVERY) return;
        p.edit().putLong("lastCheck", now).apply();
        new Thread(() -> {
            HttpURLConnection c = null;
            try {
                c = (HttpURLConnection) new URL(API).openConnection();
                c.setConnectTimeout(8000);
                c.setReadTimeout(8000);
                c.setRequestProperty("Accept", "application/vnd.github+json");
                c.setRequestProperty("User-Agent", "TBBR-Android");
                if (c.getResponseCode() != 200) return;
                StringBuilder sb = new StringBuilder();
                try (BufferedReader r = new BufferedReader(new InputStreamReader(c.getInputStream(), "UTF-8"))) {
                    String line;
                    while ((line = r.readLine()) != null) sb.append(line);
                }
                JSONObject j = new JSONObject(sb.toString());
                String tag = j.optString("tag_name", "").replaceFirst("^[vV]", "");
                if (!newerVersion(tag, appVersion())) return;
                JSONArray assets = j.optJSONArray("assets");
                if (assets == null) return;
                String url = null;
                for (int i = 0; i < assets.length(); i++) {
                    JSONObject a = assets.optJSONObject(i);
                    if (a != null && "TBBR_Android.apk".equalsIgnoreCase(a.optString("name"))) {
                        url = a.optString("browser_download_url", null);
                        break;
                    }
                }
                if (url == null || url.isEmpty()) return;
                final String fTag = tag, fUrl = url;
                runOnUiThread(() -> showUpdateDialog(fTag, fUrl));
            } catch (Exception e) {
                /* hors ligne ou API indisponible : pas de message, l'app reste utilisable */
            } finally {
                if (c != null) c.disconnect();
            }
        }, "tbbr-update").start();
    }

    static boolean newerVersion(String remote, String local) {
        int[] a = versionParts(remote), b = versionParts(local);
        for (int i = 0; i < 3; i++) if (a[i] != b[i]) return a[i] > b[i];
        return false;
    }

    static int[] versionParts(String s) {
        int[] v = new int[3];
        String[] p = String.valueOf(s == null ? "" : s).replaceAll("^[^0-9]*", "").split("\\.");
        for (int i = 0; i < 3 && i < p.length; i++) {
            try { v[i] = Integer.parseInt(p[i].replaceAll("[^0-9].*$", "")); }
            catch (Exception e) { v[i] = 0; }
        }
        return v;
    }

    void showUpdateDialog(String tag, String url) {
        if (isFinishing() || isDestroyed()) return;
        new AlertDialog.Builder(this)
            .setTitle("TBBR update")
            .setMessage("Version " + tag + " is available (installed: " + appVersion() + ").\n\nDownload and install the APK? Your presets and pedal settings are kept.")
            .setPositiveButton("Download", (d, w) -> requestDownload(url, tag))
            .setNegativeButton("Later", null)
            .show();
    }

    void requestDownload(String url, String tag) {
        if (!canInstallPackages()) {
            pendingUrl = url; pendingTag = tag;
            Toast.makeText(this, "Allow TBBR to install unknown apps, then come back: the download starts automatically.", Toast.LENGTH_LONG).show();
            openInstallSettings();
            return;
        }
        startDownload(url, tag);
    }

    void startDownload(String url, String tag) {
        try {
            DownloadManager dm = (DownloadManager) getSystemService(DOWNLOAD_SERVICE);
            DownloadManager.Request r = new DownloadManager.Request(Uri.parse(url));
            r.setTitle("TBBR " + tag);
            r.setDescription("Downloading the Android app update…");
            r.setMimeType("application/vnd.android.package-archive");
            r.setNotificationVisibility(DownloadManager.Request.VISIBILITY_VISIBLE_NOTIFY_COMPLETED);
            r.setDestinationInExternalFilesDir(this, Environment.DIRECTORY_DOWNLOADS, "TBBR_Android_" + tag + ".apk");
            updateDownload = dm.enqueue(r);
            Toast.makeText(this, "Downloading TBBR " + tag + "…", Toast.LENGTH_SHORT).show();
        } catch (Exception e) {
            Toast.makeText(this, "Download failed: " + e.getMessage(), Toast.LENGTH_LONG).show();
        }
    }

    boolean canInstallPackages() {
        return Build.VERSION.SDK_INT < 26 || getPackageManager().canRequestPackageInstalls();
    }

    void openInstallSettings() {
        try {
            Intent i = new Intent(Settings.ACTION_MANAGE_UNKNOWN_APP_SOURCES, Uri.parse("package:" + getPackageName()));
            startActivity(i);
        } catch (Exception e) {
            try { startActivity(new Intent(Settings.ACTION_MANAGE_UNKNOWN_APP_SOURCES)); }
            catch (Exception ignored) { }
        }
    }

    void installApk(Uri apk) {
        try {
            Intent i = new Intent(Intent.ACTION_VIEW);
            i.setDataAndType(apk, "application/vnd.android.package-archive");
            i.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION | Intent.FLAG_ACTIVITY_NEW_TASK);
            startActivity(i);
        } catch (Exception e) {
            Toast.makeText(this, "Cannot open the installer: " + e.getMessage(), Toast.LENGTH_LONG).show();
        }
    }

    void registerDownloadReceiver() {
        downloadDone = new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                if (!DownloadManager.ACTION_DOWNLOAD_COMPLETE.equals(intent.getAction())) return;
                long id = intent.getLongExtra(DownloadManager.EXTRA_DOWNLOAD_ID, -1);
                if (updateDownload < 0 || id != updateDownload) return;
                updateDownload = -1;
                DownloadManager dm = (DownloadManager) getSystemService(DOWNLOAD_SERVICE);
                Uri apk = dm.getUriForDownloadedFile(id);
                if (apk == null) {
                    Toast.makeText(MainActivity.this, "Download failed.", Toast.LENGTH_LONG).show();
                    return;
                }
                if (canInstallPackages()) installApk(apk);
                else {
                    pendingApk = apk;
                    Toast.makeText(MainActivity.this, "Allow TBBR to install unknown apps, then come back: installation starts automatically.", Toast.LENGTH_LONG).show();
                    openInstallSettings();
                }
            }
        };
        IntentFilter f = new IntentFilter(DownloadManager.ACTION_DOWNLOAD_COMPLETE);
        if (Build.VERSION.SDK_INT >= 33) registerReceiver(downloadDone, f, Context.RECEIVER_EXPORTED);
        else registerReceiver(downloadDone, f);
    }

    static String mime(String p) {
        String l = p.toLowerCase();
        if (l.endsWith(".html")) return "text/html";
        if (l.endsWith(".js")) return "text/javascript";
        if (l.endsWith(".css")) return "text/css";
        if (l.endsWith(".json") || l.endsWith(".webmanifest")) return "application/json";
        if (l.endsWith(".svg")) return "image/svg+xml";
        if (l.endsWith(".png")) return "image/png";
        if (l.endsWith(".woff2")) return "font/woff2";
        if (l.endsWith(".ttf")) return "font/ttf";
        return "application/octet-stream";
    }

    void openExternal(String url) {
        try { startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse(url))); }
        catch (Exception e) { Toast.makeText(this, url, Toast.LENGTH_LONG).show(); }
    }

    @Override
    protected void onActivityResult(int req, int res, Intent data) {
        if (req != PICK_FILE || pending == null) { super.onActivityResult(req, res, data); return; }
        Uri[] out = null;
        if (res == RESULT_OK && data != null) {
            if (data.getClipData() != null) {
                out = new Uri[data.getClipData().getItemCount()];
                for (int k = 0; k < out.length; k++) out[k] = data.getClipData().getItemAt(k).getUri();
            } else if (data.getData() != null) out = new Uri[]{data.getData()};
        }
        pending.onReceiveValue(out);
        pending = null;
    }

    @Override
    protected void onSaveInstanceState(Bundle out) { super.onSaveInstanceState(out); web.saveState(out); }

    @Override
    public void onBackPressed() {
        web.evaluateJavascript("(window.__tbbrBack && window.__tbbrBack()) ? 1 : 0", v -> {
            if (!"1".equals(v)) { if (web.canGoBack()) web.goBack(); else MainActivity.super.onBackPressed(); }
        });
    }

    @Override
    protected void onDestroy() {
        if (downloadDone != null) { try { unregisterReceiver(downloadDone); } catch (Exception ignored) { } downloadDone = null; }
        if (midi != null) midi.closeAll();
        super.onDestroy();
    }

    /** Fonctions de l'app (window.TBBRAndroid) : liens externes et enregistrement de fichiers exportés. */
    class AppBridge {
        @JavascriptInterface
        public void openExternal(String url) { runOnUiThread(() -> MainActivity.this.openExternal(url)); }

        @JavascriptInterface
        public String version() { return appVersion(); }

        /** Vérifie les mises à jour de l'app Android (résultat : dialogue natif). */
        @JavascriptInterface
        public void checkUpdate() { runOnUiThread(() -> checkUpdates(true)); }

        /** Enregistre un fichier exporté (base64) dans Téléchargements ; renvoie le chemin affiché ou "" en cas d'échec. */
        @JavascriptInterface
        public String saveFile(String name, String b64, String mime) {
            byte[] data = Base64.decode(b64, Base64.DEFAULT);
            String safe = name.replaceAll("[\\\\/:*?\"<>|]", "_");
            try {
                if (Build.VERSION.SDK_INT >= 29) {
                    ContentValues v = new ContentValues();
                    v.put(MediaStore.Downloads.DISPLAY_NAME, safe);
                    v.put(MediaStore.Downloads.MIME_TYPE, mime == null || mime.isEmpty() ? "application/octet-stream" : mime);
                    v.put(MediaStore.Downloads.RELATIVE_PATH, Environment.DIRECTORY_DOWNLOADS + "/TBBR");
                    Uri u = getContentResolver().insert(MediaStore.Downloads.EXTERNAL_CONTENT_URI, v);
                    if (u == null) return "";
                    try (OutputStream o = getContentResolver().openOutputStream(u)) { o.write(data); }
                    return "Téléchargements/TBBR/" + safe;
                } else {
                    File dir = new File(getExternalFilesDir(null), "TBBR");
                    if (!dir.exists() && !dir.mkdirs()) return "";
                    File f = new File(dir, safe);
                    try (FileOutputStream o = new FileOutputStream(f)) { o.write(data); }
                    return f.getAbsolutePath();
                }
            } catch (Exception e) {
                return "";
            }
        }
    }
}
