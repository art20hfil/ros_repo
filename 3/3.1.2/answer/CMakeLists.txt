cmake_minimum_required(VERSION 2.8.3)
project(answer)

find_package(catkin REQUIRED COMPONENTS
  roscpp
  geometry_msgs
  visualization_msgs
)

catkin_package()

include_directories(
  ${catkin_INCLUDE_DIRS}
)

add_executable(answer main.cpp)
target_link_libraries(answer ${catkin_LIBRARIES})
