#!/usr/bin/env python3
# Genere catalog.json depuis le trainer : type F/P, sujet, harness, headers, signature,
# jeux de test extraits des testers, et sorties ATTENDUES calculees depuis la reference.
import os, re, json, subprocess, tempfile, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, "..", "..", ".resources", "rank02"))
LEVELS = ["level0","level1","level2","level3","level4","level5"]

def sh(cmd, timeout=15):
    try:
        r = subprocess.run(["bash","-c",cmd], capture_output=True, text=True, timeout=timeout)
        return r.returncode, r.stdout, r.stderr
    except subprocess.TimeoutExpired:
        return 124, "", "timeout"

def read(p):
    try:
        with open(p, "r", errors="replace") as f: return f.read()
    except: return ""

def extract_argportions(tester_src):
    has_check_fn = bool(re.search(r'^\s*check\s*\(\)', tester_src, re.M))
    ports = []
    for line in tester_src.splitlines():
        s = line.strip()
        if s.startswith("#"): continue
        if has_check_fn:
            m = re.match(r'check(?:\s+(.*))?$', s)
            if m and not s.startswith("check()") and not s.startswith("check ()"):
                ports.append((m.group(1) or "").strip())
        else:
            m = re.search(r'\./out1\s*(.*?)\s*[12]?>', s)
            if m:
                ports.append(m.group(1).strip())
    seen=set(); out=[]
    for p in ports:
        if p not in seen: seen.add(p); out.append(p)
    return out

catalog = []
warnings = []
for lvl in LEVELS:
    ldir = os.path.join(ROOT, lvl)
    for exo in sorted(os.listdir(ldir)):
        d = os.path.join(ldir, exo)
        if not os.path.isdir(d): continue
        sub = read(os.path.join(d, "sub.txt"))
        has_main = os.path.exists(os.path.join(d, "main.c"))
        headers = [h for h in os.listdir(d) if h.endswith(".h")]
        ref = os.path.join(d, exo + ".c")
        if not os.path.exists(ref):
            cands = [c for c in os.listdir(d) if c.endswith(".c") and c != "main.c"]
            if not cands:
                warnings.append(f"{lvl}/{exo}: pas de ref .c"); continue
            ref = os.path.join(d, cands[0])
        allowed = ""
        m = re.search(r'Allowed functions\s*:\s*(.*)', sub)
        if m: allowed = m.group(1).strip()
        title = exo
        m = re.search(r'Assignment name\s*:\s*(.*)', sub)
        if m: title = m.group(1).strip()

        tmp = tempfile.mkdtemp()
        binp = os.path.join(tmp, "ref")
        extra_c = os.path.join(d, "main.c") if has_main else ""
        inc = f"-I{d}" if headers else ""
        rc,_,err = sh(f'gcc -std=gnu17 -w {inc} -o "{binp}" "{ref}" {extra_c}')
        if rc != 0:
            warnings.append(f"{lvl}/{exo}: ref ne compile pas: {err[:120]}")
            continue

        tester = read(os.path.join(d, "tester.sh"))
        ports = extract_argportions(tester)
        if not ports: ports = [""]
        tests = []
        for port in ports:
            rc,argsout,_ = sh(f"printf '%s\\n' {port}" if port else "true")
            args = [a for a in argsout.split("\n")] if port else []
            if args and args[-1] == "": args = args[:-1]
            rc,out,_ = sh(f'"{binp}" {port}')
            tests.append({"args": args, "expected": out})

        header_files = {h: read(os.path.join(d, h)) for h in headers}
        harness = read(os.path.join(d, "main.c")) if has_main else ""

        sig = ""
        if has_main:
            refsrc = read(ref)
            for line in refsrc.splitlines():
                if re.match(r'^[A-Za-z].*\b' + re.escape(exo) + r'\s*\(', line) and "return" not in line:
                    sig = line.rstrip().rstrip("{").rstrip()
                    break

        catalog.append({
            "level": int(lvl[-1]),
            "name": exo,
            "title": title,
            "type": "F" if has_main else "P",
            "allowed": allowed,
            "subject": sub.rstrip(),
            "harness": harness,
            "headers": header_files,
            "sig": sig,
            "tests": tests,
        })

out = {"exercises": catalog}
print(json.dumps(out, ensure_ascii=False))
sys.stderr.write(f"\n== {len(catalog)} exos, {sum(len(e['tests']) for e in catalog)} tests ==\n")
for w in warnings: sys.stderr.write("WARN "+w+"\n")
