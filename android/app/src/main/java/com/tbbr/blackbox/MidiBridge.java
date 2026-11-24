package com.tbbr.blackbox;

import android.content.Context;
import android.media.midi.MidiDevice;
import android.media.midi.MidiDeviceInfo;
import android.media.midi.MidiInputPort;
import android.media.midi.MidiManager;
import android.media.midi.MidiOutputPort;
import android.media.midi.MidiReceiver;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.util.Base64;
import android.webkit.JavascriptInterface;
import android.webkit.WebView;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.ByteArrayOutputStream;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Set;

/**
 * Pont WebMIDI pour la WebView (window.TBBRMidi), utilisé par assets/app/android-midi.js.
 * Vocabulaire WebMIDI : une « entrée » reçoit de l'appareil (= MidiOutputPort d'Android),
 * une « sortie » envoie vers l'appareil (= MidiInputPort d'Android).
 * Identifiants de port : "in:<id appareil>:<n>" et "out:<id appareil>:<n>".
 */
public class MidiBridge {
    private final Context ctx;
    private final WebView web;
    private final MidiManager mm;
    private final Handler ui = new Handler(Looper.getMainLooper());
    private final Map<Integer, MidiDevice> open = new HashMap<>();
    private final Map<String, MidiInputPort> outs = new HashMap<>();
    private final Map<String, MidiOutputPort> ins = new HashMap<>();
    private final Map<String, Framer> framers = new HashMap<>();

    MidiBridge(Context c, WebView w) {
        ctx = c;
        web = w;
        mm = (MidiManager) c.getSystemService(Context.MIDI_SERVICE);
        if (mm != null) {
            mm.registerDeviceCallback(new MidiManager.DeviceCallback() {
                @Override public void onDeviceAdded(MidiDeviceInfo i) { js("window.__tbbrMidi && window.__tbbrMidi.changed()"); }
                @Override public void onDeviceRemoved(MidiDeviceInfo i) { dropDevice(i.getId()); js("window.__tbbrMidi && window.__tbbrMidi.changed()"); }
            }, ui);
        }
    }

    private void js(String code) { ui.post(() -> web.evaluateJavascript(code, null)); }

    @SuppressWarnings("deprecation")
    private MidiDeviceInfo[] devices() {
        if (mm == null) return new MidiDeviceInfo[0];
        /* Fusionner les deux listes : certains Android 13/14 omettent l'USB MIDI dans getDevicesForTransport. */
        Map<Integer, MidiDeviceInfo> all = new LinkedHashMap<>();
        if (Build.VERSION.SDK_INT >= 33) {
            Set<MidiDeviceInfo> s = mm.getDevicesForTransport(MidiManager.TRANSPORT_MIDI_BYTE_STREAM);
            if (s != null) for (MidiDeviceInfo d : s) all.put(d.getId(), d);
        }
        for (MidiDeviceInfo d : mm.getDevices()) all.put(d.getId(), d);
        return all.values().toArray(new MidiDeviceInfo[0]);
    }

    private static String devName(MidiDeviceInfo d) {
        Bundle p = d.getProperties();
        String prod = p.getString(MidiDeviceInfo.PROPERTY_PRODUCT), name = p.getString(MidiDeviceInfo.PROPERTY_NAME);
        if (prod != null && !prod.isEmpty()) return prod;                // « BlackBox Custom » (chaîne produit USB)
        return name != null ? name : ("MIDI " + d.getId());
    }

    /** Liste JSON des ports : [{id, name, type:"input"|"output", manufacturer}] */
    @JavascriptInterface
    public String list() {
        JSONArray a = new JSONArray();
        try {
            for (MidiDeviceInfo d : devices()) {
                String n = devName(d), man = d.getProperties().getString(MidiDeviceInfo.PROPERTY_MANUFACTURER);
                for (MidiDeviceInfo.PortInfo pi : d.getPorts()) {
                    JSONObject o = new JSONObject();
                    boolean toApp = pi.getType() == MidiDeviceInfo.PortInfo.TYPE_OUTPUT;
                    o.put("id", (toApp ? "in:" : "out:") + d.getId() + ":" + pi.getPortNumber());
                    o.put("name", n);
                    o.put("type", toApp ? "input" : "output");
                    o.put("manufacturer", man == null ? "" : man);
                    a.put(o);
                }
            }
        } catch (Exception ignored) { }
        return a.toString();
    }

    private MidiDeviceInfo find(int id) { for (MidiDeviceInfo d : devices()) if (d.getId() == id) return d; return null; }

