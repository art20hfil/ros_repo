#include "ros/ros.h"
#include "std_msgs/Int32.h"
#include <iostream>

using std::cin;
using std::cout;
using std::endl;

void function(const std_msgs::Int32 mes) {
	cout << ros::this_node::getName().c_str() << ": data: " << mes.data << endl;
}

int main(int argc, char** argv) {
	ros::init(argc,argv,"node");
	ros::NodeHandle n;
	ros::Subscriber pub = n.subscribe("/topic",1000,function);
	ros::spin();
	return 0;
}
