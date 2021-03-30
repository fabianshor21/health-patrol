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

curdate=$(date +"%D %r")
date_format=$()
curdate="${GREEN}$curdate${BLUE}"
page="${GREEN}$2${BLUE}"
user="${GREEN}$3${BLUE}"
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
head+="██╔═██╗██╔══██╗╚══██╔══╝██╔══██║██╔═══██║██║    HALAMAN  : $page\n"    
head+="█████╔╝███████║   ██║   ██████╔╝██║   ██║██║    PENGGUNA : $user\n"    
head+="██╔══╝ ██╔══██║   ██║   ██╔═███ ████████╝████║  $curdate\n"    
head+="╚═══════════════════════════════════════════════════════════════════"
foot+="${BLUE}════════════════════════════════════════════════════════════════════${ENDCOLOR}"
foot2+="${DARK_G}----------------------------------------------------------${ENDCOLOR}"
head+="${ENDCOLOR}"

case $1 in
	"1")
	 	echo -e "$head"
		;;
	"2")
		echo -e "$foot"
		;;
	"3")
		echo -e "$foot2"
		;;
esac
