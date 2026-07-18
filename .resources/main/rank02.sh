#!/bin/bash
source functions.sh
source colors.sh
clear
bash label.sh
printf "${BLUE}%s${RESET}\n" "┌─────────────────────────────────────────────────────────┐"
printf "${BLUE}%s${GREEN}%s${BLUE}%s${RESET}\n" "│" "     🏊 Choose your practice level - PISCINE 42 🏊      " "│"
printf "${BLUE}%s${RESET}\n" "└─────────────────────────────────────────────────────────┘"
printf "${CYAN}%s${RESET}\n" "∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼"
printf "${YELLOW}${BOLD}%s${RESET}\n" "🌱 1. Level00 - Warm-up (Exam 00 baby steps)"
printf "${YELLOW}${BOLD}%s${RESET}\n" "⭐ 2. Level0  - Foundation Exercises"
printf "${YELLOW}${BOLD}%s${RESET}\n" "🔥 3. Level1  - Intermediate Challenges"
printf "${YELLOW}${BOLD}%s${RESET}\n" "💎 4. Level2  - Advanced Problems"
printf "${YELLOW}${BOLD}%s${RESET}\n" "🏆 5. Level3  - Expert Level"
printf "${CYAN}%s${RESET}\n" "∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼"
printf "${GREEN}${BOLD}Enter your choice (1-5), 'menu' or 'exit': ${RESET}"
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
    menu)
        bash menu.sh
        ;;
    1)
        run_level level00
        ;;
    2)
        run_level level0
        ;;
    3)
        run_level level1
        ;;
    4)
        run_level level2
        ;;
    5)
        run_level level3
        ;;
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
esac
