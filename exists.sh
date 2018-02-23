#!/bin/bash

if [ $# -eq 0 ];then
        echo "Usage: $0 /some/path/here"
else
	AllegedPath=$(readlink -f $1)
	if [[ -e $AllegedPath  ]];then
		printf "It exists, "
		if [[ -d $AllegedPath  ]];then
			printf "as a directory!\n"
			exit 9
		elif [[ -f $AllegedPath  ]];then
			printf "as a regular file!\n"
			exit 7
		else
			printf "but something went wrong.\n"
			exit 255
		fi
	else
		echo "It doesn't exist!"
		exit 0
	fi
fi
