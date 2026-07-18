source colors.sh
mkdir -p ../../rendu
clear
bash label.sh
printf "${CYAN}%s${RESET}\n" "╔═══════════════════════════════════════════════════════════╗"
printf "${BLUE}%s${GREEN}%s${BLUE}%s${RESET}\n" "║" "     🏊  PISCINE 42 - EXAM SIMULATOR - MAIN MENU  🏊     " "║"
printf "${CYAN}%s${RESET}\n" "╠═══════════════════════════════════════════════════════════╣"
printf "${BLUE}%s${RESET}\n" "▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
printf "${GREEN}%s${RESET}\n"  "◆◇◆◇◆◇◆◇◆◇◆◇◆◇◆◇◆◇◆◇◆◇◆◇◆◇◆◇◆◇◆◇◆◇◆◇◆◇◆◇◆◇◆◇◆◇◆◇◆◇◆◇◆◇◆"
printf "${YELLOW}${BOLD}%s${RESET}\n" "🔄 1. Commands (help)"
printf "${YELLOW}${BOLD}%s${RESET}\n" "🏊 2. Piscine Exam"
printf "${YELLOW}${BOLD}%s${RESET}\n" "📁 3. Open Rendu Folder"
printf "${GREEN}%s${RESET}\n"  "◆◇◆◇◆◇◆◇◆◇◆◇◆◇◆◇◆◇◆◇◆◇◆◇◆◇◆◇◆◇◆◇◆◇◆◇◆◇◆◇◆◇◆◇◆◇◆◇◆◇◆◇◆◇◆◇◆"
printf "${BLUE}%s${RESET}\n" "▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
printf "${CYAN}%s${RESET}\n" "╚═══════════════════════════════════════════════════════════╝"
printf "${GREEN}${BOLD}Enter your choice (1-3), or 'exit': ${RESET}"
read opt
case $opt in
    1)
        bash help.sh
        ;;
    2)
        bash rank02_menu.sh
        ;;
    3)
        cd ../../rendu
        ( open . 2>/dev/null || xdg-open . 2>/dev/null || echo "Rendu folder: $(pwd)" )
        cd ../.resources/main
        sleep 1
        bash menu.sh
        exit 1
        ;;
    exit)
        cd ../../../../
        rm -rf rendu
        clear
        exit 1
        ;;
    *)
        echo "Invalid choice. Please enter a number from 1 to 3."
        sleep 1
        clear
        bash menu.sh
esac
