#!/bin/bash

# package:= ...    way to package
# publisher:= ...  name of the publisher node
# subscriber:= ... name of the subscriber node
# mes:= ...        type of message in segnature: <package>/<type>
# topic:= ...      name of the topic

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
publisher=$(get "publisher" $@)
subscriber=$(get "subscriber" $@)
mes=$(get "mes" $@)
mes_package=${mes%/*}
mes_type=${mes#*/}
topic=$(get "topic" $@)
package_way=$(get "package" $@)
package=${package_way##*/}

mkdir -p $package_way/src

echo -e "#include \"ros/ros.h\"
#include \"$mes.h\"


int main(int argc, char** argv) {
	ros::init(argc,argv,\"pub\");
	ros::NodeHandle n;
	ros::Publisher pub = n.advertise<$mes_package::$mes_type>(\"$topic\",1000);
	sleep(1);	
	int a = 20;
	ros::Rate loop(20);
	for (int i = 0; i < a; i++) {
		$mes_package::$mes_type mes;
		pub.publish(mes);
		loop.sleep();
	}
	ros::spinOnce();
	return 0;
}" > $package_way/src/$publisher.cpp

echo -e "#include \"ros/ros.h\"
#include \"$mes.h\"
#include <iostream>

using std::cout;
using std::endl;

void function(const $mes_package::$mes_type& mes) {
	cout << ros::this_node::getName().c_str() << \": got message\" << endl;
}

int main(int argc, char** argv) {
	ros::init(argc,argv,\"sub\");
	ros::NodeHandle n;
	ros::Subscriber pub = n.subscribe(\"$topic\",1000,function);
	ros::spin();
	return 0;
}" > $package_way/src/$subscriber.cpp

echo -e "<?xml version=\"1.0\"?>
<package>
  <name>$package</name>
  <version>0.0.0</version>
  <description>The talkers package</description>
  <maintainer email=\"artem@todo.todo\">artem</maintainer>
  <license>TODO</license>
  <buildtool_depend>catkin</buildtool_depend>
  <build_depend>roscpp</build_depend>
  <run_depend>roscpp</run_depend>
  <build_depend>$mes_package</build_depend>
  <run_depend>$mes_package</run_depend>
  <export>
  </export>
</package>" > $package_way/package.xml

echo -e "cmake_minimum_required(VERSION 2.8.3)
project($package)
find_package(catkin REQUIRED COMPONENTS
  roscpp
  $mes_package
)
catkin_package(
)
include_directories(
  \${catkin_INCLUDE_DIRS}
)
add_executable($publisher src/$publisher.cpp)
target_link_libraries($publisher
  \${catkin_LIBRARIES}
)
add_executable($subscriber src/$subscriber.cpp)
target_link_libraries($subscriber
  \${catkin_LIBRARIES}
)" > $package_way/CMakeLists.txt


echo -e "<launch>
	<node name=\"$publisher""_node\" type=\"$publisher\" pkg=\"$package\" required=\"true\" output=\"screen\"/>
	<node name=\"$subscriber""_node\" type=\"$subscriber\" pkg=\"$package\" required=\"true\" output=\"screen\"/>
	<node name=\"log\" type=\"logger\" pkg=\"logger\" args=\"$(arg topics) $(arg nodes)\" output=\"screen\"/>
</launch>" > $package_way/launch.launch

echo -e "/rosout
/log
/$publisher""_node
/$subscriber""_node" > nodes

echo -e "/rosout
/rosout_agg
/$topic" > topics
