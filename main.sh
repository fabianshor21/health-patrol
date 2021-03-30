#!/bin/bash
#----------
dir_path=("database" "source" "database/user_auth" "database/medical_record" "database/health_info")
file_path=("${dir_path[2]}/session" "${dir_path[2]}/profile.json" "${dir_path[2]}/profile-growth.json")

RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[36m"
YELLOW="\e[33m"
DARK_G="\e[37m"
ENDCOLOR="\e[0m"

if [[ $UID == "0" ]]; then
	while :; do
		clear
		for dir in ${dir_path[@]}; do
			if [[ ! -d $dir ]]; then
				mkdir $dir
			fi
		done
		for file in ${file_path[@]}; do
			touch $file
			check_json=$(echo $file | grep -E "json")
			if [[ $check_json ]]; then
				if [[ ! -s $file ]]; then
					echo "{}" > $file
				fi
			fi
		done

		left_b="${YELLOW}[${ENDCOLOR}"; right_b="${YELLOW}]${ENDCOLOR}"
		bash source/banner.sh 1 LOGIN PUBLIC
		echo -e "║::  $left_b${BLUE}MA$right_b MASUK_AKUN    | $left_b${BLUE}DA$right_b DAFTAR_AKUN    | $left_b${BLUE}CL$right_b CLEAR       ::║${ENDCOLOR}"
		echo -e "║::  $left_b${BLUE}TA$right_b TAMBAH_ANAK   | $left_b${BLUE}KL$right_b KELUAR         | $left_b${BLUE}..$right_b ...         ::║${ENDCOLOR}"		
		foot2=$(bash source/banner.sh 3)
		echo -e "║::  $foot2  ::║"
		bash source/banner.sh 2

		while :; do
			echo -en "${YELLOW}>>>  ${ENDCOLOR}"; read opt
			case $opt in
				"CL"|"cl")
					break
					;;
				"KL"|"kl")
					exit 0
					;;
				"MA"|"ma")
					bash source/banner.sh 2
					bash source/login.sh signin
					;;
				"DA"|"da")
					bash source/banner.sh 2
					bash source/login.sh signup
					;;
				"TA"|"ta")
					bash source/banner.sh 2
					bash source/login.sh addkid
					;;					
			esac
		done
	done
fi