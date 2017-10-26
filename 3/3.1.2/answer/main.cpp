#include "ros/ros.h"
#include "geometry_msgs/Point.h"
#include "visualization_msgs/Marker.h"
#include <vector>
#include <iostream>

using namespace std;
using namespace ros;

Publisher p;
vector<geometry_msgs::Point> set;

void f(const geometry_msgs::Point& pt) {
	static visualization_msgs::Marker m;
	m.ns = "a";
	m.id = 0;
	m.action = visualization_msgs::Marker::ADD;
	m.type = visualization_msgs::Marker::POINTS;
	if (m.points.size() < 5) {
		m.points.push_back(pt);
	}
	if (m.points.size() == 5) {
		p.publish(m);
		m.points.clear();
		return;
	}
	return;
}

int main(int argc, char** argv) {
	init(argc, argv, "middle");
	NodeHandle n;
	p = n.advertise<visualization_msgs::Marker>("/output",10);
	Subscriber s = n.subscribe("/input",10,f);
	spin();
	return 0;
}
