#!/bin/bash

# git_dir:=...   - dir where git was cloned
# workspace:=... - workspace dir
# launch:=...    - path to launch file
# topics:=...    - file with topics (for comparison)
# nodes:=...     - file with nodes (for comparison)

get() {
	local key=$1
	for arg in $@; do
		if [[ ${arg%%:=*} == $key ]] && 
		   [[ ${arg#*:=}  != ""   ]] && 
		   [[ ${arg#*:=}  != $arg ]]; then
			echo -n "${arg#*:=} "
		fi
	done
}

current_dir=$(get "git_dir" $@)
workspace=$(get "workspace" $@)
launch=$(get "launch" $@)
topics_true=$(get "topics" $@)
nodes_true=$(get "nodes" $@)

cd $workspace
workspace=${workspace% }
source /opt/ros/kinetic/setup.bash
if [[ $(catkin_make >> /dev/null) != "" ]]; then
	echo -e "Error: package could not be compiled"
fi

source devel/setup.bash
topics=$workspace/src/logger/topics.txt
nodes=$workspace/src/logger/nodes.txt
roslaunch $launch topics:=$workspace/src/logger/topics.txt nodes:=$workspace/src/logger/nodes.txt >> /dev/null 2>>/dev/null

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
