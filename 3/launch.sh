#!/bin/bash
source /opt/ros/kinetic/setup.bash
cd /root
git clone git@github.com:art20hfil/ros_repo.git
pkg_dir=$(cat /root/packages.txt)
pkg=${pkg_dir##*/}

cd $(cat /root/workspace.txt)
cp /root/ros_repo/3/rviz.py $pkg_dir

catkin_make -j1 >> /dev/null 2> ~/forerrors.txt
if [[ "$(cat ~/forerrors.txt)" != "" ]]; then
	echo -e "Error: package could not be compiled"
	echo -e "$(cat ~/forerrors.txt)"
	exit 1
fi

source $(cat /root/workspace.txt)/devel/setup.bash
roscore 2>/dev/null 1>/dev/null & rosrun $pkg $(ls $(catkin_find --without-underlays --libexec $pkg)) & rosrun $pkg rviz_lab.py &
