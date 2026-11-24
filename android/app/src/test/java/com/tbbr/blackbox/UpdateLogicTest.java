package com.tbbr.blackbox;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;

import org.json.JSONArray;
import org.json.JSONObject;
import org.junit.Test;

import java.io.ByteArrayInputStream;

/** Logique de mise à jour de l'APK (lancé par gradlew testReleaseUnitTest, et par tests/e2e/apk.test.js). */
public class UpdateLogicTest {
    private static final String SHA = "ab".repeat(32);

    private static JSONObject release(String tag, String... assets) throws Exception {
        JSONArray a = new JSONArray();
        for (String n : assets) a.put(new JSONObject().put("name", n).put("browser_download_url", "https://x/" + n));
        return new JSONObject().put("tag_name", tag).put("html_url", "https://x/rel/" + tag).put("assets", a);
    }
    private static JSONObject manifest(long code, String sha) throws Exception {
        return new JSONObject().put("format", "tbbr-update").put("version", "0.9.7").put("notes", "notes")
            .put("apk", new JSONObject().put("file", "TBBR_Android.apk").put("size", 1234).put("sha256", sha)
                .put("versionName", "0.9.7").put("versionCode", code).put("minSdk", 24));
    }

    @Test public void versions() {
        assertTrue(UpdateLogic.compareVersions("0.9.6", "0.9.6-beta.3") > 0);       // la stable remplace la beta
        assertTrue(UpdateLogic.compareVersions("0.9.6-beta.10", "0.9.6-beta.3") > 0);
        assertTrue(UpdateLogic.compareVersions("v0.10.0", "0.9.9") > 0);
        assertEquals(0, UpdateLogic.compareVersions("0.9.6", "v0.9.6"));
        assertTrue(UpdateLogic.compareVersions("0.9.5", "0.9.6-beta.1") < 0);
        assertTrue(UpdateLogic.compareVersions("n'importe quoi", "0.9.6") < 0);
    }

    @Test public void manifestValide() throws Exception {
        JSONObject r = release("v0.9.7", "TBBR_Android.apk", "TBBR_update.json");
        assertEquals("https://x/TBBR_update.json", UpdateLogic.manifestUrl(r));
        UpdateLogic.Candidate c = UpdateLogic.fromRelease(r, manifest(910, SHA));
        assertNotNull(c);
        assertEquals(910, c.versionCode);
        assertEquals("https://x/TBBR_Android.apk", c.apkUrl);
        assertEquals(SHA, c.sha256);
    }

    @Test public void manifestRefuse() throws Exception {
        JSONObject r = release("v0.9.7", "TBBR_Android.apk", "TBBR_update.json");
        assertNull(UpdateLogic.fromRelease(r, manifest(910, "zz")));                   // empreinte invalide
        assertNull(UpdateLogic.fromRelease(r, manifest(0, SHA)));                      // versionCode absent
        assertNull(UpdateLogic.fromRelease(release("v0.9.7", "TBBR_update.json"), manifest(910, SHA)));   // APK absent
        assertNull(UpdateLogic.manifestUrl(release("v0.9.0", "TBBR_Android.apk")));   // ancienne release
        assertNull(UpdateLogic.fromRelease(r, new JSONObject().put("format", "autre")));
    }

    @Test public void decision() throws Exception {
        UpdateLogic.Candidate c = UpdateLogic.fromRelease(release("v0.9.7", "TBBR_Android.apk", "TBBR_update.json"), manifest(910, SHA));
        assertTrue(UpdateLogic.shouldOffer(c, 908, 34, -1));
        assertFalse(UpdateLogic.shouldOffer(c, 910, 34, -1));                          // déjà installée
        assertFalse(UpdateLogic.shouldOffer(c, 908, 23, -1));                          // Android trop ancien
        assertFalse(UpdateLogic.shouldOffer(c, 908, 34, 910));                         // ignorée par l'utilisateur
        assertFalse(UpdateLogic.shouldOffer(null, 908, 34, -1));
        UpdateLogic.Candidate b = UpdateLogic.fromRelease(release("v0.9.8-beta.1", "TBBR_Android.apk", "TBBR_update.json"), manifest(911, SHA));
        assertEquals(911, UpdateLogic.best(c, b).versionCode);
        assertEquals(910, UpdateLogic.best(c, null).versionCode);
    }

    @Test public void empreinte() throws Exception {
        assertEquals("ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad",
            UpdateLogic.sha256(new ByteArrayInputStream("abc".getBytes("US-ASCII"))));
    }
}
