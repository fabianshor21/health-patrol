#!/bin/bash
#----------
dir_path=("database" "source" "database/user_auth" "database/medical_record" "database/health_info" "web-page")
file_path=("${dir_path[2]}/session" "${dir_path[2]}/profile.json" "${dir_path[2]}/profile-growth.json" "${dir_path[2]}/history.log" "${dir_path[4]}/disease_generic.json" "${dir_path[4]}/disease_regex.json" "${dir_path[4]}/disease_class.json" "${dir_path[4]}/fetch_symtomps" "${dir_path[4]}/fetch_results" "${dir_path[4]}/speech-record.wav")

RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[36m"
YELLOW="\e[33m"
DARK_G="\e[37m"
ENDCOLOR="\e[0m"
foot2=$(bash source/bash/banner.sh 3)

case $1 in
	"signin")
		read -p  "ā::  nama_pengguna ..... : " get_user
		read -p  "ā::  nama_panggilan_anak : " get_kid
		read -sp "ā::  kata_sandi ........ : " get_pass
		get_valid=$(cat "${file_path[1]}" | grep -w "$get_user")
		if [[ "$get_user" &&  "$get_pass" ]]; then
			if [[ ! "$get_kid" ]]; then
				get_kid="nullPointerAddress"
			fi
			if [[ "$get_valid" ]]; then
				pass_hash=$(echo "$get_pass" | md5sum | cut -d ' ' -f 1)
				load_hash=$(jq ".$get_user[0].kata_sandi" ${file_path[1]} | cut -d '"' -f 2)
				if [[ "$pass_hash" == "$load_hash" ]]; then
					check_kid=$(jq ".$get_user[1].$get_kid.nama_panggilan_anak" ${file_path[1]} | cut -d '"' -f 2)
					if [[ "$get_kid" == "$check_kid" ]]; then
						echo -e ""
						timestamp=$(date +"%D--%T")
						echo "$timestamp $get_user $get_kid" >> "${file_path[3]}"
						echo "$get_user $get_kid" > "${file_path[0]}"
						bash source/bash/home.sh
					else
						echo -e "\nā::  $foot2"
						jq ".$get_user[1]" "${file_path[1]}" | grep ": {" | cut -d '"' -f 2 > "${file_path[1]}.tmp"
						if [[ -s "${file_path[1]}.tmp" ]]; then
							echo -e "     berikut data anak yang terdaftar untuk nama_pengguna ${GREEN}$get_user${ENDCOLOR}:"
							echo -e "     $foot2"													
							while IFS= read -r get_line; do
								get_kidname=$(jq ".$get_user[1].$get_line.nama_panjang_anak" ${file_path[1]})
								get_kidname=$(echo $get_kidname | cut -d '"' -f 2)
								echo -e " --  $get_line / $get_kidname"
							done < "${file_path[1]}.tmp"
							rm "${file_path[1]}.tmp"
						else
							echo -e "     belum ada anak yang terdata untuk nama_pengguna ${YELLOW}$get_user${ENDCOLOR}!"
						fi
					fi
				else
					echo -e "\nā::  $foot2"
					echo -e "     kata_sandi untuk nama_pengguna ${RED}$get_user${ENDCOLOR} tidak cocok!"
				fi
			else
				echo -e "\nā::  $foot2"
				echo -e "     nama_pengguna ${YELLOW}$get_user${ENDCOLOR} belum terdaftar dalam sistem!"
			fi
		fi
		echo -e ""		
		;;
	"signup")
		curdate=$(date +"%Y-%m-%d")
		read -p "ā::  nama_orangtua ......... : " get_parentname
		read -p "ā::  nama_wali_pengganti ... : " get_subtname
		read -p "ā::  nama_pengguna ......... : " get_username
		read -p "ā::  kata_sandi ............ : " get_pass
		read -p "ā::  no_kartu_keluarga ..... : " get_kk
		read -p "ā::  no_telepon ............ : " get_phone
		read -p "ā::  alamat_email .......... : " get_email

		if [[ "$get_parentname" && "$get_username" && "$get_pass" && "$get_phone" && "$get_kk" ]]; then
			check_account=$(cat "${file_path[1]}" | grep -E "$get_username")
			if [[ ! "$check_account" ]]; then
				pass_hash=$(echo "$get_pass" | md5sum | cut -d ' ' -f 1)
				ctr=$(jq ".index" ${file_path[1]} | grep "nama_pengguna" | wc -l)
				jq ".$get_username[0] += {\"nama_orangtua\":\"$get_parentname\",\"nama_wali_pengganti\":\"$get_subtname\",\"nama_pengguna\":\"$get_username\",\"kata_sandi\":\"$pass_hash\",\"no_kartu_keluarga\":\"$get_kk\",\"no_telepon\":\"$get_phone\",\"alamat_email\":\"$get_email\"}" "${file_path[1]}" > "${file_path[1]}.tmp" && 
				cat "${file_path[1]}.tmp" > "${file_path[1]}" &&
				rm "${file_path[1]}.tmp" 
				echo -e "ā::  $foot2"
				echo -e "     akun dengan nama_pengguna ${GREEN}$get_username${ENDCOLOR} berhasil dibuat!"
			else
				echo -e "ā::  $foot2"
				echo -e "     akun dengan nama_pengguna ${RED}$get_username${ENDCOLOR} sudah tidak tersedia!"
			fi
		fi

		echo -e ""		
		;;
	"addkid")
		read -p  "ā::  nama_pengguna : " get_user
		read -sp "ā::  kata_sandi    : " get_pass
		get_valid=$(cat "${file_path[1]}" | grep -E "$get_user")
		if [[ "$get_valid" ]]; then
			pass_hash=$(echo "$get_pass" | md5sum | cut -d ' ' -f 1)
			load_hash=$(jq ".$get_user[0].kata_sandi" ${file_path[1]} | cut -d '"' -f 2)
			if [[ "$pass_hash" == "$load_hash" ]]; then
				curdate=$(date +"%Y-%m-%d")
				echo -e "\nā::  $foot2"
				read -p "ā::  nama_panjang_anak ..... : " get_kidname
				read -p "ā::  nama_panggilan_anak ... : " get_kidnickname
				read -p "ā::  jumlah_anak ........... : " get_siblings_tot
				read -p "ā::  urutan_anak ........... : " get_siblings_order
				read -p "ā::  tanggal_lahir ......... : " get_birth
				read -p "ā::  jenis_kelahiran ....... : " get_type_birth
				read -p "ā::  jenis_kelamin ......... : " get_type_sex
				read -p "ā::  tinggi_badan_lahir .... : " get_height
				read -p "ā::  berat_badan_lahir ..... : " get_weight
				read -p "ā::  kelainan_bawaan ....... : " get_inbred
				read -p "ā::  riwayat_infeksi_HIV ... : " get_hiv
				read -p "ā::  alergi_obat ........... : " get_alergy
				## imunisasi
				if [[ "$get_kidname" && "$get_siblings_tot" && "$get_siblings_order" && "$get_birth" && "$get_type_birth" && "$get_type_sex" && "$get_height" && "$get_weight" ]]; then
					sum_arr=$(echo "$get_inbred" | tr -s ' ' '_')
					sum_arr2=$(echo "$get_alergy" | tr -s ' ' '_')
					get_age=$(dateutils.ddiff $get_birth $curdate)
					get_age=$((get_age/365))
					get_age=$(echo "$get_age" | perl -nl -MPOSIX -e 'print floor($_);')
					ctr_kid=$(jq ".$get_user" "${file_path[1]}" | grep -E "nama_anak" | wc -l)
					ctr_kid=$((++ctr_kid))
					jq ".$get_user[1].$get_kidnickname += {\"nama_panjang_anak\":\"$get_kidname\",\"nama_panggilan_anak\":\"$get_kidnickname\",\"jumlah_anak\":$get_siblings_tot,\"urutan_anak\":$get_siblings_order,\"tanggal_lahir\":\"$get_birth\",\"jenis_kelahiran\":\"$get_type_birth\",\"jenis_kelamin\":\"$get_type_sex\",\"tinggi_badan_lahir\":\"$get_height\",\"berat_badan_lahir\":\"$get_weight\",\"kelainan_bawaan\":\"$sum_arr\",\"riwayat_infeksi_HIV\":\"$get_hiv\",\"alergi_obat\":\"$sum_arr2\"}" "${file_path[1]}" > "${file_path[1]}.tmp" && 
					#\"kelainan_bawaan\":\"$sum_arr\"
					cat "${file_path[1]}.tmp" > "${file_path[1]}" &&
					rm "${file_path[1]}.tmp"
					echo -e "ā::  $foot2"
					echo -e "     akun dengan nama_panggilan_anak ${GREEN}$get_kidname${ENDCOLOR} berhasil ditambahkan!"

				fi
			else
				echo -e "\nā::  $foot2"
				echo -e "     kata_sandi untuk nama_pengguna ${RED}$get_user${ENDCOLOR} tidak cocok!"
			fi
		else
			echo -e "\nā::  $foot2"
			echo -e "     nama_pengguna ${YELLOW}$get_user${ENDCOLOR} belum terdaftar dalam sistem!"
		fi
		echo -e ""
		;;
esac
# length dari item/array/object : jq '.nkdevi[1] | length' profile.json