import type { Exercise, TestCase } from "./types";

// Compile + run C in the browser via the free Wandbox API (CORS-enabled).
// Same flags as the real exam: -std=gnu17 -Wall -Wextra -Werror.

const API = "https://wandbox.org/api/compile.json";
const COMPILER = "gcc-13.2.0-c";

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

interface WandboxResp {
  status?: string;
  compiler_error?: string;
  compiler_message?: string;
  program_output?: string;
  program_error?: string;
  signal?: string;
}

async function callWandbox(code: string, extraFiles: { file: string; code: string }[], extraOpts: string[], args: string[]): Promise<WandboxResp> {
  const opts = ["-std=gnu17", "-Wall", "-Wextra", "-Werror", ...extraOpts];
  const body = {
    code,
    codes: extraFiles,
    compiler: COMPILER,
    "compiler-option-raw": opts.join("\n"),
    "runtime-option-raw": args.join("\n"),
  };
  const res = await fetch(API, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(body),
  });
  if (!res.ok) throw new Error("Wandbox HTTP " + res.status);
  return res.json();
}

export async function grade(ex: Exercise, studentCode: string): Promise<RunResult> {
  const extraFiles: { file: string; code: string }[] = [];
  for (const [hn, hc] of Object.entries(ex.headers)) extraFiles.push({ file: hn, code: hc });

  let code: string;
  const extraOpts: string[] = [];
  if (ex.type === "F") {
    code = ex.harness;
    extraFiles.push({ file: ex.name + ".c", code: studentCode });
    extraOpts.push(ex.name + ".c");
  } else {
    code = studentCode;
  }

  const cases: RunResult["cases"] = [];
  for (let i = 0; i < ex.tests.length; i++) {
    const t: TestCase = ex.tests[i];
    const r = await callWandbox(code, extraFiles, extraOpts, t.args);
    const compileErr = (r.compiler_error || "").trim();
    if (compileErr && (r.program_output === undefined || r.program_output === "")) {
      if (r.status !== "0") {
        return { ok: false, compileError: compileErr, cases };
      }
    }
    const got = r.program_output ?? "";
    cases.push({ args: t.args, expected: t.expected, got, pass: got === t.expected });
  }
  return { ok: cases.length > 0 && cases.every((c) => c.pass), cases };
}
