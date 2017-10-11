cmake_minimum_required(VERSION 2.8.3)
project(example_pkg)

find_package(catkin REQUIRED COMPONENTS roscpp)
catkin_package(
)
include_directories(include  ${catkin_INCLUDE_DIRS})
#include_directories("../../devel/include")

add_executable(node1 node1.cpp)
add_executable(node3 node3.cpp)
target_link_libraries(node1 ${catkin_LIBRARIES})
target_link_libraries(node3 ${catkin_LIBRARIES})