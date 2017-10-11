cmake_minimum_required(VERSION 2.8.3)
project(sample_pkg)

find_package(catkin REQUIRED COMPONENTS roscpp)
catkin_package(
)
include_directories(include  ${catkin_INCLUDE_DIRS})
#include_directories("../../devel/include")

add_executable(node2 node2.cpp)
target_link_libraries(node2 ${catkin_LIBRARIES})
