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
left_b="${YELLOW}[${ENDCOLOR}"; right_b="${YELLOW}]${ENDCOLOR}"
user=$(cat ${file_path[0]} | cut -d ' ' -f 1 | tail -n 1); user=$(echo "${user^^}")
kid=$(cat ${file_path[0]} | cut -d ' ' -f 2 | tail -n 1); kid=$(echo "${kid^^}")
foot2=$(bash source/bash/banner.sh 3)
foot3=$(bash source/bash/banner.sh 4)
foot4=$(bash source/bash/banner.sh 5)

while :; do
	clear
	bash source/bash/banner.sh 1 HOME "$user" "$kid"
#	printf  "║::  $left_b${BLUE}DP$right_b %-18s | $left_b${BLUE}PA$right_b %-18s | $left_b${BLUE}UP$right_b %-18s | $left_b${BLUE}RP$right_b %-18s ::║${ENDCOLOR}\n" "DIAGNOSA_PENYAKIT" "PERKEMBANGAN_ANAK" "UBAH_PROFIL" "RIWAYAT_PROFIL"
#	printf  "║::  $left_b${BLUE}PP$right_b %-18s | $left_b${BLUE}RF$right_b %-18s | $left_b${BLUE}IP$right_b %-18s | $left_b${BLUE}KB$right_b %-18s ::║${ENDCOLOR}\n" "PANDUAN_PROGRAM" "REFERENSI" "INFO_PUSKESMAS" "KEMBALI"	
	printf  "║::  $left_b${BLUE}DP$right_b %-18s | $left_b${BLUE}PP$right_b %-18s | $left_b${BLUE}SR$right_b %-18s | $left_b${BLUE}KB$right_b %-18s ::║${ENDCOLOR}\n" "DIAGNOSA_PENYAKIT" "PANDUAN_PROGRAM" "SUMBER_REFERENSI" "KEMBALI"
	echo -e "║::  $foot2  ::║"
	bash source/bash/banner.sh 2

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
				bash source/bash/banner.sh 2
				bash source/bash/run-diagnose.sh
				;;
			"PP"|"pp")
				echo -e "     $foot2"		
				echo -e "     ${YELLOW}1.${ENDCOLOR} untuk mulai melakukan fitur diagnosa, masukan kode ${GREEN}DP${ENDCOLOR}"
				echo -e "     ${YELLOW}2.${ENDCOLOR} akan ada beberapa ${GREEN}parameter${ENDCOLOR} yang harus diisi, disesuaikan dengan kondisi anak"				
				echo -e "     ${YELLOW}3.${ENDCOLOR} gejala utama adalah ${GREEN}generalisasi${ENDCOLOR} dari apa yang gejala-gejala yang anak rasakan sekarang"								
				echo -e "     ${YELLOW}4.${ENDCOLOR} lama gejala dapat dihitung dari ${GREEN}berapa hari${ENDCOLOR} anak mengalami gejala tersebut"												
				echo -e "     ${YELLOW}5.${ENDCOLOR} anda dapat menyebutkan gejala-gejala tersebut lewat ${GREEN}microphone${ENDCOLOR} dengan batas waktu 15 detik"
				echo -e "     ${YELLOW}6.${ENDCOLOR} sebelumnya akan diberikan ${GREEN}panduan${ENDCOLOR} dalam penyebutan gejala, yang dapat dibaca dalam 15 detik\n"																				
				;;
			"SR"|"sr")
				echo -e "     $foot2"		
				echo -e "     ${YELLOW}1.${ENDCOLOR} Pneumonia pada Anak Balita di Indonesia ${GREEN}//${ENDCOLOR} Anwar, Athena, Ika Dharmayanti 2014"
				echo -e "     ${YELLOW}2.${ENDCOLOR} Buku Bagan: Manajemen Terpadu Balita Sakit (MTBS) ${GREEN}//${ENDCOLOR} Kementrian Kesehatan RI 2015"				
				echo -e "     ${YELLOW}3.${ENDCOLOR} Buku Saku: Pelayanan Kesehatan Anak di Rumah Sakit ${GREEN}//${ENDCOLOR} WHO, Bakti Husada, Ikatan Dokter Anak Indonesia\n"								
				;;					
		esac
	done
done