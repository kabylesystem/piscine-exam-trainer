import { useEffect, useMemo, useState, useCallback } from "react";
import CodeMirror from "@uiw/react-codemirror";
import { cpp } from "@codemirror/lang-cpp";
import { oneDark } from "@codemirror/theme-one-dark";
import type { Catalog, Exercise } from "./types";
import { grade, type RunResult } from "./wandbox";
import "./theme.css";
import "./app.css";

const LEVELS = [
  { n: 0, label: "Warm-up", v: "var(--lvl0)" },
  { n: 1, label: "Functions", v: "var(--lvl1)" },
  { n: 2, label: "Strings", v: "var(--lvl2)" },
  { n: 3, label: "Parsing", v: "var(--lvl3)" },
  { n: 4, label: "Full pool", v: "var(--lvl4)" },
  { n: 5, label: "Boss", v: "var(--lvl5)" },
];

const CLEARED_KEY = "pe_cleared_v1";
const codeKey = (name: string) => "pe_code_" + name;

function loadCleared(): Set<string> {
  try { return new Set(JSON.parse(localStorage.getItem(CLEARED_KEY) || "[]")); }
  catch { return new Set(); }
}
function saveCleared(s: Set<string>) {
  localStorage.setItem(CLEARED_KEY, JSON.stringify([...s]));
}

function extractDecl(subject: string): string | null {
  const m = subject.match(/(?:declared as follows|prototyped(?:[^:\n]*))\s*:?\s*\n+\s*([^\n]+)/i);
  if (m) return m[1].trim().replace(/;?\s*$/, ";");
  return null;
}

function starterFor(ex: Exercise): string {
  if (ex.type === "F") {
    const decl = ex.sig || extractDecl(ex.subject);
    const proto = decl ? decl.replace(/;?\s*$/, "") : `void ${ex.name}(void)`;
    const inc = ex.allowed.toLowerCase().includes("malloc") ? "#include <stdlib.h>\n" : "";
    const wr = ex.allowed.toLowerCase().includes("write") ? "#include <unistd.h>\n" : "";
    const hdr = Object.keys(ex.headers)[0];
    const hinc = hdr ? `#include "${hdr}"\n` : "";
    return `${wr}${inc}${hinc}\n${proto}\n{\n\t\n}\n`;
  }
  const wr = ex.allowed.toLowerCase().includes("write") ? "#include <unistd.h>\n" : "";
  return `${wr}\nint\tmain(int argc, char **argv)\n{\n\t(void)argc;\n\t(void)argv;\n\t\n\treturn (0);\n}\n`;
}

type View = { kind: "home" } | { kind: "level"; n: number } | { kind: "mission"; name: string };

export default function App() {
  const [cat, setCat] = useState<Catalog | null>(null);
  const [view, setView] = useState<View>({ kind: "home" });
  const [cleared, setCleared] = useState<Set<string>>(loadCleared());

  useEffect(() => {
    fetch("catalog.json").then((r) => r.json()).then(setCat).catch(() => setCat({ exercises: [] }));
  }, []);

  const markCleared = useCallback((name: string) => {
    setCleared((prev) => {
      const s = new Set(prev); s.add(name); saveCleared(s); return s;
    });
  }, []);

  if (!cat) return <Boot />;

  const total = cat.exercises.length;
  const done = cat.exercises.filter((e) => cleared.has(e.name)).length;

  return (
    <div className="shell">
      <Header done={done} total={total} onHome={() => setView({ kind: "home" })} />
      {view.kind === "home" && <Home cat={cat} cleared={cleared} onPick={(n) => setView({ kind: "level", n })} />}
      {view.kind === "level" && (
        <LevelView
          cat={cat} level={view.n} cleared={cleared}
          onBack={() => setView({ kind: "home" })}
          onPick={(name) => setView({ kind: "mission", name })}
        />
      )}
      {view.kind === "mission" && (
        <Mission
          cat={cat} name={view.name} cleared={cleared}
          onBack={() => setView({ kind: "level", n: cat.exercises.find((e) => e.name === view.name)!.level })}
          onCleared={markCleared}
          onNext={(name) => setView({ kind: "mission", name })}
        />
      )}
    </div>
  );
}

function Boot() {
  return <div className="boot"><span className="pix" style={{ color: "var(--green)" }}>LOADING…</span></div>;
}

