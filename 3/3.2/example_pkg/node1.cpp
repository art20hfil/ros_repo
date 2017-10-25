#include "ros/ros.h"
#include <iostream>
#include <fstream>

int main(int argc, char** argv) {
    ros::init(argc, argv, "node1");
    ros::NodeHandle nh;
    int cost;
    ros::param::param<int>("~cost", cost, -7844);
    std::ofstream fout("/root/out.txt");
    fout << (cost==-7844?0:1);
    fout.close();
    ros::spinOnce();
    sleep(3);
    ros::spinOnce();
    return 0;
}
