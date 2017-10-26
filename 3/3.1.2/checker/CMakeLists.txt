cmake_minimum_required(VERSION 2.8.3)
project(checker)

find_package(catkin REQUIRED COMPONENTS
  roscpp
  geometry_msgs
  visualization_msgs
)

catkin_package()

include_directories(
  ${catkin_INCLUDE_DIRS}
)

add_executable(point_publisher publisher.cpp)
add_executable(marker_subscriber subscriber.cpp)
target_link_libraries(point_publisher ${catkin_LIBRARIES})
target_link_libraries(marker_subscriber ${catkin_LIBRARIES})
