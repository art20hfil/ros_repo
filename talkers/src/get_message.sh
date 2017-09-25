#!/bin/bash

current_dir=$1

mes_file=$(find $current_dir -name *.msg | tr "\n" " ")
mes_file=${mes_file% }
if [[ $mes_file == "" ]] || [ $mes_file == " " ]]; then
	echo -e "Error: messge file is not found in directory"
	echo -e "	$current_dir"
	exit 1
fi
mes_name=${mes_file##*/}
mes_name=${mes_name%.msg}
mes_name=${current_dir##*/}/$mes_name
echo -e "$mes_name" > message.txt
echo -e "message is correct"
