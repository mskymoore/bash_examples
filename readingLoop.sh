#!/bin/bash

# Some output to the user
printf "Enter desired number of loops: "
printf "\n"

# read number of loops desired by user
read loopNums 

# did the user give us a number
[ $loopNums -ne $loopNums ] &> /dev/null

# while loopNums is not a number and the previous expression returns 2
while [ $? -eq 2 ]
do
	# inform the user of their error
	printf "Please enter a number or Ctrl+c to exit: "
	# read number again
	read loopNums
	# perform evaluation execution
	[ $loopNums -ne $loopNums ] &> /dev/null
done

# if the number entered was 0
if [ $loopNums -eq 0 ]
then
	# inform the user
	printf "Zero loops desired.\n"
	# quit
	exit 0
fi # endif

# loop execution begins, if desired
printf "Enter some words:\n\t"

# index of loops completed
j=0

# while user inputs data and doesnt ctrl+c the prompt
while read arg1 arg2 arg3 arg4 arg5 argRest
do
	# repeat what the user entered back to them
	echo You Entered: $arg1 $arg2 $arg3 $arg4 $arg5 $argRest	
	# increment index
	j=$(( j+=1 ))
	# if index equals desired loops number
	if [ $j -eq $loopNums ]
	then
		#inform the user
		printf "Loop exit condition reached.\n"
		#exit the loop
		break
	else
		#print prompt for next loop
		printf "Enter some words:\n\t"
	fi

done

exit 0
