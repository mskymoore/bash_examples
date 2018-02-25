#!/bin/bash

#out=$(command -v nmcli)
if [[ $(command -v NOTACOMMAND) ]];then
	echo "command found"
else
	echo "command not found"
fi



exit 0
