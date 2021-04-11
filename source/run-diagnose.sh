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
read -p "║::  saturasi_oksigen ........ : " get_saturation
if [[ "$get_height" && "$get_weight" && "$get_temp" && "$get_freqbreath" && "$get_saturation" ]]; then
	echo -e "║::  $foot2"
	printf  "║::  ${YELLOW}-${ENDCOLOR} %-25s ${YELLOW}-${ENDCOLOR} %-25s ${YELLOW}-${ENDCOLOR} %-26s\n" "batuk_sulit_bernafas" "masalah_berat_badan" "masalah_sulit_tidur" "masalah_nafsu_makan" "menangis_berlebihan" "masalah_mmuntah_diare"
	echo -e "║::  $foot2"
	read -p "║::  pilih_gejala_utama ...... : " main_gejala
	read -p "║::  lama_mengalami_gejala ... : " get_sicktime
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
		while [[ $ans != "done" ]]; do
			printf "║::  ${YELLOW}%.2d - ${ENDCOLOR}" "$number" ; read ans
			if [[ "$ans" ]]; then
				comp+="$ans\n"
			fi
			number=$((++number))
		done
		echo -e "$comp" | head -n -2 | tr -s '-' '_' > "${file_path[7]}"

		while [[ "$itr" -lt "$idx" ]]; do
			param_suhu=$(jq ".$main_gejala[$itr].param_suhu" "${file_path[4]}")
			param_saturasi=$(jq ".$main_gejala[$itr].param_saturasi" "${file_path[4]}")
			if [[ "$get_age" -lt 1 ]]; then
				param_nafas=$(jq ".$main_gejala[$itr].param_nafas[0]" "${file_path[4]}")
			else
				param_nafas=$(jq ".$main_gejala[$itr].param_nafas[1]" "${file_path[4]}")
			fi
			## kalkulasi param

			## kalulasi regex
			catch_symtomp=""
			while IFS= read -r each_symtomp; do
				##jadiin multiple pattern
				deli_each=$(echo "$each_symtomp" | cut -d '"' -f 2)
				catch_symtomp+="|$deli_each"
			done < "${file_path[7]}"
			fin_symtomp=$(echo "$catch_symtomp" | cut -c 2-)
			#echo "$fin_symtomp"

			## lemmetization matching + cf setter
			idx_regex=$(jq ".$main_gejala[$itr] | length" "${file_path[5]}")
			idx_arr=0
			arr_regex=""
			touch "${file_path[7]}.tmp"
			cat /dev/null > "${file_path[7]}.tmp"
			while IFS= read -r each_symtomp; do
				itr_regex=0
				while [[ "$itr_regex" -lt  "$idx_regex" ]]; do
					#statements
					#grep each symmtpp ganti jadi fin symptop
					search_gejala=$(jq ".$main_gejala[$itr].gejala_$itr_regex" "${file_path[5]}" | grep -E "$each_symtomp")
					if [[ "$search_gejala" ]]; then
						# mulai itung cf
						#echo "$itr_regex - $each_symtomp - $search_gejala"
						cf_rule=$(cat "${file_path[5]}" | grep -E "$each_symtomp" | wc -l)
						cf_tag=$(cat "${file_path[5]}" | tr -s '-' '_' | grep -E "$each_symtomp" | tr -d '\t')
						check_tag=$(cat "${file_path[7]}.tmp" | grep "$cf_tag")
						if [[ ! "$check_tag" ]]; then
							# aman
							echo "$cf_tag" >> "${file_path[7]}.tmp"
							calc_cf=$(echo "(1/$cf_rule)*100" | bc -l | cut -c 1-5)
							arr_regex[$idx_arr]="$calc_cf"
							idx_arr=$((++idx_arr))
						fi
					fi
					itr_regex=$((++itr_regex))
				done
			done < "${file_path[7]}"
			number=$((number-2))
			cf_regexmatch=$(echo "(${#arr_regex[@]}/$idx_regex)" | bc -l | cut -c 1-5)
			cf_regexless=$(echo "(${#arr_regex[@]}/$number)/10" | bc -l | cut -c 1-5)
			cf_rate=$(echo "($cf_regexmatch - (0.1-$cf_regexless))*100" | bc -l | cut -c 1-5)

			## hitung cf combine
			#echo -e "${arr_regex[@]}"
			#cat "${file_path[7]}.tmp"
			#echo -e "$number $cf_regexmatch , $cf_regexless , $cf_rate\n"
			arr_regex_len=${#arr_regex[@]}
			check_idx=0
			catch_arr=${arr_regex[0]}
			while [ "$check_idx" -lt "$arr_regex_len" ]; do
				if [[ $((check_idx+1)) < $arr_regex_len ]]; then
					echo "$catch_arr + ${arr_regex[$((check_idx+1))]}"
					cf_combine=$(echo "$catch_arr + (${arr_regex[$((check_idx+1))]} * (100 - $catch_arr))" | bc -l | cut -c 1-5)
					catch_arr=$cf_combine
				fi
				check_idx=$((++check_idx))			
			done
			echo "$cf_regexmatch - (0.1-$cf_regexless) * 100"
			echo "$catch_arr + $cf_rate / 2"
			if (( $( echo "$get_temp < $param_suhu" | bc -l) && $( echo "$param_suhu > 0" | bc -l) )); then
				catch_arr=$(echo "$catch_arr - 2.5" | bc -l | cut -c 1-5)
			fi
			if (( $( echo "$get_freqbreath < $param_nafas" | bc -l) && $( echo "$param_nafas > 0" | bc -l) )); then			
				catch_arr=$(echo "$catch_arr - 2.5" | bc -l | cut -c 1-5)
			fi
			if (( $( echo "$get_saturation > $param_saturasi" | bc -l) && $( echo "$param_saturasi > 0" | bc -l) )); then						
				catch_arr=$(echo "$catch_arr - 2.5" | bc -l | cut -c 1-5)
			fi			

			cf_fix=$(echo "($catch_arr + $cf_rate)/2" | bc -l | cut -c 1-5)
			echo -e "---\n$cf_fix"
			itr=$((++itr))
		done
	else
		echo ""			
	fi
else
	echo ""
fi

# desimal : echo "(4/6)*100" | bc -l | cut -c 1-5 [v]
# ubah - jadi _ di regex / langsung di file [v]
# masukin itungan parameter
# masukin ke file, sort yang cf fix paling tinggi dia keluar