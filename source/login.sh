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
foot2=$(bash source/banner.sh 3)

case $1 in
	"signin")
		read -p  "║::  nama_pengguna ..... : " get_user
		read -p  "║::  nama_panggilan_anak : " get_kid
		read -sp "║::  kata_sandi ........ : " get_pass
		get_valid=$(cat "${file_path[1]}" | grep -E "$get_user")
		if [[ "$get_user" && "$get_kid" && "$get_pass" ]]; then
			if [[ "$get_valid" ]]; then
				pass_hash=$(echo "$get_pass" | md5sum | cut -d ' ' -f 1)
				load_hash=$(jq ".$get_user[0].kata_sandi" ${file_path[1]} | cut -d '"' -f 2)
				if [[ "$pass_hash" == "$load_hash" ]]; then
					check_kid=$(jq ".$get_user[1].$get_kid.nama_panggilan_anak" ${file_path[1]} | cut -d '"' -f 2)
					if [[ "$get_kid" == "$check_kid" ]]; then
						bash source/home.sh
					else
						echo -e "\n║::  $foot2"
						sudo jq ".$get_user[1]" "${file_path[1]}" | grep ": {" | cut -d '"' -f 2 > "${file_path[1]}.tmp"
						bash source/banner.sh
						while IFS= read -r get_line; do
							get_kidname=$(jq ".$get_user[1].$get_line.nama_panjang_anak" ${file_path[1]})
							echo -e "║::  -| $get_line ($get_kidname)"
						done < "${file_path[1]}.tmp"
					fi
				fi
			fi
		fi
		echo -e ""		
		;;
	"signup")
		curdate=$(date +"%Y-%m-%d")
		read -p "║::  nama_orangtua ......... : " get_parentname
		read -p "║::  nama_wali_pengganti ... : " get_subtname
		read -p "║::  nama_pengguna ......... : " get_username
		read -p "║::  kata_sandi ............ : " get_pass
		read -p "║::  no_kartu_keluarga ..... : " get_kk
		read -p "║::  no_telepon ............ : " get_phone
		read -p "║::  alamat_email .......... : " get_email

		if [[ "$get_parentname" && "$get_username" && "$get_pass" && "$get_phone" && "$get_kk" ]]; then
			check_account=$(cat "${file_path[1]}" | grep -E "$get_username")
			if [[ ! "$check_account" ]]; then
				pass_hash=$(echo "$get_pass" | md5sum | cut -d ' ' -f 1)
				ctr=$(jq ".index" ${file_path[1]} | grep "nama_pengguna" | wc -l)
				sudo jq ".$get_username[0] += {\"nama_orangtua\":\"$get_parentname\",\"nama_wali_pengganti\":\"$get_subtname\",\"nama_pengguna\":\"$get_username\",\"kata_sandi\":\"$pass_hash\",\"no_kartu_keluarga\":\"$get_kk\",\"no_telepon\":\"$get_phone\",\"alamat_email\":\"$get_email\"}" "${file_path[1]}" > "${file_path[1]}.tmp" && 
				cat "${file_path[1]}.tmp" > "${file_path[1]}" &&
				rm "${file_path[1]}.tmp" 
				#sudo jq ".$get_username.anak[0] +="
				#cat "${file_path[1]}.tmp" > "${file_path[1]}" &&
				#rm "${file_path[1]}.tmp" 
			fi
		fi
		echo -e ""		
		;;
	"addkid")
		read -p  "║::  nama_pengguna : " get_user
		read -sp "║::  kata_sandi    : " get_pass
		get_valid=$(cat "${file_path[1]}" | grep -E "$get_user")
		if [[ "$get_valid" ]]; then
			pass_hash=$(echo "$get_pass" | md5sum | cut -d ' ' -f 1)
			load_hash=$(jq ".$get_user[0].kata_sandi" ${file_path[1]} | cut -d '"' -f 2)
			if [[ "$pass_hash" == "$load_hash" ]]; then
				curdate=$(date +"%Y-%m-%d")
				echo -e "\n║::  $foot2"
				read -p "║::  nama_panjang_anak ..... : " get_kidname
				read -p "║::  nama_panggilan_anak ... : " get_kidnickname
				read -p "║::  jumlah_anak ........... : " get_siblings_tot
				read -p "║::  urutan_anak ........... : " get_siblings_order
				read -p "║::  tanggal_lahir ......... : " get_birth
				read -p "║::  jenis_kelahiran ....... : " get_type_birth
				read -p "║::  jenis_kelamin ......... : " get_type_sex
				read -p "║::  tinggi_badan_lahir .... : " get_height
				read -p "║::  berat_badan_lahir ..... : " get_weight
				read -p "║::  kelainan_bawaan ....... : " get_inbred
				## imunisasi
				if [[ "$get_kidname" && "$get_siblings_tot" && "$get_siblings_order" && "$get_birth" && "$get_type_birth" && "$get_type_sex" && "$get_height" && "$get_weight" ]]; then
					sum_arr=$(echo "$get_inbred" | tr -s ' ' '_')
					get_age=$(dateutils.ddiff $get_birth $curdate)
					get_age=$((get_age/365))
					get_age=$(echo "$get_age" | perl -nl -MPOSIX -e 'print floor($_);')
					ctr_kid=$(jq ".$get_user" "${file_path[1]}" | grep -E "nama_anak" | wc -l)
					ctr_kid=$((++ctr_kid))
					sudo jq ".$get_user[1].$get_kidnickname += {\"nama_panjang_anak\":\"$get_kidname\",\"nama_panggilan_anak\":\"$get_kidnickname\",\"jumlah_anak\":\"$get_siblings_tot\",\"urutan_anak\":\"$get_siblings_order\",\"tanggal_lahir\":\"$get_birth\",\"jenis_kelahiran\":\"$get_type_birth\",\"jenis_kelamin\":\"$get_type_sex\",\"tinggi_badan_lahir\":\"$get_height\",\"berat_badan_lahir\":\"$get_weight\",\"kelainan_bawaan\":\"$sum_arr\"}" "${file_path[1]}" > "${file_path[1]}.tmp" && 
					#\"kelainan_bawaan\":\"$sum_arr\"
					cat "${file_path[1]}.tmp" > "${file_path[1]}" &&
					rm "${file_path[1]}.tmp"
				fi
			fi
		fi
		echo -e ""
		;;
esac
# length dari item/array/object : jq '.nkdevi[1] | length' profile.json