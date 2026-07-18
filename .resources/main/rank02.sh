#!/bin/bash
source functions.sh
source colors.sh
clear
bash label.sh
printf "${BLUE}%s${RESET}\n" "┌─────────────────────────────────────────────────────────┐"
printf "${BLUE}%s${GREEN}%s${BLUE}%s${RESET}\n" "│" "     🏊 Choose your level - PISCINE 42 FINAL EXAM 🏊    " "│"
printf "${BLUE}%s${RESET}\n" "└─────────────────────────────────────────────────────────┘"
printf "${CYAN}%s${RESET}\n" "∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼"
printf "${YELLOW}${BOLD}%s${RESET}\n" "🌱 1. Level 0  - Warm-up (hello, only_a, ft_putchar...)"
printf "${YELLOW}${BOLD}%s${RESET}\n" "⭐ 2. Level 1  - Functions (ft_strlen, ft_add, ft_swap...)"
printf "${YELLOW}${BOLD}%s${RESET}\n" "🔥 3. Level 2  - Strings (rotone, ft_putnbr, ft_strdup...)"
printf "${YELLOW}${BOLD}%s${RESET}\n" "💎 4. Level 3  - Parsing (ft_atoi, ft_split, union...)"
printf "${YELLOW}${BOLD}%s${RESET}\n" "🏆 5. Level 4  - The full pool (harder, bonus)"
printf "${RED}${BOLD}%s${RESET}\n"    "☠️  6. Level 5  - Boss (rpn_calc, brackets, cycle...)"
printf "${CYAN}%s${RESET}\n" "∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼"
printf "${GREEN}${BOLD}Enter your choice (1-6), 'menu' or 'exit': ${RESET}"
read opt

run_level() {
    mkdir -p ../../rendu
    clear
    echo "$(tput setaf 2)$(tput bold)$1 is being prepared...$(tput sgr0)"
    display_animation
    clear
    bash level_base.sh rank02 "$1"
}

case $opt in
    menu) bash menu.sh ;;
    1) run_level level0 ;;
    2) run_level level1 ;;
    3) run_level level2 ;;
    4) run_level level3 ;;
    5) run_level level4 ;;
    6) run_level level5 ;;
    exit)
        cd ../../../../
        rm -rf rendu
        clear
        exit 1
        ;;
    *)
        echo "$(tput setaf 1)Wrong input$(tput sgr0)"
        sleep 1
        bash rank02.sh
        ;;
esac