function Header({ done, total, onHome }: { done: number; total: number; onHome: () => void }) {
  return (
    <header className="hdr">
      <button className="wordmark ghost" onClick={onHome} title="Home">
        <span style={{ color: "var(--green)" }}>PISCINE</span>
        <span className="dim">.EXE</span>
      </button>
      <div className="hdr-right">
        <span className="chip done">{done}/{total} cleared</span>
        <a className="chip" href="https://github.com/kabylesystem/piscine-exam-trainer" target="_blank" rel="noreferrer">github</a>
      </div>
    </header>
  );
}

function Home({ cat, cleared, onPick }: { cat: Catalog; cleared: Set<string>; onPick: (n: number) => void }) {
  return (
    <main className="page">
      <section className="hero">
        <div className="hero-text">
          <h1 className="title">READY,<br /><span style={{ color: "var(--green)" }}>PISCINER?</span></h1>
          <p className="tagline">The 42 piscine exam, arcade style. Pick a mission, write C, hit run. <span style={{ color: "var(--green)" }}>PASS</span> or <span style={{ color: "var(--red)" }}>FAIL</span>.</p>
          <p className="tagline-sub">No install. Runs in any browser, phone included. 📱</p>
        </div>
        <img className="hero-mascot" src="mascot.png" alt="" aria-hidden="true" />
      </section>
      <section className="grid levels">
        {LEVELS.map((l) => {
          const exos = cat.exercises.filter((e) => e.level === l.n);
          const c = exos.filter((e) => cleared.has(e.name)).length;
          return (
            <button key={l.n} className="lvl-card box" onClick={() => onPick(l.n)} style={{ borderColor: l.v }}>
              <div className="lvl-n" style={{ color: l.v }}>L{l.n}</div>
              <div className="lvl-label pix">{l.label}</div>
              <div className="lvl-meta">{c}/{exos.length}</div>
              <Bar frac={exos.length ? c / exos.length : 0} color={l.v} />
            </button>
          );
        })}
      </section>
    </main>
  );
}

function Bar({ frac, color }: { frac: number; color: string }) {
  const cells = 10;
  const on = Math.round(frac * cells);
  return (
    <div className="bar">
      {Array.from({ length: cells }).map((_, i) => (
        <span key={i} className="bar-cell" style={{ background: i < on ? color : "var(--line)" }} />
      ))}
    </div>
  );
}

function LevelView({ cat, level, cleared, onBack, onPick }: {
  cat: Catalog; level: number; cleared: Set<string>; onBack: () => void; onPick: (name: string) => void;
}) {
  const l = LEVELS[level];
  const exos = cat.exercises.filter((e) => e.level === level);
  return (
    <main className="page">
      <div className="crumb">
        <button className="ghost" onClick={onBack}>&larr; levels</button>
        <span className="pix" style={{ color: l.v }}>Level {level} · {l.label}</span>
      </div>
      <section className="grid missions">
        {exos.map((e) => (
          <button key={e.name} className="mission-card box" onClick={() => onPick(e.name)}>
            <div className="mc-top">
              <span className={"chip " + (e.type === "F" ? "f" : "p")}>{e.type === "F" ? "fn" : "prog"}</span>
              {e.hot && <span className="chip hot">hot</span>}
              {cleared.has(e.name) && <span className="chip done">✓</span>}
            </div>
            <div className="mc-fun">{e.fun}</div>
            <div className="mc-name dim">{e.name}</div>
          </button>
        ))}
      </section>
    </main>
  );
}

