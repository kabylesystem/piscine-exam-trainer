#!/usr/bin/env python3
# Ajoute un "fun name" (nom de mission arcade) a chaque exo. Sujet/description inchanges.
import json, sys, os

FUN = {
 "hello":"First Contact","only_a":"The Letter A","only_z":"The Letter Z",
 "aff_a":"Hunt The A","aff_z":"Hunt The Z","ft_putchar":"One Char","ft_star":"Lucky Seven",
 "ft_countdown":"Countdown","maff_alpha":"Alphabet March","maff_revalpha":"Alphabet Rewind",
 "ft_print_numbers":"Digit Parade","ft_print_alphabet":"A to Z","ft_print_reverse_alphabet":"Z to A",
 "ft_strlen":"Measure It","ft_strcpy":"Carbon Copy","ft_strcmp":"Face Off","ft_swap":"Swap Meet",
 "ft_putstr":"Say It","ft_add":"Plus","ft_mul":"Times","ft_sub":"Minus","ft_dec":"Minus One",
 "rev_int_tab":"Reverse Gear","occ_a":"Count The A","occ_z":"Count The Z",
 "rotone":"Caesar +1","rot_13":"ROT-13","fizzbuzz":"Fizz Buzz","ft_putnbr":"Print The Number",
 "repeat_alpha":"Echo Letters","rev_print":"Backwards","aff_first_param":"First In Line",
 "aff_last_param":"Last In Line","ft_strdup":"Clone String","sort_int_tab":"Line Them Up",
 "search_and_replace":"Find & Replace","ulstr":"Case Flip","first_word":"First Word","count_word":"Word Count",
 "ft_atoi":"String To Int","ft_split":"Split It","union":"Union","inter":"Intersection",
 "last_word":"Last Word","alpha_mirror":"Mirror Letters",
 "add_prime_sum":"Prime Sum","do_op":"Calculator","epur_str":"Trim Spaces","expand_str":"Space Out",
 "flood_fill":"Flood Fill","fprime":"Prime Factors","ft_atoi_base":"Base Reader","ft_itoa":"Int To String",
 "ft_list_foreach":"For Each","ft_list_remove_if":"Remove If","ft_list_size":"List Size",
 "ft_range":"Range","ft_rrange":"Reverse Range","ft_strrev":"Flip String","hidenp":"Hidden?",
 "is_power_of_2":"Power Of Two","lcm":"LCM","max":"The Max","paramsum":"Arg Sum","pgcd":"GCD",
 "print_hex":"To Hex","rev_wstr":"Reverse Words","rostring":"Rotate Words","rstr_capitalizer":"Reverse Caps",
 "sort_list":"Sort List","str_capitalizer":"Capitalize","tab_mult":"Times Table","wdmatch":"Word Match",
 "brackets":"Balanced?","biggest_pal":"Palindrome Hunter","rpn_calc":"RPN Calculator",
 "cycle_detector":"Cycle Detector","ft_itoa_base":"Base Writer",
}
RED = {"ft_add","ft_mul","ft_sub","ft_strlen","ft_strcpy","ft_putstr","occ_a","occ_z",
       "fizzbuzz","ft_putnbr","ft_atoi","ft_split","union","inter"}

path = sys.argv[1] if len(sys.argv) > 1 else "catalog.json"
d = json.load(open(path))
miss=[]
for e in d["exercises"]:
    e["fun"] = FUN.get(e["name"], e["name"].replace("_"," ").title())
    e["hot"] = e["name"] in RED
    if e["name"] not in FUN: miss.append(e["name"])
json.dump(d, open(path,"w"), ensure_ascii=False)
print("fun names merged. sans nom fun:", miss or "aucun")
