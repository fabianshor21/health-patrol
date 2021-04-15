#!/bin/bash
#----------
arr_regex=("1" "2" "3" "4")
arr_regex_len=${#arr_regex[@]}
ctr=0
while [ $ctr -lt $arr_regex_len ]; do
	if [[ $((ctr+1)) < $arr_regex_len ]]; then
		echo "${arr_regex[$ctr]} + ${arr_regex[$((ctr+1))]}"
	fi
	ctr=$((++ctr))
done
a="35"
b="37.7"
if (( $(echo "$a < $b" | bc -l) &&  $(echo "$a > 0" | bc -l))); then
	echo "kurang"
fi

arr_regex=()
echo "${arr_regex[@]}"
arr_regex=("a" "b" "c")
echo "${arr_regex[@]}"

a="aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaakkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkksssssssssssssssssssssssss"
sed -e "s/.\{30\}/&\n/g" < test

printf "persen %%\n"

echo "RECORD TIME :"
arecord -d 15 -f cd -t wav -q source/python/record.wav
get_spch=$(python3 source/python/speech-to-text.py)
echo -e "\n"
fin_spch=" $get_spch"
echo "$get_spch"
echo "$fin_spch" | tr -s ',' '\n' | tr -d '.' > test2
cat test2 | cut -c 2-
