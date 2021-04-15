#!/bin/bash
#----------
dir_path=("database" "source" "database/user_auth" "database/medical_record" "database/health_info")
file_path=("${dir_path[2]}/session" "${dir_path[2]}/profile.json" "${dir_path[2]}/profile-growth.json" "${dir_path[2]}/history.log" "${dir_path[4]}/disease_generic.json" "${dir_path[4]}/disease_regex.json" "${dir_path[4]}/disease_class.json" "${dir_path[4]}/fetch_symtomps" "${dir_path[4]}/fetch_results" "${dir_path[4]}/speech-record.wav")

RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[36m"
YELLOW="\e[33m"
DARK_G="\e[37m"
ENDCOLOR="\e[0m"
foot2=$(bash source/bash/banner.sh 3)

if [[ $UID != "0" ]]; then
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
		bash source/bash/banner.sh 1 LOGIN PUBLIC ---
		printf  "║::  $left_b${BLUE}MA$right_b %-18s | $left_b${BLUE}DA$right_b %-18s | $left_b${BLUE}TA$right_b %-18s | $left_b${BLUE}KL$right_b %-17s  ::║${ENDCOLOR}\n" "MASUK_AKUN" "DAFTAR_AKUN" "TAMBAH_ANAK" "KELUAR"
		echo -e "║::  $foot2  ::║"
		bash source/bash/banner.sh 2

		while :; do
			check_session=$(cat "${file_path[0]}")
			if  [[ ! "$check_session" ]]; then
				echo "public ---" > "${file_path[0]}"
				break
			fi
			echo -en "${YELLOW}>>>  ${ENDCOLOR}"; read opt
			case $opt in
				"CLEAR"|"clear")
					break
					;;
				"KL"|"kl")
					exit 0
					;;
				"MA"|"ma")
					bash source/bash/banner.sh 2
					bash source/bash/run-login.sh signin
					;;
				"DA"|"da")
					bash source/bash/banner.sh 2
					bash source/bash/run-login.sh signup
					;;
				"TA"|"ta")
					bash source/bash/banner.sh 2
					bash source/bash/run-login.sh addkid
					;;					
			esac
		done
	done
fi