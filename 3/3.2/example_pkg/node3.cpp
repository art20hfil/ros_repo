#include "ros/ros.h"
#include <iostream>
#include <fstream>
#include <sstream>
//#include "string.h"

int main(int argc, char** argv) {
    ros::init(argc, argv, "node3");
    ros::NodeHandle nh;
    int cost;
    sleep(0.3);
    std::ofstream fout("/root/out.txt", std::ios::app);
    ros::param::param<int>("~max_size", cost, -7844);
    sleep(0.5);
    fout << cost;
    fout.close();
    ros::spinOnce();
    return 0;
}