function Mission({ cat, name, cleared, onBack, onCleared, onNext }: {
  cat: Catalog; name: string; cleared: Set<string>;
  onBack: () => void; onCleared: (n: string) => void; onNext: (n: string) => void;
}) {
  const ex = useMemo(() => cat.exercises.find((e) => e.name === name)!, [cat, name]);
  const [code, setCode] = useState<string>(() => localStorage.getItem(codeKey(name)) || starterFor(ex));
  const [running, setRunning] = useState(false);
  const [result, setResult] = useState<RunResult | null>(null);
  const [flash, setFlash] = useState<"none" | "pass" | "fail">("none");

  useEffect(() => {
    setCode(localStorage.getItem(codeKey(name)) || starterFor(ex));
    setResult(null); setFlash("none");
  }, [name, ex]);

  useEffect(() => { localStorage.setItem(codeKey(name), code); }, [name, code]);

  const nextExo = useMemo(() => {
    const pool = cat.exercises.filter((e) => e.level === ex.level && !cleared.has(e.name) && e.name !== name);
    return pool[0]?.name;
  }, [cat, ex, cleared, name]);

  const run = useCallback(async () => {
    setRunning(true); setResult(null); setFlash("none");
    try {
      const r = await grade(ex, code);
      setResult(r);
      setFlash(r.ok ? "pass" : "fail");
      if (r.ok) onCleared(ex.name);
      setTimeout(() => setFlash("none"), 700);
    } catch {
      setResult({ ok: false, compileError: "Network error reaching the compiler. Try again.", cases: [] });
      setFlash("fail"); setTimeout(() => setFlash("none"), 700);
    } finally {
      setRunning(false);
    }
  }, [ex, code, onCleared]);

  const resetCode = () => setCode(starterFor(ex));

  return (
    <main className={"mission page-full flash-" + flash}>
      <div className="crumb">
        <button className="ghost" onClick={onBack}>&larr; level {ex.level}</button>
        <span className="pix mtitle" style={{ color: LEVELS[ex.level].v }}>{ex.fun}</span>
        <span className="dim mname">{ex.name}.c</span>
        <span className={"chip " + (ex.type === "F" ? "f" : "p")}>{ex.type === "F" ? "function" : "program"}</span>
        {ex.hot && <span className="chip hot">falls often</span>}
        {cleared.has(ex.name) && <span className="chip done">cleared</span>}
      </div>

      <div className="split">
        <section className="pane subject box">
          <div className="pane-h pix">Subject</div>
          <pre className="subject-text">{ex.subject}</pre>
        </section>

        <section className="pane editor-pane box">
          <div className="pane-h pix">
            <span>{ex.name}.c</span>
            <span className="pane-actions">
              <button className="ghost tiny" onClick={resetCode}>reset</button>
              <button className="primary" onClick={run} disabled={running}>{running ? "compiling…" : "▶ run"}</button>
            </span>
          </div>
          <div className="cm-wrap">
            <CodeMirror
              value={code}
              height="100%"
              theme={oneDark}
              extensions={[cpp()]}
              onChange={(v) => setCode(v)}
              basicSetup={{ tabSize: 4, indentOnInput: true }}
            />
          </div>
          <Console running={running} result={result} nextExo={nextExo} onNext={onNext} />
        </section>
      </div>
    </main>
  );
}

function Console({ running, result, nextExo, onNext }: {
  running: boolean; result: RunResult | null; nextExo?: string; onNext: (n: string) => void;
}) {
  if (running) return <div className="console"><span className="pix" style={{ color: "var(--cyan)" }}>&#9612; compiling with -Wall -Wextra -Werror…</span></div>;
  if (!result) return <div className="console dim">Write your code, then hit RUN. Flags: -Wall -Wextra -Werror.</div>;

  if (result.compileError) {
    return (
      <div className="console">
        <div className="verdict fail pix">&#10007; COMPILATION FAILED</div>
        <pre className="err">{result.compileError}</pre>
      </div>
    );
  }
  const passed = result.cases.filter((c) => c.pass).length;
  return (
    <div className="console">
      <div className={"verdict pix " + (result.ok ? "pass" : "fail")}>
        {result.ok ? "✓ PASSED" : "✗ FAILED"} · {passed}/{result.cases.length} tests
      </div>
      {result.ok ? (
        nextExo ? <button className="primary next" onClick={() => onNext(nextExo)}>next mission &rarr;</button>
                : <div className="dim" style={{ marginTop: 8 }}>Level clear. Pick another level up top.</div>
      ) : (
        result.cases.filter((c) => !c.pass).slice(0, 1).map((c, i) => (
          <div key={i} className="case-fail">
            <div className="dim">args: <span style={{ color: "var(--ink)" }}>{c.args.length ? c.args.map((a) => JSON.stringify(a)).join(" ") : "(none)"}</span></div>
            <div><span className="dim">expected </span><span className="mono ok">{JSON.stringify(c.expected)}</span></div>
            <div><span className="dim">you got  </span><span className="mono bad">{JSON.stringify(c.got)}</span></div>
          </div>
        ))
      )}
    </div>
  );
}
