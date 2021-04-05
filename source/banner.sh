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

curdate=$(date +"%D %r")
date_format=$()
curdate="${GREEN}$curdate${BLUE}"
page="$2"
user="$3"
kid="$4"
info_pengguna=$(cat "${file_path[1]}" | grep ": {" | cut -d '"' -f 2 | wc -l)

ctr_penyakit=0
ctr_gejala=0
ctr_penanganan=0
itr=0
jq ".index[]" "${file_path[6]}" | cut -d '"' -f 2 > "${file_path[6]}.tmp"
while IFS= read -r index; do
	each_ctr_penyakit=$(jq ".$index | length" "${file_path[4]}")
	while [[ "$itr" -le "$each_ctr_penyakit" ]]; do
		each_ctr_gejala=$(jq ".$index[$itr].gejala | length" "${file_path[4]}")
		each_ctr_penanganan=$(jq ".$index[$itr].pertolongan_pertama | length" "${file_path[4]}")
		ctr_gejala=$((ctr_gejala+each_ctr_gejala))
		ctr_penanganan=$((ctr_penanganan+each_ctr_penanganan))
		itr=$((++itr))
	done
	ctr_penyakit=$((ctr_penyakit+each_ctr_penyakit))
done < "${file_path[6]}.tmp"
rm "${file_path[6]}.tmp"
info_penyakit="$ctr_penyakit"
info_gejala="$ctr_gejala"
info_penanganan="$ctr_penanganan"

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
head+="█████╗  █████╗ ████████╗███████╗████████╗██╗    PAGE : ${GREEN}%-13s${BLUE} | PENYAKIT   : ${GREEN}$info_penyakit${BLUE}\n"   
head+="██╔═██╗██╔══██╗╚══██╔══╝██╔══██║██╔═══██║██║    USER : ${GREEN}%-13s${BLUE} | GEJALA     : ${GREEN}$info_gejala${BLUE}\n"    
head+="█████╔╝███████║   ██║   ██████╔╝██║   ██║██║    KID  : ${GREEN}%-13s${BLUE} | PENANGANAN : ${GREEN}$info_penanganan${BLUE}\n"    
head+="██╔══╝ ██╔══██║   ██║   ██╔═███ ████████╝████║  $curdate | PENGGUNA   : ${GREEN}$info_pengguna${BLUE}\n"    
head+="╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════"
foot+="${BLUE}════════════════════════════════════════════════════════════════════════════════════════════════════════════${ENDCOLOR}"
foot2+="${DARK_G}--------------------------------------------------------------------------------------------------${ENDCOLOR}"
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
