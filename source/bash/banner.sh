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
ctr_keyword=0
itr=0
jq ".index[]" "${file_path[6]}" | cut -d '"' -f 2 > "${file_path[6]}.tmp"
while IFS= read -r index; do
	each_ctr_penyakit=$(jq ".$index | length" "${file_path[4]}")
	while [[ "$itr" -le "$each_ctr_penyakit" ]]; do
		itr_rgx=0
		each_ctr_gejala=$(jq ".$index[$itr].gejala | length" "${file_path[4]}")
		each_ctr_penanganan=$(jq ".$index[$itr].pertolongan_pertama | length" "${file_path[4]}")
		ctr_gejala=$((ctr_gejala+each_ctr_gejala))
		ctr_penanganan=$((ctr_penanganan+each_ctr_penanganan))

		each_ctr_gejala_rgx=$(jq ".$index[$itr] | length" "${file_path[5]}")
		while [[ "$itr_rgx" -le "$each_ctr_gejala_rgx" ]]; do
			ext_itr="$itr"
			ext_itr+="_$itr_rgx"			
			each_len_gejala_rgx=$(jq ".$index[$itr].gejala_$ext_itr | length" "${file_path[5]}")
			ctr_keyword=$((ctr_keyword+each_len_gejala_rgx))
			itr_rgx=$((++itr_rgx))
		done

		itr=$((++itr))
	done
	ctr_penyakit=$((ctr_penyakit+each_ctr_penyakit))

done < "${file_path[6]}.tmp"
rm "${file_path[6]}.tmp"
info_penyakit="$ctr_penyakit"
info_gejala="$ctr_gejala"
info_penanganan="$ctr_penanganan"
info_keyword="$ctr_keyword"

left_b="${YELLOW}[${ENDCOLOR}"; right_b="${YELLOW}]${ENDCOLOR}"
head=""
foot=""
foot2=""
foot3=""
head+="${GREEN}"	
head+="██╗  ██╗███████╗ █████╗ ██╗  ████████╗██╗  ██╗ \n"
head+="██║  ██║██╔════╝██╔══██╗██║  ╚══██╔══╝██║  ██║ \n"
head+="███████║█████╗  ███████║██║     ██║   ███████║  ${RED}███ ███║ ███ ███║ ███ ███║${GREEN} \n"   
head+="██╔══██║██╔══╝  ██╔══██║██║     ██║   ██╔══██║   ${RED}█████║   █████║   █████║${GREEN}  \n"    
head+="██║  ██║███████╗██║  ██║███████╗██║   ██║  ██║    ${RED}███║     ███║     ███║${GREEN}   \n"   
head+="╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚══════╝╚═╝   ╚═╝  ╚═╝                   \n"
head+="${BLUE}"                                              
head+="█████╗  █████╗ ████████╗███████╗████████╗██╗    PAGE  : ${GREEN}%-13s${BLUE} | PENYAKIT   : ${GREEN}$info_penyakit${BLUE}\n"   
head+="██╔═██╗██╔══██╗╚══██╔══╝██╔══██║██╔═══██║██║    ORTU  : ${GREEN}%-13s${BLUE} | GEJALA     : ${GREEN}$info_gejala${BLUE}\n"    
head+="█████╔╝███████║   ██║   ██████╔╝██║   ██║██║    ANAK  : ${GREEN}%-13s${BLUE} | PENANGANAN : ${GREEN}$info_penanganan${BLUE}\n"    
head+="██╔══╝ ██╔══██║   ██║   ██╔═███ ████████╝████║  $curdate  | KATA-KUNCI : ${GREEN}$info_keyword${BLUE}\n"    
head+="╚═════════════════════════════════════════════════════════════════════════════════════════════════════════════\n"
foot+="${BLUE}══════════════════════════════════════════════════════════════════════════════════════════════════════════════${ENDCOLOR}"
foot2+="${DARK_G}----------------------------------------------------------------------------------------------------${ENDCOLOR}"
foot3+="${DARK_G}+------------------------------------------------------------------------------------------------------------+${ENDCOLOR}"
foot4+="${DARK_G}==============================================================================================${ENDCOLOR}"
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
	"4")
		echo -e "$foot3"
		;;		
	"5")
		echo -e "$foot4"
		;;				
esac
