#!/bin/bash
workspace=$(cat workspace.txt)
package=$workspace/src/client
service_packages=$(cat packages.txt)
for cur_service_package in $service_packages; do
	try_to_find_service=$(find $cur_service_package -name "*.srv")
	if [[ "$try_to_find_service" != "" ]]; then
		service_file=$try_to_find_service
		service_package=$cur_service_package
		service_package_name=${service_package##*/}
		service_type=${service_file##*/}
		service_type=${service_type%.srv}
	fi
done
mkdir -p $package
echo -e "<?xml version=\"1.0\"?>
<package>
  <name>client</name>
  <version>0.0.0</version>
  <description>The service package</description>
  <maintainer email=\"artem@todo.todo\">artem</maintainer>
  <license>TODO</license>
  <buildtool_depend>catkin</buildtool_depend>
  <build_depend>roscpp</build_depend>
  <build_depend>$service_package_name</build_depend>
  <run_depend>$service_package_name</run_depend>
  <run_depend>roscpp</run_depend>
  <export>
  </export>
</package>" > $package/package.xml
echo -e "cmake_minimum_required(VERSION 2.8.3)
project(client)
find_package(catkin REQUIRED COMPONENTS
  roscpp
  $service_package_name
)
catkin_package(
  CATKIN_DEPENDS roscpp $service_package_name
)
include_directories(
# include
  \${catkin_INCLUDE_DIRS}
)
add_executable(client client.cpp)
add_dependencies(client $service_package_name""_generate_messages_cpp)
target_link_libraries(client
  \${catkin_LIBRARIES}
)" > $package/CMakeLists.txt


echo -e "#include \"ros/ros.h\"
#include \"$service_package_name/$service_type.h\"
#include <string>
#include <fstream>
#include <iostream>

using std::string;
using std::ifstream;
using std::cout;
using std::endl;

int test(ros::ServiceClient& clnt, string s1, string s2) {
	$service_package_name::$service_type test;
	test.request.s1 = s1;
	test.request.s2 = s2;
	if (clnt.call(test)) {
		if (test.response.out != s1+s2) {
			cout << \"Error: request s1=\" << test.request.s1.c_str() 
                             << \" s2=\" << test.request.s1.c_str() << endl
			     << \"	response out=\" << test.response.out.c_str() << endl;
			return 1;
		}
	}
	else {
		cout << \"Error: could not call service.\";
		return 1;
	}
	return 0;
}

int main(int argc, char** argv) {
	ros::init(argc, argv, \"client\");
	ros::NodeHandle n;
	sleep(5);
	system(\"rosservice list | grep /meow > services.txt\");
	ifstream services(\"services.txt\");
	string service_line(\"\");

	do {
		getline(services, service_line);
		cout << service_line.c_str() << endl;
	} while ((service_line == string(\"/meow/get_loggers\") ||
	         service_line == string(\"/meow/set_logger_level\")) && !services.eof());

	ros::ServiceClient clnt = n.serviceClient<$service_package_name::$service_type>(service_line.c_str());
	
	if (test(clnt, \"\",\"\")) {return 1;}
	if (test(clnt, \"\",\"2\")) {return 1;}
	if (test(clnt, \"2\",\"\")) {return 1;}
	if (test(clnt, \"111\",\"222\")) {return 1;}
	if (test(clnt, \"qqq\", \" \")) {return 1;}
	ros::spinOnce();
	cout << \"success tests\";
}" > $package/client.cpp

node_server_type=$(cat $service_package/CMakeLists.txt | grep target_link_libraries | tr "\n" " ")
node_server_type=${node_server_type#*(}
node_server_type=${node_server_type%% *}

echo -e "<launch>
	<node pkg=\"$service_package_name\" type=\"$node_server_type\" name=\"meow\" />
	<node pkg=\"client\" type=\"client\" name=\"gav\" required=\"true\" output=\"screen\"/>
	<node pkg=\"logger\" type=\"logger\" name=\"log\" args=\"\$(arg topics) \$(arg nodes)\"/>
</launch>" > $package/launch.launch


