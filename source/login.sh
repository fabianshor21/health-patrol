#!/bin/bash
#----------
dir_path=("database" "source" "database/user_auth" "database/medical_record" "database/health_info")
file_path=("${dir_path[2]}/session" "${dir_path[2]}/profile.json")

RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[36m"
YELLOW="\e[33m"
DARK_G="\e[37m"
ENDCOLOR="\e[0m"

case $1 in
	"signin")
		read -p  "║:: username : " get_user
		read -sp "║:: password : " get_pass
		get_valid=$(cat "${file_path[1]}" | grep -E "$get_user")
		if [[ $get_valid ]]; then
			bash source/home.sh
		fi
		echo -e "\n"		
		;;
	"signup")
		read -p "║:: full-name ...... : " get_fname
		read -p "║:: username ....... : " get_uname
		read -p "║:: password ....... : " get_pass
		read -p "║:: phone .......... : " get_phone
		read -p "║:: married (t/f) .. : " get_married
		read -p "║:: birth (dd/mm/yy) : " get_birth
		read -p "║:: sex (m/f) ...... : " get_sex
		read -p "║:: height (cm) .... : " get_height
		read -p "║:: weight (kg) .... : " get_weight
		;;
esac
