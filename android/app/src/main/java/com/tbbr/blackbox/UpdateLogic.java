package com.tbbr.blackbox;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.InputStream;
import java.security.MessageDigest;

/**
 * Logique de mise à jour de l'APK, sans dépendance Android (testée sur JVM : app/src/test).
 * Source : le manifeste TBBR_update.json joint à chaque release GitHub (tools/release_manifest.js) :
 *   apk = { file, size, sha256, versionName, versionCode, minSdk }.
 * On compare le versionCode (toujours croissant, beta comprise) ; l'APK téléchargé doit avoir la taille et le SHA-256
 * annoncés, puis le même nom de paquet, le même versionCode et la même signature que l'app installée.
 */
final class UpdateLogic {
    private UpdateLogic() { }

    static final String MANIFEST = "TBBR_update.json";

    /** Mise à jour proposée. */
    static final class Candidate {
        String versionName, tag, page, notes, apkUrl, sha256, file;
        long versionCode, size;
        int minSdk;
    }

    /** Comparaison semver : >0 si a est plus récente ; « 0.9.6 » passe avant « 0.9.6-beta.3 ». */
    static int compareVersions(String a, String b) {
        String[] x = split(a), y = split(b);
        if (x == null || y == null) return x != null ? 1 : y != null ? -1 : 0;
        for (int i = 0; i < 3; i++) {
            int d = Integer.parseInt(x[i]) - Integer.parseInt(y[i]);
            if (d != 0) return d;
        }
        String p = x[3], q = y[3];
        if (p.isEmpty() || q.isEmpty()) return (p.isEmpty() ? 0 : -1) - (q.isEmpty() ? 0 : -1);
        String[] pp = p.split("\\."), qq = q.split("\\.");
        for (int i = 0; i < Math.max(pp.length, qq.length); i++) {
            if (i >= pp.length) return -1;
            if (i >= qq.length) return 1;
            boolean pn = pp[i].matches("\\d+"), qn = qq[i].matches("\\d+");
            if (pn && qn) { int d = Integer.parseInt(pp[i]) - Integer.parseInt(qq[i]); if (d != 0) return d; }
            else if (pn != qn) return pn ? -1 : 1;
            else { int d = pp[i].compareTo(qq[i]); if (d != 0) return d; }
        }
        return 0;
    }

    private static String[] split(String s) {
        if (s == null) return null;
        java.util.regex.Matcher m = java.util.regex.Pattern.compile("^[vV]?(\\d+)\\.(\\d+)\\.(\\d+)(?:-([0-9A-Za-z.-]+))?$").matcher(s.trim());
        if (!m.matches()) return null;
        return new String[]{m.group(1), m.group(2), m.group(3), m.group(4) == null ? "" : m.group(4)};
    }

    /** Release GitHub (JSON de l'API) + son manifeste -> candidat, ou null si le manifeste est absent ou invalide. */
    static Candidate fromRelease(JSONObject release, JSONObject manifest) {
        if (release == null || manifest == null || !"tbbr-update".equals(manifest.optString("format"))) return null;
        JSONObject apk = manifest.optJSONObject("apk");
        if (apk == null) return null;
        Candidate c = new Candidate();
        c.file = apk.optString("file", "");
        c.size = apk.optLong("size", -1);
        c.sha256 = apk.optString("sha256", "").toLowerCase();
        c.versionCode = apk.optLong("versionCode", -1);
        c.versionName = apk.optString("versionName", manifest.optString("version", ""));
        c.minSdk = apk.optInt("minSdk", 1);
        c.tag = release.optString("tag_name", "");
        c.page = release.optString("html_url", "");
        c.notes = manifest.optString("notes", "");
        if (!c.file.matches("[\\w.-]+\\.apk") || c.size <= 0 || !c.sha256.matches("[0-9a-f]{64}") || c.versionCode <= 0) return null;
        JSONArray assets = release.optJSONArray("assets");
        if (assets == null) return null;
        for (int i = 0; i < assets.length(); i++) {
            JSONObject a = assets.optJSONObject(i);
            if (a != null && c.file.equals(a.optString("name"))) { c.apkUrl = a.optString("browser_download_url", null); break; }
        }
        return c.apkUrl == null || c.apkUrl.isEmpty() ? null : c;
    }

    /** URL du manifeste dans une release, ou null. */
    static String manifestUrl(JSONObject release) {
        JSONArray assets = release == null ? null : release.optJSONArray("assets");
        if (assets == null) return null;
        for (int i = 0; i < assets.length(); i++) {
            JSONObject a = assets.optJSONObject(i);
            if (a != null && MANIFEST.equals(a.optString("name"))) return a.optString("browser_download_url", null);
        }
        return null;
    }

    /** Proposer cette mise à jour ? (plus récente, compatible, pas ignorée par l'utilisateur) */
    static boolean shouldOffer(Candidate c, long installedCode, int sdk, long skippedCode) {
        return c != null && c.versionCode > installedCode && sdk >= c.minSdk && c.versionCode != skippedCode;
    }

    /** Le meilleur de deux candidats (versionCode le plus grand). */
    static Candidate best(Candidate a, Candidate b) {
        if (a == null) return b;
        if (b == null) return a;
        return b.versionCode > a.versionCode ? b : a;
    }

    static String sha256(InputStream in) throws Exception {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] buf = new byte[65536];
        int n;
        while ((n = in.read(buf)) > 0) md.update(buf, 0, n);
        return hex(md.digest());
    }

    static String hex(byte[] d) {
        StringBuilder sb = new StringBuilder();
        for (byte b : d) sb.append(String.format("%02x", b & 0xFF));
        return sb.toString();
    }
}
