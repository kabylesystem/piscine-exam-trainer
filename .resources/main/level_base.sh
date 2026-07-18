#!/bin/bash
source colors.sh

rank=$1
level=$2

base_dir="$(cd "$(dirname "$0")" && pwd)"

# Pool d'exos par niveau (mode PISCINE, calque sur la liste campus du Final Exam).
# Matching EXACT (pas de sous-chaine) pour eviter que level0 matche level00, etc.
case "$level" in
    level0) qsub=(aff_a aff_z ft_countdown ft_print_alphabet ft_print_numbers ft_print_reverse_alphabet ft_putchar ft_star hello maff_alpha maff_revalpha only_a only_z) ;;
    level1) qsub=(ft_add ft_dec ft_mul ft_putstr ft_strcmp ft_strcpy ft_strlen ft_sub ft_swap occ_a occ_z rev_int_tab) ;;
    level2) qsub=(aff_first_param aff_last_param count_word first_word fizzbuzz ft_putnbr ft_strdup repeat_alpha rev_print rot_13 rotone search_and_replace sort_int_tab ulstr) ;;
    level3) qsub=(alpha_mirror ft_atoi ft_split inter last_word union) ;;
    level4) qsub=(add_prime_sum do_op epur_str expand_str flood_fill fprime ft_atoi_base ft_itoa ft_list_foreach ft_list_remove_if ft_list_size ft_range ft_rrange ft_strrev hidenp is_power_of_2 lcm max paramsum pgcd print_hex rev_wstr rostring rstr_capitalizer sort_list str_capitalizer tab_mult wdmatch) ;;
    level5) qsub=(biggest_pal brackets cycle_detector ft_itoa_base rpn_calc) ;;
    *) echo "Invalid level: $level"; exit 1 ;;
esac

# Melange les questions
shuffle_array() {
    local i tmp size max rand
    size=${#qsub[*]}
    max=$(( 32768 / size * size ))

    for ((i = size - 1; i > 0; i--)); do
        while (( (rand = RANDOM) >= max )); do :; done
        rand=$(( rand % (i + 1) ))
        tmp=${qsub[i]}
        qsub[i]=${qsub[rand]}
        qsub[rand]=$tmp
    done
    shuffled=("${qsub[@]}")
}

shuffle_array
num=${#shuffled[@]}
i=0
cd "../$rank/$level/${shuffled[$i]}"

while true; do
    cd "../${shuffled[$i]}"
    mkdir -p "$base_dir/../../rendu/${shuffled[$i]}"
    touch "$base_dir/../../rendu/${shuffled[$i]}/${shuffled[$i]}.c"
    # Copie les headers fournis (cycle_detector -> list.h, ft_list_* -> ft_list.h)
    cp ./*.h "$base_dir/../../rendu/${shuffled[$i]}/" 2>/dev/null

    subject=$(cat sub.txt)

    if [ $i -ge $num ]; then
        clear
        echo "These questions at $level are completed."
        echo "=============================================="
        read -rp "${GREEN}${BOLD}Please press enter for return to the menu.${RESET}" enterx
        sleep 2
        cd ../../main
        bash menu.sh
        exit
    fi

    while true; do
        clear
        echo -e "${WHITE}$subject${RESET}"
        echo
        echo -e "${GREEN}${BOLD}>> Write your code in:${RESET} rendu/${shuffled[$i]}/${shuffled[$i]}.c ${CYAN}(open this file in your editor, then come back)${RESET}"
        echo
        echo "Please type 'test' to test code, 'next' for next or 'exit' for exit."
        echo
        read -rp "/>" input
        case $input in
            next)
                i=$((i+1))
                break
                ;;
            test)
                clear
                ./tester.sh &
                pid=$!
                slept=0
                while [ $slept -lt 10 ] && kill -0 $pid 2>/dev/null; do
                    sleep 1
                    slept=$((slept+1))
                done
                if kill -0 $pid 2>/dev/null; then
                    echo "$(tput setaf 1)$(tput bold)TIMEOUT$(tput sgr 0)"
                    echo "It can be because of infinite loop ∞"
                    echo "Please check your code or just try again."
                    kill $pid 2>/dev/null
                fi
                echo "=============================================="
                read -rp "${GREEN}${BOLD}Please press enter to continue your practice.${RESET}" enter
                break
                ;;
            menu)
                cd ../../../../
                if [ -d rendu ]; then
                    mkdir -p trace
                    cp -r rendu "trace/rendu_backup_$(date +%s)"
                    rm -rf rendu
                fi
                cd .resources/main
                bash menu.sh
                exit
                ;;
            exit)
                cd ../../../../
                if [ -d rendu ]; then
                    mkdir -p trace
                    cp -r rendu "trace/rendu_backup_$(date +%s)"
                    rm -rf rendu
                fi
                exit 1
                ;;
            *)
                echo "Please type 'test' to test code, 'next' for next or 'exit' to quit."
                ;;
        esac
    done
done
