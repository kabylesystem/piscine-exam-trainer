#!/bin/bash
source colors.sh

rank=$1
level=$2

# Save base directory (where script was launched from)
base_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Centralized temp file to track subject
subject_file="/tmp/.current_subject_${rank}_${level}"

# Define subject pool using case statement instead of associative array
get_subjects() {
    case "$level" in
        level0)
            echo "aff_a aff_z ft_countdown ft_print_alphabet ft_print_numbers ft_print_reverse_alphabet ft_putchar ft_star hello maff_alpha maff_revalpha only_a only_z"
            ;;
        level1)
            echo "ft_add ft_dec ft_mul ft_putstr ft_strcmp ft_strcpy ft_strlen ft_sub ft_swap occ_a occ_z rev_int_tab"
            ;;
        level2)
            echo "aff_first_param aff_last_param count_word first_word fizzbuzz ft_putnbr ft_strdup repeat_alpha rev_print rot_13 rotone search_and_replace sort_int_tab ulstr"
            ;;
        level3)
            echo "alpha_mirror ft_atoi ft_split inter last_word union"
            ;;
        level4)
            echo "add_prime_sum do_op epur_str expand_str flood_fill fprime ft_atoi_base ft_itoa ft_list_foreach ft_list_remove_if ft_list_size ft_range ft_rrange ft_strrev hidenp is_power_of_2 lcm max paramsum pgcd print_hex rev_wstr rostring rstr_capitalizer sort_list str_capitalizer tab_mult wdmatch"
            ;;
        level5)
            echo "biggest_pal brackets cycle_detector ft_itoa_base rpn_calc"
            ;;
        *)
            echo ""
            ;;
    esac
}

pick_new_subject() {
    subjects_list=$(get_subjects)
    IFS=' ' read -r -a qsub <<< "$subjects_list"
    count=${#qsub[@]}
    random_index=$(( RANDOM % count ))
    chosen="${qsub[$random_index]}"
    echo "$chosen" > "$subject_file"
}

prepare_subject() {
    mkdir -p "$base_dir/../../rendu/$chosen"
    touch "$base_dir/../../rendu/$chosen/$chosen.c"
    cp "$base_dir/../$rank/$level/$chosen/"*.h "$base_dir/../../rendu/$chosen/" 2>/dev/null

    cd "$base_dir/../$rank/$level/$chosen" || {
        echo -e "${RED}Subject folder not found.${RESET}"
        exit 1
    }

    clear
    echo -e "${CYAN}${BOLD}Your subject: $chosen${RESET}"
    echo "=================================================="
    cat sub.txt
    echo
    echo -e "=================================================="
    echo -e "${GREEN}${BOLD}>> Write your code in:${RESET} rendu/$chosen/$chosen.c ${CYAN}(open this file in your editor, then come back)${RESET}"
    echo -e "${YELLOW}Type 'test' to test your code, 'next' to get a new question, or 'exit' to quit.${RESET}"
}

# Initial subject selection
if [ -f "$subject_file" ]; then
    chosen=$(cat "$subject_file")
    echo -e "${BLUE}🔁 Resuming with previously chosen subject: $chosen${RESET}"
else
    pick_new_subject
fi

prepare_subject

# Command loop
while true; do
    read -rp "/> " input
    case "$input" in
        test)
            clear
            echo -e "${GREEN}Running tester.sh...${RESET}"
            output=$(./tester.sh 2>&1)
            echo "$output" | tee tester_output.log

            if echo "$output" | grep -q -E "PASSED|SUCCESS"; then
                echo -e "${GREEN}${BOLD}✔️  Passed!${RESET}"
                rm -f "$subject_file"
                sleep 1
                exit 0
            else
                echo -e "${RED}${BOLD}❌  Failed.${RESET}"
                sleep 1
                exit 1
            fi
            ;;
        next)
            echo -e "${BLUE}🔄 Picking a new subject...${RESET}"
            pick_new_subject
            chosen=$(cat "$subject_file")
            prepare_subject
            ;;
        exit)
            echo "Exiting..."
            exit 255 
            ;;
        *)
            echo "Please type 'test' to test code, 'next' for next or 'exit' for exit."
            ;;
    esac
done
