#!/bin/bash
echo "source /opt/ros/kinetic/setup.bash" >> .bashrc
length() {
	echo "$#"
}

current_dir=$1

#find catkin_workspace folder in the requested directory
dirs=$(find $current_dir -maxdepth 1 -mindepth 1 -type d -name "[^.]*" | tr '\n' ' ')
dirs=${dirs% }
if [[ "$dirs" == "" ]]; then
	(>&2 echo -e "Error: no catkin_workspace directory in the local workspace folder")
	exit 1
fi

if [ "$(length $dirs)" -gt "1" ]; then
	(>&2 echo -e "Error: many ($(length $dirs)) workspace directories were found: $dirs")
	exit 1
fi
workspace=$dirs

#find src folder in the worspace folder
dirs=$(find $workspace -maxdepth 1 -mindepth 1 -type d -name "[^.]*" | tr '\n' ' ')
dirs=${dirs% }
if [[ "$(echo $dirs | grep src)" == "" ]]; then
	(>&2 echo -e "Error: no src folder in the workspace ($workspace)")
	(>&2 echo -e "       found dirs: ($dirs)")
	exit 1
fi
src=$workspace"/src"

#find CMakeLists.txt file
all=$(find $src -maxdepth 1 -mindepth 1 -name "[^.]*" | tr '\n' ' ')
if [[ "$(echo $all | grep CMakeLists.txt)" == "" ]]; then
	(>&2 echo -e "Error: no CMakeLists.txt file in the src folder ($src)")
	exit 1
fi
link=$(readlink $src/CMakeLists.txt)

#make sure that set link is correct
if [[ "$link" != "/opt/ros/kinetic/share/catkin/cmake/toplevel.cmake" ]]; then
	(>&2 echo -e "Error: CMakelists.txt link is not correct")
	(>&2 echo -e "       current link: $link")
	(>&2 echo -e "       request link: /opt/ros/kinetic/share/catkin/cmake/toplevel.cmake")
	exit 1
fi
echo -e "$workspace $(find $src -maxdepth 1 -mindepth 1 -type d -name '[^.]*' | tr '\n' ' ')" > packages.txt
echo -e "workspace was created succesfully"
exit 0
