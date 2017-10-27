#include "ros/ros.h"
#include "geometry_msgs/PointStamped.h"
#include "geometry_msgs/Point.h"
#include "tf/transform_listener.h"

using namespace std;
using namespace ros;

Publisher p;

struct A{
	tf::TransformListener* tl;
	A(tf::TransformListener* tl) : tl(tl) {}

	void f(const geometry_msgs::PointStamped& pt) {
		geometry_msgs::PointStamped new_pt;
		tl->transformPoint("core_frame", pt, new_pt);
		geometry_msgs::Point raw_p;
		raw_p = new_pt.point;
		p.publish(raw_p);
	}
};
int main(int argc, char** argv) {
	init(argc, argv, "middle");
	NodeHandle n;
	tf::TransformListener tl;
	A a(&tl);
	p = n.advertise<geometry_msgs::Point>("/output",10);
	sleep(1);
	Subscriber s = n.subscribe("/input",10,&A::f,&a);
	spin();
	return 0;
}
