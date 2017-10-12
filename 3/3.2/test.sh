#!/bin/bash
source /opt/ros/kinetic/setup.bash

cd /root/
mkdir -p workspace/src/
cd workspace/src
catkin_init_workspace
cp -a /root/ros_repo/3/3.2/example_pkg/ /root/workspace/src/
cp -a /root/ros_repo/3/3.2/sample_pkg/ /root/workspace/src/
cd /root/workspace
catkin_make -j1 >> /dev/null 2> /root/forerrors.txt
if [[ "$(cat /root/forerrors.txt)" != "" ]]; then
	echo -e "Error: package could not be compiled"
	echo -e "$(cat /root/forerrors.txt)"
        rm -rf /root/ros_repo/ /root/workspace
	exit 1
fi

users_file=$(ls /home/box/*.launch)
if [[ $(users_file) == "" ]]; then
    echo -e "Error: no launch file detected"
    rm -rf /root/ros_repo/ /root/workspace
    exit 1
fi

roslaunch $(users_file) max_size:=1 1>/dev/null 2>/dev/null &
sleep 1
rostopic list >> /root/topics.txt
echo -e "/input_array\n/rosout\n/rosout_agg" >> /root/expected_topics.txt

error_log=$(/root/ros_repo/file_equal.py /root/topics.txt /root/expected_topics.txt "not_equal")
if [[ $error_log != "" ]]; then
    echo -e "Error: node2 is reading from incorrect topic"
    rm -rf /root/ros_repo/ /root/workspace /root/expected_topics.txt /root/topics.txt
    exit 1
fi
if [[ cat /root/out.txt !="11" ]]; then
    echo -e "Error: the parameter(s) was(ere) defined incorrectly"
    rm -rf /root/ros_repo/ /root/workspace /root/expected_topics.txt /root/topics.txt
    exit 1
fi
