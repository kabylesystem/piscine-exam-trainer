import type { Exercise, TestCase } from "./types";

// Compile + run C via the free Compiler Explorer (godbolt.org) API — CORS-enabled and reliable.
// Same flags as the real exam: -std=gnu17 -Wall -Wextra -Werror.
//
// Godbolt's executor returns stdout split into lines and drops the trailing newline, which would
// break exact grading (the 42 exam cares about the final '\n'). We compile in an extra file whose
// destructor does fflush(NULL) then writes a unique marker AFTER all program output; we then join
// the lines and cut at the marker to recover the exact bytes, trailing newline included.

const API = "https://godbolt.org/api/compiler/cg132/compile"; // gcc 13.2.0, C
const MARK = "\x01__PISCINE_EXE_EOF__\x01";
const SENTINEL_FILE = "__pz_sentinel.c";
const SENTINEL_CODE =
  "#include <stdio.h>\n#include <unistd.h>\n" +
  "__attribute__((destructor)) static void _pz_eof(void){ fflush(NULL); " +
  `ssize_t n = write(1, "${MARK}", ${MARK.length}); (void)n; }\n`;

export interface RunResult {
  ok: boolean;
  compileError?: string;
  cases: {
    args: string[];
    expected: string;
    got: string;
    pass: boolean;
  }[];
}

interface GodboltLine { text: string }
interface GodboltResp {
  code?: number;
  didExecute?: boolean;
  stdout?: GodboltLine[];
  stderr?: GodboltLine[];
  buildResult?: { code?: number; stderr?: GodboltLine[] };
}

const stripAnsi = (s: string) => s.replace(/\x1b\[[0-9;]*m/g, "");
const joinLines = (l?: GodboltLine[]) => (l || []).map((x) => x.text).join("\n");

async function callGodbolt(
  source: string,
  files: { filename: string; contents: string }[],
  userArguments: string,
  args: string[],
): Promise<GodboltResp> {
  const body = {
    source,
    files,
    options: {
      userArguments,
      filters: { execute: true },
      executeParameters: { args, stdin: "" },
      compilerOptions: { executorRequest: true },
    },
    lang: "c",
  };
  const res = await fetch(API, {
    method: "POST",
    headers: { "Content-Type": "application/json", Accept: "application/json" },
    body: JSON.stringify(body),
  });
  if (!res.ok) throw new Error("Godbolt HTTP " + res.status);
  return res.json();
}

export async function grade(ex: Exercise, studentCode: string): Promise<RunResult> {
  const files: { filename: string; contents: string }[] = [
    { filename: SENTINEL_FILE, contents: SENTINEL_CODE },
  ];
  for (const [hn, hc] of Object.entries(ex.headers)) files.push({ filename: hn, contents: hc });

  let source: string;
  const compileUnits = [SENTINEL_FILE];
  if (ex.type === "F") {
    source = ex.harness;
    files.push({ filename: ex.name + ".c", contents: studentCode });
    compileUnits.push(ex.name + ".c");
  } else {
    source = studentCode;
  }
  const userArguments = [...compileUnits, "-std=gnu17", "-Wall", "-Wextra", "-Werror"].join(" ");

  const cases: RunResult["cases"] = [];
  for (let i = 0; i < ex.tests.length; i++) {
    const t: TestCase = ex.tests[i];
    const r = await callGodbolt(source, files, userArguments, t.args);

    if (r.didExecute === false) {
      const berr = stripAnsi(joinLines(r.buildResult?.stderr) || joinLines(r.stderr)).trim();
      return { ok: false, compileError: berr || "Compilation failed.", cases };
    }

    const raw = joinLines(r.stdout);
    const cut = raw.indexOf(MARK);
    const got = cut >= 0 ? raw.slice(0, cut) : raw;
    cases.push({ args: t.args, expected: t.expected, got, pass: got === t.expected });
  }
  return { ok: cases.length > 0 && cases.every((c) => c.pass), cases };
}
