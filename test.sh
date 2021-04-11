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
