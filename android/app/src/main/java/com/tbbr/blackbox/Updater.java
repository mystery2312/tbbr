package com.tbbr.blackbox;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageInstaller;
import android.content.pm.PackageManager;
import android.content.pm.Signature;
import android.net.Uri;
import android.os.Build;
import android.provider.Settings;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.security.MessageDigest;
import java.util.Arrays;
import java.util.Locale;

/**
 * Mise à jour de l'app Android depuis GitHub Releases.
 *   1. vérification au lancement puis toutes les 6 h (30 min après un échec réseau) ; manuelle depuis l'éditeur ;
 *   2. manifeste TBBR_update.json : versionCode, taille, SHA-256 (UpdateLogic) ; une beta reçoit aussi la stable ;
 *   3. téléchargement DANS l'app, avec progression et annulation, dans le cache privé ;
 *   4. contrôles avant installation : taille + SHA-256, puis nom de paquet, versionCode et certificat de signature
 *      identiques à l'app installée (un APK modifié ou signé par un autre est refusé) ;
 *   5. installation par PackageInstaller (session) : Android demande une seule confirmation, le résultat revient à l'app.
 */
final class Updater {
    static final String STABLE = "mystery2312/tbbr", BETA = "mystery2312/tbbr-beta";
    static final String ACTION_STATUS = "com.tbbr.blackbox.INSTALL_STATUS";
    private static final long EVERY = 6 * 60 * 60 * 1000L, RETRY = 30 * 60 * 1000L;

    private final Activity act;
    private final SharedPreferences prefs;
    private final String api;
    private boolean busy;
    private volatile boolean cancelled;
    private UpdateLogic.Candidate waitingPermission;
    private File readyApk;
    private BroadcastReceiver statusReceiver;

    Updater(Activity a) {
        act = a;
        prefs = a.getSharedPreferences("tbbr", Context.MODE_PRIVATE);
        /* tests : une build de débogage peut viser un faux GitHub (extra « tbbr.updateApi » au lancement) */
        String o = a.getIntent() == null ? null : a.getIntent().getStringExtra("tbbr.updateApi");
        boolean debug = (a.getApplicationInfo().flags & ApplicationInfo.FLAG_DEBUGGABLE) != 0;
        api = debug && o != null && o.startsWith("http") ? o.replaceAll("/$", "") : "https://api.github.com";
        registerStatusReceiver();
    }

    private boolean fr() { return Locale.getDefault().getLanguage().startsWith("fr"); }
    private String t(String f, String e) { return fr() ? f : e; }

    String installedName() {
        try { return act.getPackageManager().getPackageInfo(act.getPackageName(), 0).versionName; } catch (Exception e) { return "0.0.0"; }
    }
    @SuppressWarnings("deprecation")
    long installedCode() {
        try {
            PackageInfo p = act.getPackageManager().getPackageInfo(act.getPackageName(), 0);
            return Build.VERSION.SDK_INT >= 28 ? p.getLongVersionCode() : p.versionCode;
        } catch (Exception e) { return 0; }
    }

    /* ---------------- 1-2. vérification ---------------- */
    void check(boolean manual) {
        long now = System.currentTimeMillis();
        if (!manual && (busy || now < prefs.getLong("nextCheck", 0))) return;
        if (busy) { if (manual) toast(t("Vérification déjà en cours…", "Already checking…")); return; }
        busy = true;
        new Thread(() -> {
            UpdateLogic.Candidate best = null;
            boolean reached = false;
            try {
                try { best = UpdateLogic.best(best, fromLatest(STABLE)); reached = true; } catch (Exception ignored) { }
                if (installedName().contains("-beta")) {                         // dépôt beta souvent privé : sans gravité
                    try { best = UpdateLogic.best(best, fromList(BETA)); reached = true; } catch (Exception ignored) { }
                }
            } finally {
                prefs.edit().putLong("nextCheck", System.currentTimeMillis() + (reached ? EVERY : RETRY)).apply();
                final UpdateLogic.Candidate c = best;
                final boolean ok = reached;
                act.runOnUiThread(() -> {
                    busy = false;
                    long skipped = manual ? -1 : prefs.getLong("skipCode", -1);
                    if (UpdateLogic.shouldOffer(c, installedCode(), Build.VERSION.SDK_INT, skipped)) offer(c);
                    else if (manual) toast(ok ? t("L’app est à jour (" + installedName() + ").", "The app is up to date (" + installedName() + ").")
                                              : t("GitHub injoignable : réessaie plus tard.", "Cannot reach GitHub: try again later."));
                });
            }
        }, "tbbr-update").start();
    }

