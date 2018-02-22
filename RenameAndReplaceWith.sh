#!/bin/bash

# Title:	RenameAndReplaceWith.sh
# Author:	Sky Moore (mskymoore@gmail.com)
# Summary:	Takes username hostname path to a file or directory, 
#		renames it, and replaces it with a local file or directory.
# Options:	[-u username][-c hostname][-r remotePath][-l localPath]

usage() { echo "$0 usage:" && grep ".)\ #" $0; exit 0; }

[ $# -eq 0 ] && usage
while getopts ":hu:c:r:l:" arg; do
	case $arg in
		u) # Specify username for ssh connection.
			UserName=${OPTARG}
			$UserName+="@"
			echo "UserName: $UserName"
			;;
		c) # Specify hostname or IP address for ssh connection.
			HostName=${OPTARG}
			echo "HostName: $HostName"
			;;
		r) # Specify path of file to replace and rename on remote machine.
			RemotePath=${OPTARG}
			echo "RemotePath: $RemotePath"
			;;
		l) # Specify the path of the local file to replace the remote one with.
			LocalPath=$(readlink -f ${OPTARG})
			echo "LocalPath: $LocalPath"
			;;
		h | *) # Display this help message.
			exit 0
			;;
	esac
done
#ssh $UserName$HostName ls

validPath=0

if [[ -z $HostName ]] || [[ -z $RemotePath ]] || [[ -z $LocalPath ]];
then
	printf "Insufficient Arguments.\n"
	usage
fi

if [[ ! -f $LocalPath  ]] || [[ ! -d $LocalPath ]];
then
	validPath=1	
fi


if [ $validPath == 1 ]
then
	echo "Valid Path Found"
	ssh $UserName$HostName mv $RemotePath $RemotePath"_OLD"
	if [[ ! -d $LocalPath ]];
	then
		echo "Knows it's a directory"
		scp -r $LocalPath $UserName$HostName:$RemotePath
	elif [[ ! -f $LocalPath ]];
	then
		scp $LocalPath $UserName$HostName:$RemotePath
	else
		#printf "Local directory or file path is invalid.\n"
		exit 2
	fi
else
	echo "Local path entered is invalid or does not exist."
fi

