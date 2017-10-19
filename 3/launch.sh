#!/bin/bash
source /opt/ros/kinetic/setup.bash
pkg_dir=$(cat /root/packages.txt)
pkg_dir=${pkg_dir% }
pkg=${pkg_dir##*/}

cd $(cat /root/workspace.txt)
cp /root/ros_repo/3/rviz_lab.py $pkg_dir

catkin_make -j1 >> /dev/null 2> /root/forerrors.txt
if [[ "$(cat /root/forerrors.txt)" != "" ]]; then
	echo -e "Error: package could not be compiled"
	echo -e "$(cat /root/forerrors.txt)"
        rm -rf $(cat /root/workspace.txt)/build/ $(cat /root/workspace.txt)/devel/ /root/ros_repo/ $pkg_dir/rviz_lab.py
	exit 1
fi

source $(cat /root/workspace.txt)/devel/setup.bash
roscore 2>/dev/null 1>/dev/null & sleep 1 && rosrun $pkg $(ls $(catkin_find --without-underlays --libexec $pkg)) 2>/dev/null 1>/dev/null & rosrun $pkg rviz_lab.py 2>/dev/null 1>/dev/null

if [[ $(cat ~/received_file.txt) == "" ]]; then
        echo -e "Topic /output is empty or messages cannot be recognized"
        rm -rf $(cat /root/workspace.txt)/build/ $(cat /root/workspace.txt)/devel/ /root/ros_repo/ $pkg_dir/rviz_lab.py
        exit 1
fi

error_log=$(/root/ros_repo/file_equal.py /root/answer_file.txt /root/received_file.txt "not_equal")

if [[ $error_log != "" ]] && [[ $(cat ~/received_file.txt | grep error) == "" ]]; then
        echo -e "Error: Your Markers are incorrect"
        echo -e "Test data:"
        echo -e "$(cat ~/answer_file.txt)"
        echo -e "You provide data:"
        echo -e "$(cat ~/received_file.txt)"
        rm -rf $(cat /root/workspace.txt)/build/ $(cat /root/workspace.txt)/devel/ /root/ros_repo/ $pkg_dir/rviz_lab.py
        exit 1
fi

if [[ $error_log != "" ]]; then
        echo -e "Error: Your Markers are incorrect"
        echo -e "$(cat ~/received_file.txt | grep error)"
        rm -rf $(cat /root/workspace.txt)/build/ $(cat /root/workspace.txt)/devel/ /root/ros_repo/ $pkg_dir/rviz_lab.py
        exit 1
fi