    /** Ouvre un port (asynchrone) ; réponse : window.__tbbrMidi.opened(portId, ok) */
    @JavascriptInterface
    public void open(String portId) {
        final String[] f = portId.split(":");
        final int dev = Integer.parseInt(f[1]), num = Integer.parseInt(f[2]);
        final boolean toApp = "in".equals(f[0]);
        Runnable withDevice = () -> {
            MidiDevice d = open.get(dev);
            boolean ok = false;
            if (d != null) {
                if (toApp) {
                    MidiOutputPort p = ins.get(portId);
                    if (p == null) p = d.openOutputPort(num);
                    if (p != null) {
                        ins.put(portId, p);
                        Framer fr = framers.get(portId);
                        if (fr == null) { fr = new Framer(portId); framers.put(portId, fr); p.connect(fr); }
                        ok = true;
                    }
                } else {
                    MidiInputPort p = outs.get(portId);
                    if (p == null) p = d.openInputPort(num);
                    if (p != null) { outs.put(portId, p); ok = true; }
                }
            }
            js("window.__tbbrMidi && window.__tbbrMidi.opened(" + JSONObject.quote(portId) + "," + ok + ")");
        };
        ui.post(() -> {
            if (open.containsKey(dev)) { withDevice.run(); return; }
            MidiDeviceInfo info = find(dev);
            if (info == null || mm == null) { js("window.__tbbrMidi && window.__tbbrMidi.opened(" + JSONObject.quote(portId) + ",false)"); return; }
            mm.openDevice(info, d -> { if (d != null) open.put(dev, d); withDevice.run(); }, ui);
        });
    }

    /** Envoie des octets MIDI (base64) vers l'appareil ; par morceaux (taille maximale d'un paquet Android). */
    @JavascriptInterface
    public boolean send(String portId, String b64) {
        MidiInputPort p = outs.get(portId);
        if (p == null) return false;
        byte[] data = Base64.decode(b64, Base64.DEFAULT);
        try {
            int max = Math.max(64, Math.min(512, p.getMaxMessageSize()));
            for (int o = 0; o < data.length; o += max) p.send(data, o, Math.min(max, data.length - o));
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    @JavascriptInterface
    public void close(String portId) {
        try {
            MidiOutputPort i = ins.remove(portId);
            Framer fr = framers.remove(portId);
            if (i != null) { if (fr != null) i.disconnect(fr); i.close(); }
            MidiInputPort o = outs.remove(portId);
            if (o != null) o.close();
        } catch (Exception ignored) { }
    }

    private void dropDevice(int id) {
        String pre = ":" + id + ":";
        for (String k : ins.keySet().toArray(new String[0])) if (k.contains(pre)) close(k);
        for (String k : outs.keySet().toArray(new String[0])) if (k.contains(pre)) close(k);
        MidiDevice d = open.remove(id);
        try { if (d != null) d.close(); } catch (Exception ignored) { }
    }

    void closeAll() { for (Integer id : open.keySet().toArray(new Integer[0])) dropDevice(id); }

    /** Réassemble le flux reçu en messages complets (SysEx F0 … F7 ; messages courts) puis les passe à la page. */
    private class Framer extends MidiReceiver {
        private final String port;
        private final ByteArrayOutputStream sx = new ByteArrayOutputStream();
        private boolean inSysex;
        private int status, need;
        private final byte[] shortMsg = new byte[3];
        private int have;

        Framer(String p) { port = p; }

        private void emit(byte[] m) { js("window.__tbbrMidi && window.__tbbrMidi.message(" + JSONObject.quote(port) + ",'" + Base64.encodeToString(m, Base64.NO_WRAP) + "')"); }

        @Override
        public void onSend(byte[] msg, int off, int count, long ts) {
            for (int i = off; i < off + count; i++) {
                int b = msg[i] & 0xFF;
                if (b >= 0xF8) { emit(new byte[]{(byte) b}); continue; }             // temps réel : ne coupe rien
                if (b == 0xF0) { inSysex = true; sx.reset(); sx.write(b); continue; }
                if (inSysex) {
                    if (b == 0xF7) { sx.write(b); inSysex = false; emit(sx.toByteArray()); }
                    else if (b >= 0x80) { inSysex = false; i--; }                 // SysEx interrompu : on retraite l'octet
                    else sx.write(b);
                    continue;
                }
                if (b >= 0x80) {
                    status = b; have = 0;
                    int hi = b & 0xF0;
                    need = (hi == 0xC0 || hi == 0xD0 || b == 0xF1 || b == 0xF3) ? 1 : (b == 0xF6 || b == 0xF7) ? 0 : 2;
                    if (need == 0) emit(new byte[]{(byte) b});
                    continue;
                }
                if (status == 0) continue;
                shortMsg[have++] = (byte) b;
                if (have == need) {
                    byte[] m = new byte[need + 1];
                    m[0] = (byte) status;
                    System.arraycopy(shortMsg, 0, m, 1, need);
                    emit(m);
                    have = 0;
                }
            }
        }
    }
}
