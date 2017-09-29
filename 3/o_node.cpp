#include "ros/ros.h"
#include "geometry_msgs/Point.h"
#include "visualization_msgs/Marker.h"

ros::Publisher pub;
int id = 0;

void my_callback(const geometry_msgs::Point& msg) {
  visualization_msgs::Marker out_msg;
  out_msg.id = id++;
  out_msg.type = 1;
  out_msg.pose.position.x = msg.x;
  out_msg.pose.position.y = msg.y;
  out_msg.pose.position.z = msg.z;
  pub.publish(out_msg);
}

int main(int argc, char** argv) {
  ros::init(argc, argv, "a");
  ros::NodeHandle nh;
  ros::Subscriber sub = nh.subscribe("/input", 1000, my_callback);
  pub = nh.advertise<visualization_msgs::Marker>("/output",100);
  ros::spin();
  return 0;
}
