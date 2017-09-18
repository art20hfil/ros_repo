#include "ros/ros.h"
#include <iostream>
#include <string>

// argv[1] - name of topics file
// argv[2] - name of nodes file

using std::string;

int main(int argc, char** argv) {
	ros::init(argc,argv,"logger");
	ros::NodeHandle n;
	ros::spinOnce();
	string topics, nodes;
	if (argc <= 2) {
		topics="topics.txt";
		nodes="nodes.txt";
	}
	else {
		topics=argv[1];
		nodes=argv[2];
	}
	system(string(string("rostopic list > ") + topics).c_str());
	system(string(string("rosnode list > ") + nodes).c_str());
	ros::spinOnce();
}