    private UpdateLogic.Candidate fromLatest(String repo) throws Exception {
        JSONObject rel = new JSONObject(get(api + "/repos/" + repo + "/releases/latest"));
        return fromRelease(rel);
    }
    private UpdateLogic.Candidate fromList(String repo) throws Exception {
        JSONArray list = new JSONArray(get(api + "/repos/" + repo + "/releases?per_page=10"));
        for (int i = 0; i < list.length(); i++) {
            JSONObject rel = list.getJSONObject(i);
            if (rel.optBoolean("draft")) continue;
            UpdateLogic.Candidate c = fromRelease(rel);
            if (c != null) return c;
        }
        return null;
    }
    private UpdateLogic.Candidate fromRelease(JSONObject rel) throws Exception {
        String mu = UpdateLogic.manifestUrl(rel);
        if (mu == null) return null;                                        // ancienne release sans manifeste : rien d'automatique
        return UpdateLogic.fromRelease(rel, new JSONObject(get(mu)));
    }
    private static String get(String url) throws Exception {
        HttpURLConnection c = (HttpURLConnection) new URL(url).openConnection();
        try {
            c.setConnectTimeout(10000); c.setReadTimeout(15000);
            c.setRequestProperty("Accept", "application/vnd.github+json");
            c.setRequestProperty("User-Agent", "TBBR-Android");
            if (c.getResponseCode() != 200) throw new Exception("HTTP " + c.getResponseCode());
            StringBuilder sb = new StringBuilder();
            try (BufferedReader r = new BufferedReader(new InputStreamReader(c.getInputStream(), "UTF-8"))) {
                String l; while ((l = r.readLine()) != null) sb.append(l).append('\n');
            }
            return sb.toString();
        } finally { c.disconnect(); }
    }

    private void offer(UpdateLogic.Candidate c) {
        if (act.isFinishing() || act.isDestroyed()) return;
        String notes = c.notes == null ? "" : c.notes.replaceAll("(?m)^#+\\s*", "").trim();
        if (notes.length() > 600) notes = notes.substring(0, 600) + "…";
        new AlertDialog.Builder(act)
            .setTitle(t("Mise à jour TBBR " + c.versionName, "TBBR update " + c.versionName))
            .setMessage(t("Installée : " + installedName() + ". Taille : " + (c.size / 1024) + " Ko.\nPresets, IR et captures sont conservés.",
                          "Installed: " + installedName() + ". Size: " + (c.size / 1024) + " KB.\nPresets, IRs and captures are kept.")
                        + (notes.isEmpty() ? "" : "\n\n" + notes))
            .setPositiveButton(t("Mettre à jour", "Update"), (d, w) -> start(c))
            .setNeutralButton(t("Ignorer cette version", "Skip this version"), (d, w) -> prefs.edit().putLong("skipCode", c.versionCode).apply())
            .setNegativeButton(t("Plus tard", "Later"), null)
            .show();
    }

    /* ---------------- 3. téléchargement ---------------- */
    private void start(UpdateLogic.Candidate c) {
        if (!canInstall()) {
            waitingPermission = c;
            toast(t("Autorise TBBR à installer des applis, puis reviens : la mise à jour continue toute seule.",
                    "Allow TBBR to install apps, then come back: the update continues automatically."));
            openInstallSettings();
            return;
        }
        cancelled = false;
        ProgressBar bar = new ProgressBar(act, null, android.R.attr.progressBarStyleHorizontal);
        bar.setMax(1000);
        TextView label = new TextView(act);
        LinearLayout box = new LinearLayout(act);
        box.setOrientation(LinearLayout.VERTICAL);
        int pad = (int) (20 * act.getResources().getDisplayMetrics().density);
        box.setPadding(pad, pad / 2, pad, 0);
        box.addView(bar); box.addView(label);
        AlertDialog dlg = new AlertDialog.Builder(act)
            .setTitle(t("Téléchargement de TBBR " + c.versionName, "Downloading TBBR " + c.versionName))
            .setView(box).setCancelable(false)
            .setNegativeButton(t("Annuler", "Cancel"), (d, w) -> cancelled = true)
            .show();
        new Thread(() -> {
            File f = null;
            String err = null;
            try { f = download(c, frac -> act.runOnUiThread(() -> { bar.setProgress((int) (frac * 1000)); label.setText(Math.round(frac * 100) + " %"); })); }
            catch (Exception e) { err = e.getMessage(); }
            final File apk = f; final String error = err;
            act.runOnUiThread(() -> {
                try { dlg.dismiss(); } catch (Exception ignored) { }
                if (apk != null) install(apk);
                else if (!cancelled) new AlertDialog.Builder(act).setTitle(t("Mise à jour impossible", "Update failed"))
                    .setMessage(error).setPositiveButton("OK", null).show();
            });
        }, "tbbr-download").start();
    }

