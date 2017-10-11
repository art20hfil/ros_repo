#include "ros/ros.h"
#include "geometry_msgs/Twist.h"
#include <iostream>
#include <fstream>

void callback(const geometry_msgs::Twist& incoming) {
    //std::cout << "2:" << incoming.linear.x << std::endl;
}

int main(int argc, char** argv) {
    ros::init(argc, argv, "node1");
    ros::NodeHandle nh;
    ros::Subscriber sub = nh.subscribe("input_aray", 10, callback);
    ros::spin();
    return 0;
}
