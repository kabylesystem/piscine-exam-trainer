# Credits

This simulator assembles and curates existing community work. Thanks to them.

- **Shell engine + testers + core exercises**:
  [`terminal-42s/42_examshell`](https://github.com/terminal-42s/42_examshell).
  Engine (menus, modes, timer, per-exercise testers) and the rank02 exercise pool.

- **Exercise pool cross-reference**:
  [`DKMR/42exams`](https://github.com/DKMR/42exams) and
  [`joaquim-oliveira-neto/42-Piscine-C-Exam`](https://github.com/joaquim-oliveira-neto/42-Piscine-C-Exam)
  (subjects, level structure), and [`ayoub0x1/C-Piscine-exam`](https://github.com/ayoub0x1/C-Piscine-exam)
  (Level 00 subjects and reference solutions).

## What was done here

- Re-leveled the pool (Level 0 → 5) to match a **real campus Final Exam list**.
- Removed the **bit-shift** exercises (they do not fall on the piscine exam) and non-piscine
  cursus exercises.
- Added the missing campus exercises with new reference solutions and testers, handling
  **function exercises** (F) with a dedicated test `main.c`:
  ft_putchar, ft_star, ft_print_alphabet, ft_print_reverse_alphabet, ft_add/ft_mul/ft_sub,
  ft_dec, occ_a/occ_z, ft_putnbr, count_word, rev_int_tab.
- Added a **Boss level (Level 5)** with verified solutions and testers:
  brackets, biggest_pal, rpn_calc, cycle_detector, ft_itoa_base.
- One-command `examshell` launcher (native macOS/Linux + `--docker` for an exam-identical Linux).
- A browser version under `web/` (in-page compile & run).

Every one of the 78 exercises was checked: its reference solution passes its own tester.

Exercises and subjects remain the property of their respective authors. Use: personal
Piscine 42 practice.
