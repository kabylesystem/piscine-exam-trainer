clear
# permissions sur les testers
find ../rank02 -name "tester.sh" -exec chmod +rwx {} \;

bash label.sh
bash intro.sh
