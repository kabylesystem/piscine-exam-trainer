#!/bin/bash
source ../../../main/colors.sh
EXO=maff_revalpha; ref=$EXO.c; stu=../../../../rendu/$EXO/$EXO.c
cleanup(){ rm -f out1 out2 o1 o2 cc.log 2>/dev/null; }
fail(){ echo "$(tput setaf 1)$(tput bold)FAIL$(tput sgr 0)"; [ -n "$1" ] && echo -e "$1"; cleanup; exit 1; }
[ -s "$stu" ] || fail "${RED}Rien rendu dans rendu/$EXO/$EXO.c${RESET}"
gcc -Wall -Wextra -Werror -o out2 "$stu" 2>cc.log || fail "${RED}Compilation KO (-Wall -Wextra -Werror):${RESET}\n$(cat cc.log)"
gcc -w -o out1 "$ref" 2>/dev/null || fail "${RED}Reference cassee (bug simulateur)${RESET}"
check(){ ./out1 "$@" >o1 2>/dev/null; ./out2 "$@" >o2 2>/dev/null; diff -q o1 o2 >/dev/null || fail "${GREEN}args:${RESET} $*\n${GREEN}Expected:${RESET} \"$(cat o1)\"\n${RED}Your output:${RESET} \"$(cat o2)\""; }
check
cleanup; echo "$(tput setaf 2)$(tput bold)PASSED 🎉$(tput sgr 0)"; exit 0
