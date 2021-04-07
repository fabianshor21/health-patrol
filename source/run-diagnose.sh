#!/bin/bash
#----------
dir_path=("database" "source" "database/user_auth" "database/medical_record" "database/health_info")
file_path=("${dir_path[2]}/session" "${dir_path[2]}/profile.json" "${dir_path[2]}/profile-growth.json" "${dir_path[2]}/history.log" "${dir_path[4]}/disease_generic.json" "${dir_path[4]}/disease_regex.json" "${dir_path[4]}/disease_class.json" "${dir_path[4]}/fetch_symtomps")

RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[36m"
YELLOW="\e[33m"
DARK_G="\e[37m"
ENDCOLOR="\e[0m"
foot2=$(bash source/banner.sh 3)

read -p "║::  tinggi_badan ............ : " get_height
read -p "║::  berat_badan ............. : " get_weight
read -p "║::  suhu_badan_kepala ....... : " get_temp
read -p "║::  frekuensi_ambil_nafas ... : " get_freqbreath
read -p "║::  frekuensi_denyut_nadi ... : " get_freqbreath
read -p "║::  saturasi_oksigen ........ : " get_freqbreath
echo -e "║::  $foot2"
printf  "║::  ${YELLOW}-${ENDCOLOR} %-25s ${YELLOW}-${ENDCOLOR} %-25s ${YELLOW}-${ENDCOLOR} %-26s\n" "batuk_sulit_bernafas" "masalah_berat_badan" "masalah_sulit_tidur" "masalah_nafsu_makan" "menangis_berlebihan" "masalah_mmuntah_diare"
echo -e "║::  $foot2"
read -p "║::  pilih_gejala_utama ...... : " main_gejala

check_gejala=$(jq ".$main_gejala" "${file_path[4]}")
if [[ "$check_gejala" != "null" ]]; then
	itr=0
	idx=$(jq ".$main_gejala | length" "${file_path[4]}")
	curdate=$(date +"%Y-%m-%d")
	get_user=$(cat "${file_path[0]}" | cut -d ' ' -f 1)
	get_kid=$(cat "${file_path[0]}" | cut -d ' ' -f 2)
	get_birth=$(jq ".$get_user[1].$get_kid.tanggal_lahir" "${file_path[1]}" | cut -d '"' -f 2)
	get_age=$(dateutils.ddiff $get_birth $curdate)
	get_age=$((get_age/365))
	get_age=$(echo "$get_age" | perl -nl -MPOSIX -e 'print floor($_);')
	if [[ "$get_age" -lt 1 ]]; then
		param_nafas=$(jq ".$main_gejala[$itr].param_nafas[0]" "${file_path[4]}")
	else
		param_nafas=$(jq ".$main_gejala[$itr].param_nafas[1]" "${file_path[4]}")		
	fi
	echo -e "║::  tuliskan gejala yang anda alami ${GREEN}satu-per-satu${ENDCOLOR} secara singkat dan jelas"
	echo -e "║::  $foot2"
	ans=""
	comp=""
	number=1
	while [[ $ans != "end" ]]; do
		printf "║::  ${YELLOW}%.2d - ${ENDCOLOR}" "$number" ; read ans
		if [[ "$ans" ]]; then
			comp+="$ans\n"
		fi
		number=$((++number))
	done
	echo -e "$comp" | head -n -2 > "${file_path[7]}"

	while [[ "$itr" -le "$each_ctr_penyakit" ]]; do
		param_suhu=$(jq ".$main_gejala[$itr].param_suhu" "${file_path[4]}")
		param_saturasi=$(jq ".$main_gejala[$itr].param_saturasi" "${file_path[4]}")
		if [[ "$get_age" -lt 1 ]]; then
			param_nafas=$(jq ".$main_gejala[$itr].param_nafas[0]" "${file_path[4]}")
		else
			param_nafas=$(jq ".$main_gejala[$itr].param_nafas[1]" "${file_path[4]}")
		fi
		## main calculation goes here beb
		itr=$((++itr))
	done
else
	echo ""
fi