    interface Progress { void at(double f); }

    private File download(UpdateLogic.Candidate c, Progress p) throws Exception {
        File dir = new File(act.getCacheDir(), "updates");
        if (!dir.exists() && !dir.mkdirs()) throw new Exception("cache");
        File[] old = dir.listFiles();
        if (old != null) for (File o : old) if (!o.getName().equals("tbbr-" + c.versionCode + ".apk")) o.delete();
        File out = new File(dir, "tbbr-" + c.versionCode + ".apk");
        if (!(out.exists() && out.length() == c.size && c.sha256.equals(sha256(out)))) {
            File part = new File(dir, out.getName() + ".part");
            HttpURLConnection h = (HttpURLConnection) new URL(c.apkUrl).openConnection();
            h.setConnectTimeout(15000); h.setReadTimeout(30000);
            h.setRequestProperty("User-Agent", "TBBR-Android");
            h.setInstanceFollowRedirects(true);
            if (h.getResponseCode() != 200) throw new Exception("HTTP " + h.getResponseCode());
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            long got = 0;
            try (InputStream in = h.getInputStream(); OutputStream o = new FileOutputStream(part)) {
                byte[] buf = new byte[65536];
                int n;
                while ((n = in.read(buf)) > 0) {
                    if (cancelled) throw new Exception(t("annulé", "cancelled"));
                    got += n;
                    if (got > c.size) throw new Exception(t("fichier plus gros qu’annoncé", "file larger than announced"));
                    md.update(buf, 0, n); o.write(buf, 0, n);
                    p.at((double) got / c.size);
                }
            } finally { h.disconnect(); }
            String sum = UpdateLogic.hex(md.digest());
            if (got != c.size || !sum.equals(c.sha256)) {
                part.delete();
                throw new Exception(t("fichier refusé : empreinte SHA-256 différente de celle publiée.", "file rejected: SHA-256 differs from the published one."));
            }
            if (out.exists()) out.delete();
            if (!part.renameTo(out)) throw new Exception("rename");
        }
        verifyPackage(out, c);
        return out;
    }
    private static String sha256(File f) throws Exception { try (InputStream in = new FileInputStream(f)) { return UpdateLogic.sha256(in); } }

    /* ---------------- 4. contrôle du paquet ---------------- */
    @SuppressWarnings("deprecation")
    private void verifyPackage(File apk, UpdateLogic.Candidate c) throws Exception {
        PackageManager pm = act.getPackageManager();
        int flags = Build.VERSION.SDK_INT >= 28 ? PackageManager.GET_SIGNING_CERTIFICATES : PackageManager.GET_SIGNATURES;
        PackageInfo n = pm.getPackageArchiveInfo(apk.getAbsolutePath(), flags);
        PackageInfo cur = pm.getPackageInfo(act.getPackageName(), flags);
        if (n == null) throw new Exception(t("APK illisible", "unreadable APK"));
        if (!act.getPackageName().equals(n.packageName)) throw new Exception(t("APK d’une autre application", "APK of another app"));
        long code = Build.VERSION.SDK_INT >= 28 ? n.getLongVersionCode() : n.versionCode;
        if (code != c.versionCode) throw new Exception(t("version de l’APK différente du manifeste", "APK version differs from the manifest"));
        if (!Arrays.equals(certs(n), certs(cur))) throw new Exception(t("APK signé par une autre clé : refusé", "APK signed with another key: rejected"));
    }
    @SuppressWarnings("deprecation")
    private static String[] certs(PackageInfo p) throws Exception {
        Signature[] s;
        if (Build.VERSION.SDK_INT >= 28 && p.signingInfo != null)
            s = p.signingInfo.hasMultipleSigners() ? p.signingInfo.getApkContentsSigners() : p.signingInfo.getSigningCertificateHistory();
        else s = p.signatures;
        if (s == null) return new String[0];
        String[] out = new String[s.length];
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        for (int i = 0; i < s.length; i++) out[i] = UpdateLogic.hex(md.digest(s[i].toByteArray()));
        Arrays.sort(out);
        return out;
    }

