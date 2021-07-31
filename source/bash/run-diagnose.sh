#!/bin/bash
#----------
dir_path=("database" "source" "database/user_auth" "database/medical_record" "database/health_info" "web-page")
file_path=("${dir_path[2]}/session" "${dir_path[2]}/profile.json" "${dir_path[2]}/profile-growth.json" "${dir_path[2]}/history.log" "${dir_path[4]}/disease_generic.json" "${dir_path[4]}/disease_regex.json" "${dir_path[4]}/disease_class.json" "${dir_path[4]}/fetch_symtomps" "${dir_path[4]}/fetch_results" "${dir_path[4]}/speech-record.wav" "${dir_path[4]}/unmatched_symtomps" "${dir_path[3]}/diagnose_log.json")

RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[36m"
YELLOW="\e[33m"
DARK_G="\e[37m"
ENDCOLOR="\e[0m"
foot2=$(bash source/bash/banner.sh 3)
foot3=$(bash source/bash/banner.sh 4)
foot4=$(bash source/bash/banner.sh 5)

#get_curdate=$(date '+%Y_%m_%d')
#get_curtime=$(date '+%H:%M:%S')
#get_log_length=$(jq ".D_$get_curdate | length" "${file_path[11]}")
#jq ".D_$get_curdate[$get_log_length] += {\"timestamp\":\"$get_curtime\"}" "${file_path[11]}" > "${file_path[11]}.tmp" && 
#cat "${file_path[11]}.tmp" > "${file_path[11]}" &&
#rm "${file_path[11]}.tmp"

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
		echo -e "║::  ---"		
		echo -e "║::  sebutkan gejala yang anak anda alami ${GREEN}satu-per-satu${ENDCOLOR} secara singkat dan jelas dalam ${GREEN}Bahasa${ENDCOLOR} yang benar"
		echo -e "║::  pisah masing masing gejala dengan menyebutkan ${GREEN}koma${ENDCOLOR} dan mengakhirinya dengan menyebutkan ${GREEN}titik${ENDCOLOR}"		
		echo -e "║::  $foot2"
		sleep 15s

		echo -e "║::  ${YELLOW}[SISTEM]${ENDCOLOR} bersiap ..."; sleep 3s		
		echo -e "║::  ${YELLOW}[SISTEM]${ENDCOLOR} merekam suara ..."
		arecord -d 15 -f cd -t wav -q "${file_path[9]}";
		echo -e "║::  ${YELLOW}[SISTEM]${ENDCOLOR} mengkonversi suara ..."
		echo -e "║::  $foot2"		
		sleep 3s
		get_speech=$(python3 source/python/speech-to-text.py); sleep 3s
		if [[ "$get_speech" != "catch_recognizer" ]]; then
			space_speech=" $get_speech"
			#echo "$space_speech" | tr -s ',' '\n' | tr -d '.' | tr -s '-' '_' | cut -c 2- > "${file_path[7]}"
			
			deli="koma"
			concat=$space_speech$deli
			arr_deli=()
			while [[ $concat ]]; do
				arr_deli+=("${concat%%"$deli"*}@")
				concat=${concat#*"$deli"}
			done
			echo ${arr_deli[@]} | tr -s '@' '\n' | tr -d ' ' > "${file_path[7]}"

			ans=""
			comp=""
			number=1
			grep "\S" "${file_path[7]}" | tr -s '-' '_' > "${file_path[7]}.space"
			cat "${file_path[7]}.space" > "${file_path[7]}"

			while IFS= read -r each_symtomp_spch; do
				printf "║::  ${YELLOW}%.2d - ${ENDCOLOR}$each_symtomp_spch\n" "$number"
				number=$((++number))
			done < "${file_path[7]}"
			#echo -e "$comp" | head -n -2 | tr -s '-' '_' > "${file_path[7]}"
			touch "${file_path[8]}"; rm "${file_path[8]}"; touch "${file_path[8]}"
			echo -e "║::  $foot2"		

			while [[ "$itr" -lt "$idx" ]]; do
				fix_number=$number
				param_suhu=$(jq ".$main_gejala[$itr].param_suhu" "${file_path[4]}")
				param_saturasi=$(jq ".$main_gejala[$itr].param_saturasi" "${file_path[4]}")
				level=$(jq ".$main_gejala[$itr].level_penyakit" "${file_path[4]}")
				if [[ "$get_age" -lt 1 ]]; then
					param_nafas=$(jq ".$main_gejala[$itr].param_nafas[0]" "${file_path[4]}")
				else
					param_nafas=$(jq ".$main_gejala[$itr].param_nafas[1]" "${file_path[4]}")
				fi
				param_batas_penanganan=$(jq ".$main_gejala[$itr].param_batas_penanganan" "${file_path[4]}")
				if [[ "$get_sicktime" -ge "$param_batas_penanganan" ]]; then
					check_urgent="U"
				else
					check_urgent="N"
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
				touch "${file_path[7]}.tmp"
				rm "${file_path[7]}.tmp"
				touch "${file_path[7]}.tmp"
						
				arr_regex=()			
				while IFS= read -r each_symtomp; do
					itr_regex=0
					while [[ "$itr_regex" -lt  "$idx_regex" ]]; do
						ext_itr="$itr"
						ext_itr+="_$itr_regex"
						search_gejala=$(jq ".$main_gejala[$itr].gejala_$ext_itr" "${file_path[5]}" | grep -E "$each_symtomp")
						if [[ "$search_gejala" ]]; then
							cf_rule=$(cat "${file_path[5]}" | grep -E "$each_symtomp" | wc -l)
							cf_tag=$(cat "${file_path[5]}" | grep -E "gejala_$itr" | grep -E "$each_symtomp" | tr -d '\t' | cut -d '"' -f 2)
							check_tag=$(cat "${file_path[7]}.tmp" | grep -E "$cf_tag")
							if [[ ! "$check_tag" ]]; then
								echo "$cf_tag" >> "${file_path[7]}.tmp"
								calc_cf=$(echo "(1/$cf_rule)*100" | bc -l | cut -c 1-5)
								arr_regex[$idx_arr]="$calc_cf"
								idx_arr=$((++idx_arr))
							fi
						fi
						itr_regex=$((++itr_regex))
					done
				done < "${file_path[7]}"
				
				fin_number=$((fix_number-1))
				cf_regexmatch=$(echo "(${#arr_regex[@]}/$idx_regex)" | bc -l | cut -c 1-5)
				cf_regexless=$(echo "(${#arr_regex[@]}/$fin_number)/10" | bc -l | cut -c 1-5)
				cf_rate=$(echo "($cf_regexmatch - (0.1-$cf_regexless))*100" | bc -l | cut -c 1-5)

				## hitung cf combine
				#echo -e "${arr_regex[@]}"
				#cat "${file_path[7]}.tmp"
				#echo -e "$number $cf_regexmatch , $cf_regexless , $cf_rate\n"

				arr_regex_len=${#arr_regex[@]}
				check_idx=0
				catch_arr=${arr_regex[0]}
		#		echo "${arr_regex[@]}"
				while [ "$check_idx" -lt "$arr_regex_len" ]; do
					if [[ $((check_idx+1)) < $arr_regex_len ]]; then
						cf_combine=$(echo "$catch_arr + ((${arr_regex[$((check_idx+1))]} * (100 - $catch_arr)) / 100)" | bc -l | cut -c 1-5)
		#				echo "$catch_arr + ((${arr_regex[$((check_idx+1))]} * (100 - $catch_arr)) / 100) >> $cf_combine"
						catch_arr=$cf_combine
					fi
					check_idx=$((++check_idx))			
				done

				if [[ ${#arr_regex[@]} -gt 0 ]]; then			
		#			echo "---"
		#			echo "(${#arr_regex[@]}/$idx_regex)/10 -- (${#arr_regex[@]}/$fin_number)/10"			
		#			echo "$cf_regexmatch - (0.1-$cf_regexless) * 100"
					if (( $( echo "$get_temp < $param_suhu" | bc -l) && $( echo "$param_suhu > 0" | bc -l) )); then
						catch_arr=$(echo "$catch_arr - 5" | bc -l | cut -c 1-5)
					fi
					if (( $( echo "$get_freqbreath < $param_nafas" | bc -l) && $( echo "$param_nafas > 0" | bc -l) )); then			
						catch_arr=$(echo "$catch_arr - 5" | bc -l | cut -c 1-5)
					fi
					if (( $( echo "$get_saturation > $param_saturasi" | bc -l) && $( echo "$param_saturasi > 0" | bc -l) )); then						
						catch_arr=$(echo "$catch_arr - 5" | bc -l | cut -c 1-5)
					fi			
		#			echo "$catch_arr + $cf_rate / 2"
					cf_fix=$(echo "($catch_arr + $cf_rate)/2" | bc -l | cut -c 1-5)
					# if 
		#			echo -e "---\n$cf_fix % untuk penyakit index $itr\n"
					echo -e "$cf_fix\t$check_urgent\t$level\t$itr" >> "${file_path[8]}"
				fi
				itr=$((++itr))

			done
			check_result_file=$(grep "\S" "${file_path[8]}")
			if [[ "$check_result_file" ]]; then				
				sorted_res=$(cat "${file_path[8]}" | sort -r)
				echo "$sorted_res" > "${file_path[8]}"
				idx_dis=$(cat "${file_path[8]}" | head -n 1 | tr -s '\t' '@' | cut -d '@' -f 4)
				acc_dis=$(cat "${file_path[8]}" | head -n 1 | tr -s '\t' '@' | cut -d '@' -f 1)
				urg_dis=$(cat "${file_path[8]}" | head -n 1 | tr -s '\t' '@' | cut -d '@' -f 2)
				status=""
				if [[ "$urg_dis" == "U" ]]; then
					status="Anak berada dalam Fase Kritis. Rujukkan anak ke rumah sakit terdekat"
				else
					status="Anak berada dalam Fase Awal Gejala. Rujukkan anak ke puskesmas terdekat"
				fi
				penyakit=$(jq ".$main_gejala[$idx_dis].nama_penyakit" "${file_path[4]}" | cut -d '"' -f 2)
				ilmiah=$(jq ".$main_gejala[$idx_dis].nama_ilmiah" "${file_path[4]}" | cut -d '"' -f 2)
				full_penyakit="$penyakit ($ilmiah)"
				sinopsis=$(jq ".$main_gejala[$idx_dis].sinopsis" "${file_path[4]}" | cut -d '"' -f 2)

				send_ilmiiah=$ilmiah
				send_acc=$acc_dis

				jq ".$main_gejala[$idx_dis].gejala[]" "${file_path[4]}" | tr -d '"' > "${file_path[4]}.symp"
				jq ".$main_gejala[$idx_dis].penyebab[]" "${file_path[4]}" | tr -d '"' > "${file_path[4]}.caus"
				jq ".$main_gejala[$idx_dis].pertolongan_pertama[]" "${file_path[4]}" | tr -d '"' > "${file_path[4]}.help"		

				echo -e "\n$foot3"
				printf "| No | %-31s Detail Prediksi Diagnosis %-34s | Akurat |"
				echo -e "\n$foot3"
				printf "|${DARK_G}====${ENDCOLOR}|$foot4|${DARK_G}========${ENDCOLOR}|\n"
				printf "| ${YELLOW}1.${ENDCOLOR} | ${YELLOW}%-93s${ENDCOLOR}| ${YELLOW}%-6s${ENDCOLOR} |\n" "$full_penyakit" "$acc_dis"
				printf "| -- | -------------------------------------------------------------------------------------------- | ------ |\n" " "
				printf "|    | %-93s| %-6s |\n" "Sinopsis:" " "
				printf "|    | %-93s| %-6s |\n" "$sinopsis" " "
				printf "|    | -------------------------------------------------------------------------------------------- | %-6s |\n" " "		
				printf "|    | %-93s| %-6s |\n" "Gejala:" " "
				while IFS= read -r each_row; do
					printf "|    | +) %-90s| %-6s |\n" "$each_row" " "
				done < "${file_path[4]}.symp"
				printf "|    | -------------------------------------------------------------------------------------------- | %-6s |\n" " "		
				printf "|    | %-93s| %-6s |\n" "Penyebab:" " "		
				while IFS= read -r each_row; do
					printf "|    | +) %-90s| %-6s |\n" "$each_row" " "
				done < "${file_path[4]}.caus"		
				printf "|    | -------------------------------------------------------------------------------------------- | %-6s |\n" " "				
				printf "|    | %-93s| %-6s |\n" "Pertolongan Pertama:" " "		
				while IFS= read -r each_row; do
					printf "|    | +) %-90s| %-6s |\n" "$each_row" " "
				done < "${file_path[4]}.help"		
				printf "|    | -------------------------------------------------------------------------------------------- | %-6s |\n" " "
				printf "|    | %-93s| %-6s |\n" "Status Diagnosa:" " "
				printf "|    | %-93s| %-6s |\n" "$status" " "
				printf "| -- | -------------------------------------------------------------------------------------------- | ------ |\n" " "
				get_more_diag=$(cat "${file_path[8]}" | sed -n 2,3p)
				if [[ "$get_more_diag" ]]; then
					cat "${file_path[8]}" | sed -n 2,3p > "${file_path[8]}.more"
					ctr_more=2
					while IFS= read -r each_row; do
						idx_dis=$(echo "$each_row" | tr -s '\t' '@' | cut -d '@' -f 4)
						acc_dis=$(echo "$each_row" | tr -s '\t' '@' | cut -d '@' -f 1)
						penyakit=$(jq ".$main_gejala[$idx_dis].nama_penyakit" "${file_path[4]}" | cut -d '"' -f 2)
						ilmiah=$(jq ".$main_gejala[$idx_dis].nama_ilmiah" "${file_path[4]}" | cut -d '"' -f 2)
						full_penyakit="$penyakit ($ilmiah)"
						printf "| ${YELLOW}%-1s.${ENDCOLOR} | ${YELLOW}%-93s${ENDCOLOR}| ${YELLOW}%-6s${ENDCOLOR} |\n" "$ctr_more" "$full_penyakit" "$acc_dis"
						printf "| -- | -------------------------------------------------------------------------------------------- | ------ |\n" " "
						ctr_more=$((++ctr_more))																		
					done < "${file_path[8]}.more"
				fi
				printf "|${DARK_G}====${ENDCOLOR}|$foot4|${DARK_G}========${ENDCOLOR}|\n\n"

				get_curdate=$(date '+%Y_%m_%d')
				get_curtime=$(date '+%H:%M:%S')
				get_username=$(cat "${file_path[0]}" | cut -d ' ' -f 1)
				get_kid=$(cat "${file_path[0]}" | cut -d ' ' -f 2)				
				get_log_length=$(jq ".D_$get_curdate | length" "${file_path[11]}")
				catch_gejala=""

				while IFS= read -r each_row; do
					catch_gejala+="\"$each_row\","
				done < "${file_path[7]}"
				catch_gejala=${catch_gejala%?}

				jq ".D_$get_curdate[$get_log_length] += {\"timestamp\":\"$get_curtime\",\"nama_pengguna\":\"$get_username\",\"nama_panggian_anak\":\"$get_kid\",\"tinggi_badan\":$get_height,\"berat_badan\":$get_weight,\"suhu_badan_kepala\":$get_temp,\"frekuensi_ambil_nafas\":$get_freqbreath,\"saturasi_oksigen\":$get_saturation,\"gejala_utama\":\"$main_gejala\",\"lama_mengalami_gejala\":$get_sicktime,\"gejala\":[$catch_gejala],\"hasil_diagnosa\":[{\"nama_penyakit\":\"$send_ilmiiah\",\"nilai_cf_rate\":$send_acc}]}" "${file_path[11]}" > "${file_path[11]}.tmp" && 
				cat "${file_path[11]}.tmp" > "${file_path[11]}" &&
				rm "${file_path[11]}.tmp"

			else
				cat "${file_path[7]}" >> "${file_path[10]}"
				echo -e "     maaf, gejala yang anda berikan ${YELLOW}tidak cocok${ENDCOLOR} dengan dataset penyakit yang kini tersedia ..."
				echo -e "     gejala anda telah berhasil ${GREEN}tersimpan${ENDCOLOR} untuk nantinya diaudit oleh admin\n"
			fi
		else
			echo -e "     fitur SpeechRecognition dalam program ini membutuhkan koneksi ${GREEN}internet${ENDCOLOR} yang stabil untuk translasi"
			echo -e "     fitur diagnosa dengan input manual akan hadir dalam bentuk offline\n"
		fi
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
# format akurat : 68.12 %