#include "ros/ros.h"
#include "std_msgs/Int32.h"
#include <iostream>

using std::cin;
using std::cout;
using std::endl;

int main(int argc, char** argv) {
	ros::init(argc,argv,"node");
	ros::NodeHandle n;
	ros::Publisher pub = n.advertise<std_msgs::Int32>("/topic",1000);
	sleep(1);	
	int a = 0;
	ros::Rate loop(20);
	while (cin >> a) {
		std_msgs::Int32 mes;
		mes.data = a;
		pub.publish(mes);
		loop.sleep();
	}
	ros::spinOnce();
	return 0;
}
