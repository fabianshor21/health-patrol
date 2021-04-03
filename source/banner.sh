#!/bin/bash
#----------
dir_path=("database" "source" "database/user_auth" "database/medical_record" "database/health_info")
file_path=("${dir_path[2]}/session" "${dir_path[2]}/profile.json" "${dir_path[2]}/profile-growth.json" "${dir_path[2]}/history.log" "${dir_path[4]}/disease_generic.json" "${dir_path[4]}/disease_regex.json")

RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[36m"
YELLOW="\e[33m"
DARK_G="\e[37m"
ENDCOLOR="\e[0m"

curdate=$(date +"%D %r")
date_format=$()
curdate="${GREEN}$curdate${BLUE}"
page="$2"
user="$3"
kid="$4"
info_pengguna=$(cat "${file_path[1]}" | grep ": {" | cut -d '"' -f 2 | wc -l)

left_b="${YELLOW}[${ENDCOLOR}"; right_b="${YELLOW}]${ENDCOLOR}"
head=""
foot=""
foot2=""
head+="${GREEN}"	
head+="██╗  ██╗███████╗ █████╗ ██╗  ████████╗██╗  ██╗ \n"
head+="██║  ██║██╔════╝██╔══██╗██║  ╚══██╔══╝██║  ██║ \n"
head+="███████║█████╗  ███████║██║     ██║   ███████║  ███ ███║ ███ ███║ \n"   
head+="██╔══██║██╔══╝  ██╔══██║██║     ██║   ██╔══██║   █████║   █████║  \n"    
head+="██║  ██║███████╗██║  ██║███████╗██║   ██║  ██║    ███║     ███║   \n"   
head+="╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚══════╝╚═╝   ╚═╝  ╚═╝                   \n"
head+="${BLUE}"                                              
head+="█████╗  █████╗ ████████╗███████╗████████╗██╗    PAGE : ${GREEN}%-13s${BLUE} | PENYAKIT   : ${GREEN}20${BLUE}\n"   
head+="██╔═██╗██╔══██╗╚══██╔══╝██╔══██║██╔═══██║██║    USER : ${GREEN}%-13s${BLUE} | GEJALA     : ${GREEN}38${BLUE}\n"    
head+="█████╔╝███████║   ██║   ██████╔╝██║   ██║██║    KID  : ${GREEN}%-13s${BLUE} | PENANGANAN : ${GREEN}50${BLUE}\n"    
head+="██╔══╝ ██╔══██║   ██║   ██╔═███ ████████╝████║  $curdate | PENGGUNA   : ${GREEN}$info_pengguna${BLUE}\n"    
head+="╚════════════════════════════════════════════════════════════════════════════════════════════════════════════"
foot+="${BLUE}═════════════════════════════════════════════════════════════════════════════════════════════════════════════${ENDCOLOR}"
foot2+="${DARK_G}---------------------------------------------------------------------------------------------------${ENDCOLOR}"
head+="${ENDCOLOR}"

case $1 in
	"1")
	 	printf "$head" "$page" "$user" "$kid"
		;;
	"2")
		echo -e "$foot"
		;;
	"3")
		echo -e "$foot2"
		;;
esac
