#!/bin/bash
source /opt/ros/kinetic/setup.bash
pkg_dir=$(cat /root/packages.txt)
pkg=${pkg_dir##*/}

cd $(cat /root/workspace.txt)
cp /root/ros_repo/3/rviz_lab.py $pkg_dir

catkin_make -j1 >> /dev/null 2> ~/forerrors.txt
if [[ "$(cat ~/forerrors.txt)" != "" ]]; then
	echo -e "Error: package could not be compiled"
	echo -e "$(cat ~/forerrors.txt)"
	exit 1
fi

source $(cat /root/workspace.txt)/devel/setup.bash
roscore 2>/dev/null 1>/dev/null & sleep 1 && rosrun $pkg $(ls $(catkin_find --without-underlays --libexec $pkg)) 2>/dev/null & rosrun $pkg rviz_lab.py 2>/dev/null

/root/ros_repo/file_equal.py /root/answer_file.txt /root/received_file.txt "not_equal"> error_log
if [[ $error_log != "" ]]; then
        echo -e "Error: Your Markers are incorrect"
        echo -e "$(cat ~/received_file.txt | grep error)"
        exit 1
fi