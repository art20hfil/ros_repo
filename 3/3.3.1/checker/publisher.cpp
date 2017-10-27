#include "ros/ros.h"
#include "geometry_msgs/PointStamped.h"
#include <string>
#include <fstream>

using namespace ros;
using namespace std;

int main(int argc, char** argv) {
	init(argc, argv, "publisher");
	NodeHandle n;
	Publisher p = n.advertise<geometry_msgs::PointStamped>("/input",10);
	sleep(5);
	string input_file_name;
	param::param<string>("~input_file_name",input_file_name,string("input_points.txt"));
	ifstream fin_points(input_file_name.c_str());
	Rate r(10);
	while(!fin_points.eof()) {
		geometry_msgs::PointStamped pt;
		fin_points >> pt.header.frame_id >> pt.point.x >> pt.point.y >> pt.point.z;
		pt.header.stamp = ros::Time::now();
		if (fin_points.eof())
			break;
		p.publish(pt);
		r.sleep();
	}
	spinOnce();
	sleep(5);
	return 0;
}
