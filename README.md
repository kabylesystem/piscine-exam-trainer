# 🏊 Piscine 42 - Exam Simulator

Un simulateur d'**exam de la Piscine 42** à lancer sur ton Mac (ou Linux). Il te met dans
les mêmes conditions que le vrai exam : un sujet tombe, tu codes dans un dossier `rendu/`,
tu tapes `test`, un correcteur compile ton code (`-Wall -Wextra -Werror`) et compare ta
sortie à la solution de référence. `PASSED` ou `FAIL`, comme le jour J.

Le pool d'exercices a été **curé** : les exos de **bit shift** ont été retirés, et tout ce
qui ne tombe pas en piscine (rank 03+ du cursus, microshell, etc.) a été enlevé. Il reste
les exos qui tombent vraiment, du warm-up jusqu'au niveau exam final.

## 🚀 Démarrage (le plus simple)

```bash
git clone https://github.com/kabylesystem/piscine-exam-trainer.git
cd piscine-exam-trainer
./examshell
```

C'est tout. Tu tombes sur le menu.

### Il te faut juste un compilateur C

- **macOS** : si `./examshell` râle qu'il manque un compilateur, lance une fois :
  ```bash
  xcode-select --install
  ```
  puis relance `./examshell`. (Le simulateur utilise `cc`/`clang` automatiquement si `gcc`
  n'existe pas, c'est bon pour la piscine.)
- **Linux** : `gcc` est en général déjà là (sinon installe `build-essential`).

## 🐧 Mode "identique au vrai exam" (Docker, optionnel)

Le vrai exam 42 tourne sous **Linux avec gcc**. Si tu veux exactement le même environnement
(ou si le mode natif Mac fait un truc bizarre) :

```bash
./examshell --docker
```

Ça construit un petit conteneur Linux (gcc + outils) la première fois (~1 min) puis te lance
dedans. Ton dossier `rendu/` reste sur ton Mac, tu vois ton code normalement. Il faut avoir
**Docker Desktop** installé et lancé.

## 🎮 Comment ça marche

1. Menu principal → **Piscine Exam** → choisis un **mode** :
   - **Level Mode** : tu pratiques niveau par niveau, tu piques les exos que tu veux.
   - **Real Exam Mode** : le vrai enchaînement chronométré, level 0 → 3, faut tout passer.
2. Choisis un **niveau** :
   - 🌱 **Level00** : warm-up (Exam 00 bébé : hello, only_a, aff_first_param...)
   - ⭐ **Level0** : fondations (rotone, ft_strcpy, fizzbuzz...)
   - 🔥 **Level1** : intermédiaire (ft_atoi, ft_strdup, inter, union...)
   - 💎 **Level2** : avancé (epur_str, ft_atoi_base, str_capitalizer...)
   - 🏆 **Level3** : niveau exam final (ft_split, sort_list, ft_itoa, rostring...)
3. Un sujet s'affiche. Écris ton code dans **`rendu/<exo>/<exo>.c`** (ouvre le repo dans ton
   éditeur, le fichier est déjà créé et vide).
4. Dans le shell, tape :
   - **`test`** → te faire corriger (compile + diff avec la référence)
   - **`next`** → exo suivant
   - **`menu`** → retour menu (sauvegarde ton rendu dans `trace/`)
   - **`exit`** → quitter

## ⚠️ Règles de survie (comme au vrai exam)

- Ton code doit compiler en **`-Wall -Wextra -Werror`** : un warning = un fail.
- La sortie doit être **exactement** celle attendue (le `\n` final compte, teste avec `| cat -e`).
- Une boucle infinie = **TIMEOUT** après 10s.

Bon courage. 🐦‍⬛
