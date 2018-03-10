#!/bin/bash
#get someones name and then print it
printf "Enter your name:"
read name
echo  Your name is: $name
if [ $name == "Sky" ] ;
then printf "Correct user.  All is good.\n"
exit 0;
else printf "INVALID USER! ALERT SECURITY!\n"
exit -1;
fi

