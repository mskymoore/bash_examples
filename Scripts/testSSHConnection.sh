#!/bin/bash


# Title:	testSSHConnection.sh
# Author:       Sky Moore (mskymoore@gmail.com)
# Summary:      Attempts to log in to ssh servers with username@hostname lines read from input file, and reports to the console the result of the attempt.
#               
# Options:      [-i /file/to/read/from]
# Exit Codes:   0: successful execution
#               1: help printed or bad arguments
#               2: 
#               3: 

usage() { echo "$0 usage:" && grep ".)\ #" $0; exit 1; }


[ $# -eq 0 ] && usage

while getopts ":hi:" arg;do
	case $arg in
		i) # Input file to read username@hostname lines from
			InputFile=$(readlink -f ${OPTARG})
			;;
		#p)## Request a password to log in to all username@hostname with
		#	read -s -p "Password: " Password	
		#	;;
		h | *) # Display this help message
			usage
			;;
	esac
done

if [[ -z $InputFile ]];then
	echo "You must supply an input file."
	usage
fi

if [[ -e $InputFile ]];then
	IFS=$'\n' read -d '' -r -a lines < $InputFile
	for line in "${lines[@]}"
	do
		#do what with each line
		status=$(ssh -o BatchMode=yes -o ConnectTimeout=15 $line echo ok 2>&1)
		case $status in
			ok) echo "Connected to $line successfully."
				;;
			*"Permission denied"*) echo "Failed to connect to $line."
				;;
			*) echo "$line status: $status."
				;;
		esac			
	done
else
	echo "File passed is invalid or does not exist."
	exit 1
fi
exit 0
