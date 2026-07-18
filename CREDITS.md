# Crédits

Ce simulateur n'est pas parti de zéro : il assemble et cure du travail existant de la
communauté 42. Merci à eux.

- **Moteur du shell d'exam + testers + pool d'exercices** :
  [`terminal-42s/42_examshell`](https://github.com/terminal-42s/42_examshell).
  On a repris son moteur (menus, modes, timer, testers par exo) et curé son `rank02`
  en mode **Piscine** : retrait des exos de bit shift, retrait de tout ce qui ne tombe
  pas en piscine (ranks 03 à 06).

- **Exercices du warm-up "Level00" (Exam 00 bébé)** :
  [`ayoub0x1/C-Piscine-exam`](https://github.com/ayoub0x1/C-Piscine-exam) (Level 00).
  Sujets + solutions de référence, avec des testers ajoutés (compilation `-Wall -Wextra
  -Werror` + comparaison à la référence).

## Ce qui a été modifié ici

- Rebranding "Rank 02" → "Piscine 42".
- Suppression des exos de bit shift (`print_bits`, `reverse_bits`, `swap_bits`).
- Suppression des ranks 03/04/05/06 (hors piscine).
- Ajout d'un niveau **Level00** (warm-up) avec ses testers.
- Launcher `examshell` (mode natif macOS/Linux + mode Docker identique à l'exam).

Les exercices et sujets restent la propriété de leurs auteurs respectifs. Usage :
entraînement personnel à la Piscine 42.
