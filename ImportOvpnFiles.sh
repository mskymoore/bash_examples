#!/bin/bash


# Title:	ImportOvpnFiles.sh
# Author:	Sky Moore (mskymoore@gmail.com)
# Summary:	Takes a directory, searches for .ovpn files, checks if there are connections named 
#		the same, imports those connections that done have duplicates with nmcli.
# Options:	[-d /directory/to/search/]
# Exit Codes:   0: Successful Execution
#		1: nmcli not installed on this system
#		2: No .ovpn files found in the directory supplied
#		3: Directory supplied is invalid or does not exist


usage() { echo "$0 usage:" && grep ".)\ #" $0; exit 1; }

# if this environment has nmcli available
if [[ $(command -v nmcli) ]];then
	# Get root permissions required for adding connections with nmcli
	sudo ls &> /dev/null
# else there is no point proceeding
else
	echo "nmcli is required for this script, exiting..."
	exit 1
fi


# if there are no arguments sent to this script, call usage function
[ $# -eq 0 ] && usage
while getopts ":hd:" arg; do
	case $arg in
		d) # Specify directory where .ovpn files are stored
			FileDirectory=$(readlink -f ${OPTARG})
			;;
		h | *) # Display this help message.
			usage
			exit 0
			;;
	esac
done


echo "Checking if directory exists..."
if [[ -e $FileDirectory ]];then
	# If the directory string doesn't end in a / for output, then concatenate one
	if [[ ${FileDirectory: -1} != "/" ]];then
		FileDirectory="$FileDirectory/"
	fi
	# Only get the files that have ovpn somewhere in their name
	FileList=$(ls $FileDirectory | grep ovpn)
	echo "Valid directory. Checking for $FileDirectory*.ovpn..."
	# For each file in the list
	for file in $FileList;do
		# If the file ends in .ovpn	
		if [[ ${file: -5} == ".ovpn" ]];then
			echo "Ovpn files found in directory:"
			ovpnFilesFound=true
			break	
		fi
	done
	if [[ $ovpnFilesFound  = true ]] ; then
		# Get list of existing vpn connections
		vpnConnections=$(nmcli connection show | grep vpn)
		# For each file in the list
		for file in $FileList;do
			foundMatch=false
			# For each vpn connection in the list
			for connection in $vpnConnections;do
				# if concatenating the .ovpn extension makes the connection name equal to the file name
				if [[ $connection".ovpn" == $file ]];then
					# it is highly likely that this would be a duplicate and we should skip this one
					echo "$connection or a connection with the same name already exists, skipping..."
					foundMatch=true
					break
				fi
			done
			# if a match was not found for this file
			if [[ $foundMatch = false ]];then
				#import the connection
				echo "Importing connection $file..."
				sudo nmcli connection import type openvpn file $FileDirectory$file
			fi
		done
		echo "Operation completed successfully!"
	else
		echo "No ovpn files found in $FileDirectory, exiting..."
		exit 2
	fi
else
	echo "$FileDirectory does not exist or is invalid, exiting..."
	exit 3
fi
exit 0
