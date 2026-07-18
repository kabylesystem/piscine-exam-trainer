#!/bin/bash
source ../../../main/colors.sh
EXO=aff_first_param
ref=$EXO.c
stu=../../../../rendu/$EXO/$EXO.c

cleanup() { rm -f out1 out2 o1 o2 cc.log 2>/dev/null; }

fail() {
    echo "$(tput setaf 1)$(tput bold)FAIL$(tput sgr 0)"
    [ -n "$1" ] && echo -e "$1"
    cleanup
    exit 1
}

[ -s "$stu" ] || fail "${RED}Rien rendu dans rendu/$EXO/$EXO.c${RESET}"

# Compilation du rendu avec les flags de l'exam
if ! gcc -Wall -Wextra -Werror -o out2 "$stu" 2>cc.log; then
    fail "${RED}Compilation KO (-Wall -Wextra -Werror) :${RESET}\n$(cat cc.log)"
fi
# Compilation de la reference (oracle)
gcc -w -o out1 "$ref" 2>/dev/null || fail "${RED}Reference introuvable/cassee (bug du simulateur)${RESET}"

check() {
    ./out1 "$@" > o1 2>/dev/null
    ./out2 "$@" > o2 2>/dev/null
    if ! diff -q o1 o2 >/dev/null; then
        fail "${GREEN}args:${RESET} $*\n${GREEN}Expected:${RESET} \"$(cat o1)\"\n${RED}Your output:${RESET} \"$(cat o2)\""
    fi
}

check
check vincent mit lane dans un pre
check "j'aime le fromage de chevre"
check one two three
check solo

cleanup
echo "$(tput setaf 2)$(tput bold)PASSED 🎉$(tput sgr 0)"
exit 0
