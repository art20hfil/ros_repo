#!/bin/bash

predict_file=$1
got_file=$2

if [[ $(cat $got_file | grep "/subscriber: ") != $predict_file ]]; then
	echo -e "Error: subscriber works incorrect"
	echo -e "       the result is:"
	echo -e "$(cat $got_file | grep '/subscriber: ')"
	echo -e "       the predict is:"
	echo -e "$(cat $predict_file)"
	exit 1;
fi
echo -e "success"

