#!/bin/bash
source ../../../main/colors.sh
stu=../../../../rendu/ft_itoa_base/ft_itoa_base.c
cleanup(){ rm -f out1 out2 o1 o2 cc.log 2>/dev/null; }
fail(){ echo "$(tput setaf 1)$(tput bold)FAIL$(tput sgr 0)"; [ -n "$1" ] && echo -e "$1"; cleanup; exit 1; }
[ -s "$stu" ] || fail "${RED}Rien rendu dans rendu/ft_itoa_base/ft_itoa_base.c${RESET}"
gcc -Wall -Wextra -Werror -o out2 "$stu" main.c 2>cc.log || fail "${RED}Compilation KO (-Wall -Wextra -Werror):${RESET}\n$(cat cc.log)"
gcc -w -o out1 ft_itoa_base.c main.c 2>/dev/null || fail "${RED}Reference cassee${RESET}"
./out1 >o1 2>/dev/null; ./out2 >o2 2>/dev/null
diff -q o1 o2 >/dev/null || fail "${GREEN}Expected:${RESET} \"$(cat o1)\"\n${RED}Your output:${RESET} \"$(cat o2)\""
cleanup; echo "$(tput setaf 2)$(tput bold)PASSED 🎉$(tput sgr 0)"; exit 0
