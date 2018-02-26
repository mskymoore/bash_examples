#!/bin/bash


# Title:	BulkSCP.sh
# Author:       Sky Moore (mskymoore@gmail.com)
# Summary:      Attempts to log in to ssh servers with username@hostname lines read from input file, and reports to the console the result of the attempt to copy InputFile to RemotePath on each host listed in HostsFile.
#               
# Options:      [-i /file/to/copy to remote host -H /file/to/read/hosts/from -r /remote/path/to/copy/to/][-h print help]
# Exit Codes:   0: successful execution
#               1: help printed or bad arguments
#               2: 
#               3: 

usage() { echo "$0 usage:" && grep ".)\ #" $0; exit 1; }


[ $# -eq 0 ] && usage

while getopts ":hH:i:r:" arg;do
	case $arg in
		H) # Hosts file to read username@hostname lines from
			HostsFile=$(readlink -f ${OPTARG})
			;;
		i) # Input file or directory to copy to remote hosts
			InputFile=$(readlink -f ${OPTARG})
			;;
		r) # Remote directory to copy Input file or directory to on hosts
			RemotePath=${OPTARG}
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
	if [[ -e $InputFile ]];then
		IFS=$'\n' read -d '' -r -a lines < $HostsFile
		for aHost in "${lines[@]}"
		do	
			status=$(ssh -o BatchMode=yes -o ConnectTimeout=15 $aHost echo ok 2>&1)
			case $status in
				ok) 
					echo "Connected to $aHost successfully."
					echo "Checking for $RemotePath on $aHost..."
					if ssh $aHost [[ -e $RemotePath  ]];then	
						# if InputFile is a directory
						if [[ -d $InputFile ]];then
							echo "Transferring directory $InputFile to $aHost:$RemotePath"
							# call scp with -r option for recursively copying directory contents
							scp -r $InputFile $aHost:$RemotePath
							echo "Transfer complete."	
						# elif InputFile is a regular file
						elif [[ -f $InputFile ]];then
							echo "Transferring file $InputFile to $aHost:$RemotePath"
							# call scp with no options
							scp $InputFile $aHost:$RemotePath
							echo "Transfer complete."						
						# else InputFile is something else, this statement should never be reached
						else
							echo "Local path entered is invalid or does not exist."		
							exit 2
						fi
					else
						echo "$RemotePath is invalid, does not exist on $aHost."
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
		echo "$InputFile is invalid or does not exist."
	fi		
else
	echo "$HostsFile is invalid or does not exist."
	exit 1
fi
exit 0
