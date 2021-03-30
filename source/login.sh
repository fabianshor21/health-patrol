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
		read -p  "║::  nama_pengguna : " get_user
		read -p  "║::  nama_anak     : " get_kid
		read -sp "║::  kata_sandi    : " get_pass
		get_valid=$(cat "${file_path[1]}" | grep -E "$get_user")
		if [[ $get_valid ]]; then
			bash source/home.sh
		fi
		echo -e "\n"		
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
		echo -e "║::  $foot2"
		read -p "║::  nama_anak ............. : " get_kidname
		read -p "║::  jumlah_anak ........... : " get_siblings_tot
		read -p "║::  urutan_anak ........... : " get_siblings_order
		read -p "║::  tanggal_lahir ......... : " get_birth
		read -p "║::  jenis_kelahiran ....... : " get_type_birth
		read -p "║::  jenis_kelamin ......... : " get_type_sex
		read -p "║::  tinggi_badan (cm) ..... : " get_height
		read -p "║::  berat_badan (kg) ...... : " get_weight
		read -p "║::  kelainan_bawaan ....... : " get_inbred

		if [[ "$get_parentname" && "$get_username" && "$get_pass" && "$get_phone" && "$get_kk" ]]; then
			check_account=$(cat "${file_path[1]}" | grep -E "$get_username")
			if [[ ! "$check_account" ]]; then
				if [[ "$get_kidname" && "$get_siblings_tot" && "$get_siblings_order" && "$get_birth" && "$get_type_birth" && "$get_type_sex" && "$get_height" && "$get_weight" ]]; then
					pass_hash=$(echo "$get_pass" | md5sum | cut -d ' ' -f 1)
					sudo jq ".$get_username += {\"nama_orangtua\":\"$get_parentname\",\"nama_wali_pengganti\":\"$get_subtname\",\"nama_pengguna\":\"$get_username\",\"kata_sandi\":\"$pass_hash\",\"no_kartu_keluarga\":\"$get_kk\",\"no_telepon\":\"$get_phone\",\"alamat_email\":\"$get_email\"}" "${file_path[1]}" > "${file_path[1]}.tmp" && 
					cat "${file_path[1]}.tmp" > "${file_path[1]}" &&
					rm "${file_path[1]}.tmp" 

					get_age=$(dateutils.ddiff $get_birth $curdate)
					get_age=$(echo "$get_age" | perl -nl -MPOSIX -e 'print floor($_);')
					sudo jq ".$get_username.anak[0] +="
					#cat "${file_path[1]}.tmp" > "${file_path[1]}" &&
					#rm "${file_path[1]}.tmp" 
				fi
			fi
		fi
		echo -e ""		
		;;
	"addkid")
		;;
esac
