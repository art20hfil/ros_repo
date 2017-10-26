#include "ros/ros.h"
#include "geometry_msgs/Point.h"
#include <string>
#include <fstream>

using namespace std;
using namespace ros;

int main(int argc, char** argv) {
	init(argc, argv, "point_publisher");
	NodeHandle n;
	Publisher p = n.advertise<geometry_msgs::Point>("/input",10);
	sleep(5);
	string input_file_name;
	param::param<string>("~input_file_name",input_file_name,string("input_points.txt"));
	ifstream fin_points(input_file_name.c_str());
	Rate r(10);
	while(!fin_points.eof()) {
		geometry_msgs::Point pt;
		fin_points >> pt.x >> pt.y >> pt.z;
		if (fin_points.eof())
			break;
		p.publish(pt);
		r.sleep();
	}
	spinOnce();
	sleep(5);
	return 0;
}
