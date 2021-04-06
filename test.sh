#!/bin/bash
#----------
ans=""
comp=""
num=01
while [[ $ans != "end" ]];do
	echo -en "$num | "; read ans
	comp+="$ans\n"
	num=$((++num))
	num="0$num"
done
echo -e "$comp" | head -n -2
