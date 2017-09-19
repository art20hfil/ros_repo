#!/bin/bash

# git_dir:=...   - dir where git was cloned
# workspace:=... - workspace dir
# launch:=...    - path to launch file
# topics:=...    - file with topics (for comparison)
# nodes:=...     - file with nodes (for comparison)
# input:=...     - file with input data for nodes
# output:=...    - file with output data from nodes

get() {
	local key=$1
	local out=""
	for arg in $@; do
		if [[ ${arg%%:=*} == $key ]] && 
		   [[ ${arg#*:=}  != ""   ]] && 
		   [[ ${arg#*:=}  != $arg ]]; then
			out=$out"${arg#*:=} "
		fi
	done
	echo -n "${out% }"
}

current_dir=$(get "git_dir" $@)
workspace=$(get "workspace" $@)
launch=$(get "launch" $@)
topics_true=$(get "topics" $@)
nodes_true=$(get "nodes" $@)
input_file=$(get "input" $@)
if [[ $input_file != "" ]]; then
	input_file="< $input_file"
fi
output_file=$(get "output" $@)
if [[ $output_file != "" ]]; then
	output_file="> $output_file"
else
	output_file=/dev/null
fi

cd $workspace
source /opt/ros/kinetic/setup.bash
if [[ $(catkin_make >> /dev/null) != "" ]]; then
	echo -e "Error: package could not be compiled"
fi

source devel/setup.bash
topics=$current_dir/topics.txt
nodes=$current_dir/nodes.txt
roslaunch $launch topics:=$topics nodes:=$nodes $input_file 2>>/dev/null $output_file

cd $current_dir
if [[ $($current_dir/file_equal.py $topics $topics_true "error") == "error" ]]; then
	echo -e "Error: topics list is incorrect"
	echo -e "GOT TOPICS:"
	echo -e "$(cat $topics)"
	echo -e "REQUIRED:"
	echo -e "$(cat $topics_true)"
fi

if [[ $($current_dir/file_equal.py $nodes $nodes_true "error") == "error" ]]; then
	echo -e "Error: nodes list is incorrect"
	echo -e "GOT NODES:"
	echo -e "$(cat $nodes)"
	echo -e "REQUIRED:"
	echo -e "$(cat $nodes_true)"
fi

echo -e "launch is correct"
