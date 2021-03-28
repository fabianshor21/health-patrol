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

if [[ $UID == "0" ]]; then
	while :; do
		clear
		curdate=$(date +"%D %r")
		date_format=$()
		curdate="${GREEN}$curdate${BLUE}"
		page="${GREEN}LOGIN${BLUE}"
		lang="${GREEN}ID${BLUE}"
		left_b="${YELLOW}[${ENDCOLOR}"; right_b="${YELLOW}]${ENDCOLOR}"
		head=""
		foot=""
		foot2=""
		head+="${GREEN}"	
		head+="██╗  ██╗███████╗ █████╗ ██╗  ████████╗██╗  ██╗\n"
		head+="██║  ██║██╔════╝██╔══██╗██║  ╚══██╔══╝██║  ██║\n"
		head+="███████║█████╗  ███████║██║     ██║   ███████║\n"   
		head+="██╔══██║██╔══╝  ██╔══██║██║     ██║   ██╔══██║\n"    
		head+="██║  ██║███████╗██║  ██║███████╗██║   ██║  ██║\n"   
		head+="╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚══════╝╚═╝   ╚═╝  ╚═╝\n"
		head+="${BLUE}"                                              
		head+="█████╗  █████╗ ████████╗███████╗████████╗██╗ \n"   
		head+="██╔═██╗██╔══██╗╚══██╔══╝██╔══██║██╔═══██║██║    POSITION : $page\n"    
		head+="█████╔╝███████║   ██║   ██████╔╝██║   ██║██║    LANGUAGE : $lang\n"    
		head+="██╔══╝ ██╔══██║   ██║   ██╔═███ ████████╝████║  $curdate\n"    
		head+="╚═══════════════════════════════════════════════════════════════════"
		foot+="${BLUE}════════════════════════════════════════════════════════════════════${ENDCOLOR}"
		foot2+="${DARK_G}----------------------------------------------------------${ENDCOLOR}"
		head+="${ENDCOLOR}"

		for dir in ${dir_path[@]}; do
			if [[ ! -d $dir ]]; then
				mkdir $dir
			fi
		done
		for file in ${file_path[@]}; do
			touch $file
		done

		echo -e "$head"
		echo -e "║::  $left_b${BLUE}SI$right_b SIGN-IN       | $left_b${BLUE}SU$right_b SIGN-UP        | $left_b${BLUE}CL$right_b CLEAR       ::║${ENDCOLOR}"
		echo -e "║::  $foot2  ::║"
		echo -e "$foot"		
		while :; do
			echo -en "${YELLOW}>>>  ${ENDCOLOR}"; read opt
			case $opt in
				"CL"|"cl")
					break
					;;
				"SI"|"si")
					echo -e "$foot"
					bash source/login.sh signin
					;;
				"SU"|"su")
					echo -e "$foot"
					bash source/login.sh signup
			esac
		done
	done
	#sudo bash source/login.sh
fi