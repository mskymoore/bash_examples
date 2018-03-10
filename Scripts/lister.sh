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
	#look for the first argument sent to this function as a file
	#in the working directory and direct the output to null
	ls $1 &> /dev/null
	#if the file wasn't found
	if [ $? -ne 0 ]	
	then
		#inform the user
		echo File $1 Not Found!
		echo Creating File $1
		#create the file in the working directory
		touch $1
	#else the file exists
	else
		#inform the user
		echo File $1 Exists!
	fi#endif
}


function putDataInFileIfExists {
	#look for the first argument sent to this function as a file
	#in the working directory and direct the output to null
	ls $1 &> /dev/null
	#if the file was found
        if [ $? -eq 0 ]
        then
		#inform the user and append some text to the file
	        echo File $1 Found! Filling appropriately.
		printf "FileName: " >> $1
                printf $1 >> $1
                printf "\nLocation: " >> $1
                pwd >> $1
                printf "\nLots\nof\nbytes\nin\nhere.\n\n" >> $1
		#print the contents of the file
                cat $1
		#end process with 0 status
                exit 0
	#else file does not exist
        else
		#inform the user
                echo File $1 Not Found!
		#end process with 1 status
                exit 1

        fi#endif	
}


function main {
	#call function makeFileIfNotExists sending in first argument to this function
	makeFileIfNotExists $1
	#if the last process exited with a nonzero status
	if [ $? -ne 0 ]
	then
		#preserve exit code
		theStatus=$?
		#inform the user
		echo Non-zero exit status for touch, do you have write permission to this directory?
		#end process with same exit code
		exit $theStatus
	#else process exited with 0 status
	else	
		#call function putDatainFileIfExists sending in first argument to this function
		putDataInFileIfExists $1
	fi#endif
}

#counter for indexing output of arguments
j=0
#for each argument in the call to this script
for i in $*
        do	
		#print the argument index
                echo Argument $j:
		#add one to the index
                j=$(( j+=1 ))
		#print the argument
                echo $i
		#call main with the argument and push the process to the background
                main $i &
        done
#wait for background processes to complete
wait
#exit with 0 status
exit 0

