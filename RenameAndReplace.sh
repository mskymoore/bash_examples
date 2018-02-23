#!/bin/bash

# Title:	RenameAndReplaceWith.sh
# Author:	Sky Moore (mskymoore@gmail.com)
# Summary:	Takes username hostname path to a file or directory, 
#		renames it, and replaces it with a local file or directory.
# Options:	[-u username][-c hostname][-r remotePath][-l localPath]
# Exit Codes:   0: Successful Execution
#		1:
#		2: Local Directory or file path is invalid
#		3: Insufficient or no arguments


# Usage function displays name of script called, then searches the script for
# any character followed by, ") #" which prints the comments next to the cases
# for handling cmd line arguments and then exits.
usage() { echo "$0 usage:" && grep ".)\ #" $0; exit 3; }

# if there are no arguments sent to this script, call usage function
[ $# -eq 0 ] && usage
while getopts ":hu:c:r:l:" arg; do
	case $arg in
		u) # Specify username for ssh connection.
			UserName=${OPTARG}
			# Concatenate @ symbol to username if one was sent in
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
			# Expand symlinks to full path
			LocalPath=$(readlink -f ${OPTARG})
			echo "LocalPath: $LocalPath"
			;;
		h | *) # Display this help message.
			exit 3
			;;
	esac
done

# if HostName, RemotePath, or LocalPath are unassigned or empty strings
if [[ -z $HostName ]] || [[ -z $RemotePath ]] || [[ -z $LocalPath ]];
then
	printf "Insufficient Arguments.\n"
	usage
fi

# boolean for signaling status of LocalPath
validPath=0

# if LocalPath is a file or a directory
if $([[ -f $LocalPath  ]] || [[ -d $LocalPath ]]);
then
	validPath=1
# else it's invalid or doesn't exist
else
	echo "Local path entered is invalid or does not exist."
	exit 2	
fi

# if a valid path was sent in
if [[ $validPath == 1 ]]
then
	echo "Local path is valid."
	echo "Renaming $UserName$HostName:$RemotePath" " to " $RemotePath"_OLD"
	# Rename the file to replace on the remote host
	ssh $UserName$HostName mv $RemotePath $RemotePath"_OLD"
	# if LocalPath is a directory
	if [[ -d $LocalPath ]];then
		echo "Transferring directory $LocalPath to $UserName$HostName:$RemotePath"
		# call scp with -r option for recursively copying directory contents
		scp -r $LocalPath $UserName$HostName:$RemotePath
	# elif LocalPath is a regular file
	elif [[ -f $LocalPath ]];then
		echo "Transferring file $LocalPath to $UserName$HostName:$RemotePath"
		# call scp with no options
		scp $LocalPath $UserName$HostName:$RemotePath
	# else LocalPath is something else, this statement should never be reached
	else
		printf "Local directory or file path is invalid.\n"
		exit 2

	fi
# else a valid path was not found, this statement should never be reached.
else
	echo "Local path entered is invalid or does not exist."
	exit 2
fi

