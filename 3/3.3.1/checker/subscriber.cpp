#include "ros/ros.h"
#include "geometry_msgs/Point.h"
#include <fstream>
#include <string>
#include <cmath>

using namespace ros;
using namespace std;

ofstream fout_points;

void f(const geometry_msgs::Point& pt) {
	fout_points << "(" << round(pt.x*1000)/1000.0 << ", " 
	            << round(pt.y*1000)/1000.0 << ", " 
	            << round(pt.z*1000)/1000.0 << ")" << endl;
	return;
}

int main(int argc, char** argv) {
	init(argc, argv, "subscriber");
	NodeHandle n;
	string output_file_name;
	param::param<string>("~output_file_name",output_file_name,"output.txt");
	fout_points.open(output_file_name.c_str());
	Subscriber s = n.subscribe("/output",10,f);
	spin();
	return 0;
}
