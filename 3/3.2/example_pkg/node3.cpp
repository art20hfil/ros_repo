#include "ros/ros.h"
#include <iostream>
#include <fstream>
#include <sstream>
//#include "string.h"

int main(int argc, char** argv) {
    ros::init(argc, argv, "node3");
    ros::NodeHandle nh;
    int cost;
    std::ifstream fin("/root/out.txt");
    std::stringstream str_fin;
    std::string buf_str;
    std::getline(fin, buf_str);
    str_fin << buf_str;
    fin.close();
    std::ofstream fout("/root/out.txt");
    ros::param::param<int>("~max_size", cost, -7844);
    sleep(0.5);
    fout << str_fin.str() << cost;
    fout.close();
    ros::spinOnce();
    return 0;
}
