#include "ros/ros.h"
#include "std_msgs/Int32.h"
#include <iostream>

bool active = false;

using std::cin;
using std::cout;
using std::endl;

void function(const std_msgs::Int32 mes) {
	active = true;
	cout << ros::this_node::getName().c_str() << ": data: " << mes.data << endl;
}

int main(int argc, char** argv) {
	ros::init(argc,argv,"node");
	ros::NodeHandle n;
	ros::Subscriber pub = n.subscribe("/topic",1000,function);
	int max_iters = 20;
	for (int i = 0; i < 20; i++) {
		if (active) {
			ros::spin();
			return 0;
		}
		sleep(1);
	}
	return 0;
}
