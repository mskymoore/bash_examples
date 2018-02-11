#!/bin/bash


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

