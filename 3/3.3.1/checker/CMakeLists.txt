cmake_minimum_required(VERSION 2.8.3)
project(checker)
find_package(catkin REQUIRED COMPONENTS
  roscpp
  tf
  geometry_msgs
)
catkin_package()
include_directories(${catkin_INCLUDE_DIRS})

add_executable(publisher publisher.cpp)
add_executable(subscriber subscriber.cpp)

target_link_libraries(publisher ${catkin_LIBRARIES})
target_link_libraries(subscriber ${catkin_LIBRARIES})
