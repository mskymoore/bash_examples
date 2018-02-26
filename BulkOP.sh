#!/bin/bash


# Title:	BulkOP.sh
# Author:       Sky Moore (mskymoore@gmail.com)
# Summary:      Attempts to log in to ssh servers with username@hostname lines read from input file, and reports to the console the result of the attempt to execute OP.
#               
# Options:      [-H /file/to/read/from -o OP]
# Exit Codes:   0: successful execution
#               1: help printed or bad arguments
#               2: 
#               3: 

usage() { echo "$0 usage:" && grep ".)\ #" $0; exit 1; }


[ $# -eq 0 ] && usage

while getopts ":hH:o:" arg;do
	case $arg in
		H) # Hosts file to read username@hostname lines from
			HostsFile=$(readlink -f ${OPTARG})
			;;
		o) # Operation to perform in bulk on remote hosts
			OP=${OPTARG}
			;;
		#p)## Request a password to log in to all username@hostname with
		#	read -s -p "Password: " Password	
		#	;;
		h | *) # Display this help message
			usage
			;;
	esac
done

if [[ -z $HostsFile ]];then
	echo "You must supply an input file."
	usage
fi

if [[ -e $HostsFile ]];then		
	IFS=$'\n' read -d '' -r -a lines < $HostsFile
	for aHost in "${lines[@]}"
	do
		status=$(ssh -o BatchMode=yes -o ConnectTimeout=15 $aHost echo ok 2>&1)
		case $status in
			ok) 
				echo "Connected to $aHost successfully."
				echo "Attempting to execute $OP on $aHost"
				if ssh -o ConnectTimeout=10 $aHost $OP;then
					echo "Success!"
				else
					echo "Failure."
				fi	
			;;
			*"Permission denied"*) 
				echo "Failed to connect to $aHost."
			;;
			*) 
				echo "$aHost status: $status."
			;;
		esac
					
	done	
else
	echo "$HostsFile is invalid or does not exist."
	exit 1
fi
exit 0
