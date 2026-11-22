"""serve.py : sert l'app en local sur http://localhost:8080 (le MIDI web de Chrome/Edge exige localhost ou HTTPS).
Usage : python serve.py   puis ouvrir http://localhost:8080/index.html dans Chrome ou Edge, onglet Appareil -> USB-C (MIDI)."""
import http.server, os, subprocess, sys, functools
here = os.path.dirname(os.path.abspath(__file__))
subprocess.check_call([sys.executable, "-I", os.path.join(here, "make_static.py")])
handler = functools.partial(http.server.SimpleHTTPRequestHandler, directory=here)
handler.extensions_map[".webmanifest"] = "application/manifest+json"
print("App : http://localhost:8080/index.html   (Ctrl+C pour arrêter)")
http.server.ThreadingHTTPServer(("127.0.0.1", 8080), handler).serve_forever()
