#!/bin/bash

#Author: Sky Moore
#Date: 2/10/2018

# This script accepts many arguments, and in parallel checks to
# see if those argument strings are files in the working directory
# and if they are not they are created and some strings appended
# regardless of their creation time.

# For example executing the following:
# 
# ~$./lister.sh woah1 woah2 woah3 woahBuddy
#
# Will cause the creation of a file titled woah1, woah2, and so on.
# Each file will have some text appended to it, regardless of if it
# existed prior to the execution of the script, or was created by the
# script.

function makeFileIfNotExists {
	ls $1 &> /dev/null
	
	if [ $? -ne 0 ]	
	then
		echo File $1 Not Found!
		echo Creating File $1
		touch $1
	else
		echo File $1 Exists!
	fi
}


function putDataInFileIfExists {
	ls $1 &> /dev/null

        if [ $? -eq 0 ]
        then
	        echo File $1 Found! Filling appropriately.
		printf "FileName: " >> $1
                printf $1 >> $1
                printf "\nLocation: " >> $1
                pwd >> $1
                printf "\nLots\nof\nbytes\nin\nhere.\n\n" >> $1
                cat $1
                exit 0

        else
                echo File $1 Not Found!
                exit 1

        fi	
}


function main {

	makeFileIfNotExists $1

	if [ $? -ne 0 ]

	then
		theStatus=$?
		echo Non-zero exit status for touch, do you have write permission to this directory?
		exit $theStatus

	else
		putDataInFileIfExists $1
	                

	fi
}

j=0
for i in $*
        do
                echo Argument $j:
                j=$(( j+=1 ))
                echo $i
                main $i &
        done
wait
exit 0