    /* ---------------- 5. installation ---------------- */
    boolean canInstall() { return Build.VERSION.SDK_INT < 26 || act.getPackageManager().canRequestPackageInstalls(); }

    private void openInstallSettings() {
        try { act.startActivity(new Intent(Settings.ACTION_MANAGE_UNKNOWN_APP_SOURCES, Uri.parse("package:" + act.getPackageName()))); }
        catch (Exception e) { try { act.startActivity(new Intent(Settings.ACTION_MANAGE_UNKNOWN_APP_SOURCES)); } catch (Exception ignored) { } }
    }

    /** Retour dans l'app (onResume) : reprend une mise à jour en attente de l'autorisation d'installer. */
    void resume() {
        if (!canInstall()) return;
        if (readyApk != null) { File f = readyApk; readyApk = null; install(f); }
        else if (waitingPermission != null) { UpdateLogic.Candidate c = waitingPermission; waitingPermission = null; start(c); }
    }

    private void install(File apk) {
        if (!canInstall()) { readyApk = apk; openInstallSettings(); return; }
        try {
            PackageInstaller pi = act.getPackageManager().getPackageInstaller();
            PackageInstaller.SessionParams sp = new PackageInstaller.SessionParams(PackageInstaller.SessionParams.MODE_FULL_INSTALL);
            sp.setAppPackageName(act.getPackageName());
            if (Build.VERSION.SDK_INT >= 31) sp.setRequireUserAction(PackageInstaller.SessionParams.USER_ACTION_NOT_REQUIRED);
            int id = pi.createSession(sp);
            try (PackageInstaller.Session s = pi.openSession(id)) {
                try (InputStream in = new FileInputStream(apk); OutputStream o = s.openWrite("tbbr.apk", 0, apk.length())) {
                    byte[] buf = new byte[65536]; int n;
                    while ((n = in.read(buf)) > 0) o.write(buf, 0, n);
                    s.fsync(o);
                }
                Intent i = new Intent(ACTION_STATUS).setPackage(act.getPackageName());
                int fl = PendingIntent.FLAG_UPDATE_CURRENT | (Build.VERSION.SDK_INT >= 31 ? PendingIntent.FLAG_MUTABLE : 0);
                s.commit(PendingIntent.getBroadcast(act, id, i, fl).getIntentSender());
            }
        } catch (Exception e) {
            new AlertDialog.Builder(act).setTitle(t("Installation impossible", "Install failed")).setMessage(String.valueOf(e.getMessage()))
                .setPositiveButton("OK", null).show();
        }
    }

    private void registerStatusReceiver() {
        statusReceiver = new BroadcastReceiver() {
            @Override public void onReceive(Context ctx, Intent in) {
                int st = in.getIntExtra(PackageInstaller.EXTRA_STATUS, PackageInstaller.STATUS_FAILURE);
                if (st == PackageInstaller.STATUS_PENDING_USER_ACTION) {
                    Intent confirm = in.getParcelableExtra(Intent.EXTRA_INTENT);
                    if (confirm != null) { confirm.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK); try { act.startActivity(confirm); } catch (Exception ignored) { } }
                } else if (st != PackageInstaller.STATUS_SUCCESS) {
                    String msg = in.getStringExtra(PackageInstaller.EXTRA_STATUS_MESSAGE);
                    if (st != PackageInstaller.STATUS_FAILURE_ABORTED)
                        new AlertDialog.Builder(act).setTitle(t("Installation impossible", "Install failed"))
                            .setMessage(msg == null ? "" : msg).setPositiveButton("OK", null).show();
                }
            }
        };
        IntentFilter f = new IntentFilter(ACTION_STATUS);
        if (Build.VERSION.SDK_INT >= 33) act.registerReceiver(statusReceiver, f, Context.RECEIVER_NOT_EXPORTED);
        else act.registerReceiver(statusReceiver, f);
    }

    void destroy() { if (statusReceiver != null) { try { act.unregisterReceiver(statusReceiver); } catch (Exception ignored) { } statusReceiver = null; } }

    private void toast(String s) { Toast.makeText(act, s, Toast.LENGTH_LONG).show(); }
}
