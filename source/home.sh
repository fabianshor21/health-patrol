#!/bin/bash
#----------
dir_path=("database" "source" "database/user_auth" "database/medical_record" "database/health_info")
file_path=("${dir_path[2]}/session" "${dir_path[2]}/profile.json" "${dir_path[2]}/profile-growth.json" "${dir_path[2]}/history.log" "${dir_path[4]}/disease_generic.json" "${dir_path[4]}/disease_regex.json" "${dir_path[4]}/disease_class.json")

RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[36m"
YELLOW="\e[33m"
DARK_G="\e[37m"
ENDCOLOR="\e[0m"
foot2=$(bash source/banner.sh 3)
left_b="${YELLOW}[${ENDCOLOR}"; right_b="${YELLOW}]${ENDCOLOR}"
user=$(cat ${file_path[0]} | cut -d ' ' -f 1 | tail -n 1); user=$(echo "${user^^}")
kid=$(cat ${file_path[0]} | cut -d ' ' -f 2 | tail -n 1); kid=$(echo "${kid^^}")

while :; do
	clear
	bash source/banner.sh 1 HOME "$user" "$kid"
	printf  "║::  $left_b${BLUE}DP$right_b %-18s | $left_b${BLUE}PA$right_b %-18s | $left_b${BLUE}UP$right_b %-18s | $left_b${BLUE}RP$right_b %-18s ::║${ENDCOLOR}\n" "DIAGNOSA_PENYAKIT" "PERKEMBANGAN_ANAK" "UBAH_PROFIL" "RIWAYAT_PROFIL"
	printf  "║::  $left_b${BLUE}PP$right_b %-18s | $left_b${BLUE}RF$right_b %-18s | $left_b${BLUE}IP$right_b %-18s | $left_b${BLUE}KB$right_b %-18s ::║${ENDCOLOR}\n" "PANDUAN_PROGRAM" "REFERENSI" "INFO_PUSKESMAS" "KEMBALI"	
	echo -e "║::  $foot2  ::║"
	bash source/banner.sh 2

	while :; do
		echo -en "${YELLOW}>>>  ${ENDCOLOR}"; read opt
		case $opt in
			"CL"|"cl")
				break
				;;
			"KB"|"kb")
				# sign out : exit 0
				cat /dev/null > "${file_path[0]}"
				exit 0;
				;;
			"DP"|"dp")
				bash source/banner.sh 2
				bash source/run-diagnose.sh
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