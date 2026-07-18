export interface TestCase {
  args: string[];
  expected: string;
}

export interface Exercise {
  level: number;
  name: string;      // real 42 name (e.g. rotone)
  fun: string;       // fun mission name (e.g. Caesar +1)
  title: string;     // assignment name from subject
  type: "F" | "P";   // Function or Program
  hot: boolean;      // falls most often on the exam
  allowed: string;   // allowed functions
  subject: string;   // full subject text (EN)
  subject_fr?: string; // French translation of the subject
  harness: string;   // main.c for F exercises, "" for P
  headers: Record<string, string>; // e.g. list.h
  sig: string;       // exact function signature for F exercises (from the reference)
  tests: TestCase[];
}

export interface Catalog {
  exercises: Exercise[];
}
