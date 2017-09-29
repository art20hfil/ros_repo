#include "ros/ros.h"
#include "service/Concat.h"
#include <string>
using std::string;

bool concat(service::Concat::Request&  input,
            service::Concat::Response& output) {
	output.out = input.s1+input.s2;
}

int main(int argc, char** argv) {
	ros::init(argc,argv,"server");
	ros::NodeHandle n;
	string s(ros::this_node::getName()+string("/conc"));
	ros::ServiceServer serv = n.advertiseService(s.c_str(), concat);
	ros::spin();
	return 0;
}
