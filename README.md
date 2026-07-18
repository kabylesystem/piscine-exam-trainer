# 🏊 Piscine 42 - Final Exam Simulator

Practice the **42 Piscine Final Exam** on your Mac (or Linux), in real conditions: a subject
drops, you code in a `rendu/` folder, you type `test`, a grader compiles your code
(`-Wall -Wextra -Werror`) and diffs your output against the reference. `PASSED` or `FAIL`,
just like the real thing.

The pool is built from a **real campus Final Exam list** (the exercises that actually fall),
levels 0 to 5, each exercise tagged as a **function (F)** or a **program (P)**. No bit-shift
exercises (they do not fall on the piscine exam). **78 exercises, every one auto-graded.**

## 🚀 Quick start

```bash
git clone https://github.com/kabylesystem/piscine-exam-trainer.git
cd piscine-exam-trainer
./examshell
```

Need a C compiler: on macOS run `xcode-select --install` once if prompted.
For an environment identical to the real Linux exam: `./examshell --docker`.

## 🎮 How it works

Main menu → **Piscine Exam** → pick a **mode**:
- **Level Mode**: train level by level, pick the exercises you want.
- **Real Exam Mode**: the timed run, level 0 → 5, you must pass to move on.

Then pick a **level**:

| Level | Theme | Examples |
|-------|-------|----------|
| **0** | Warm-up | hello, only_a, ft_putchar, ft_star, aff_a |
| **1** | Functions | ft_strlen, ft_strcpy, ft_add, ft_swap, rev_int_tab |
| **2** | Strings | rotone, ft_putnbr, ft_strdup, first_word, sort_int_tab |
| **3** | Parsing | ft_atoi, ft_split, union, inter, alpha_mirror |
| **4** | Full pool (bonus) | epur_str, ft_atoi_base, pgcd, ft_itoa, sort_list |
| **5** | Boss | rpn_calc, brackets, biggest_pal, cycle_detector, ft_itoa_base |

A subject appears. Write your code in **`rendu/<exo>/<exo>.c`**, then type:
- **`test`** → grade it   ·   **`next`** → next exercise   ·   **`menu`** / **`exit`**

## ⚠️ Exam survival rules

- Your code must compile with **`-Wall -Wextra -Werror`**: one warning = a fail.
- Output must match **exactly** (the trailing `\n` counts, check with `| cat -e`).
- Infinite loop = **TIMEOUT** after 10s.

## 🌐 Web version (no install, plays in the browser)

**Live: https://piscine-exe.vercel.app**

An 8-bit browser version: pick a mission, write C, compile & run right in the page,
PASS or FAIL. Levels 0 to 5, fun mission names, progress saved locally. The in-page
compiler uses the free Wandbox API with the real exam flags (`-std=gnu17 -Wall -Wextra -Werror`).
Source in `web/`.

### Run the web version locally
```bash
cd web
npm install
npm run dev
```

### Deploy to Vercel
Import this repo in Vercel, set **Root Directory** to `web/` (framework auto-detects as Vite),
deploy. To rebuild the exercise catalog after changing the trainer:
`python3 web/tools/gen_catalog.py > web/public/catalog.json && python3 web/tools/merge_funnames.py web/public/catalog.json`.

Good luck. 🐦‍⬛
