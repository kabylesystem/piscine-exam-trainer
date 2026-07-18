#!/usr/bin/env python3
# Ajoute subject_fr a chaque exo du catalogue : traduction FR de l'enonce,
# en gardant intacts les entetes (Assignment name / Expected files / Allowed functions),
# les noms de fichiers/fonctions, le code et les exemples shell.
import json, sys, urllib.request, os

KEY = open(os.path.expanduser("~/.config/king-kusaila/openai.env")).read()
KEY = [l.split("=",1)[1].strip().strip('"\'') for l in KEY.splitlines() if l.startswith("OPENAI_API_KEY=")][0]
CAT = sys.argv[1] if len(sys.argv) > 1 else "public/catalog.json"

SYS = ("You translate 42 School C exercise subjects from English to French. "
       "Rules: keep the header lines 'Assignment name', 'Expected files', 'Allowed functions' "
       "and their values EXACTLY unchanged. Never translate the exercise name, file names, "
       "function names, C code, prototypes, or shell command examples ($> ...). Keep the exact "
       "same layout, dashes and line breaks. Translate ONLY the prose description into natural, "
       "correct French in the concise style of real 42 subjects. Output only the translated subject.")

def translate(text):
    body = json.dumps({
        "model": "gpt-4o-mini",
        "messages": [{"role":"system","content":SYS},{"role":"user","content":text}],
        "temperature": 0,
    }).encode()
    req = urllib.request.Request("https://api.openai.com/v1/chat/completions", data=body,
        headers={"Authorization":"Bearer "+KEY, "Content-Type":"application/json"})
    r = json.load(urllib.request.urlopen(req, timeout=90))
    return r["choices"][0]["message"]["content"].strip()

d = json.load(open(CAT))
ex = d["exercises"]
for i, e in enumerate(ex):
    if e.get("subject_fr"):
        continue
    try:
        e["subject_fr"] = translate(e["subject"])
        sys.stderr.write(f"[{i+1}/{len(ex)}] {e['name']} ok\n")
    except Exception as err:
        e["subject_fr"] = ""
        sys.stderr.write(f"[{i+1}/{len(ex)}] {e['name']} FAIL {str(err)[:80]}\n")
json.dump(d, open(CAT,"w"), ensure_ascii=False)
sys.stderr.write("done\n")
