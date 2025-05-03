#!/bin/bash

source /opt/ros/${ROS_DISTRO}/setup.bash

if [ -f /ur_ws/install/setup.bash ]
then
  source /ur_ws/install/setup.bash
  export UR_TYPE=waffle_pi
  export GAZEBO_MODEL_PATH=$GAZEBO_MODEL_PATH:$(ros2 pkg prefix ur_gazebo)/share/ur_gazebo/models
fi

if [ -f /overlay_ws/install/setup.bash ]
then
  source /overlay_ws/install/setup.bash
  export GAZEBO_MODEL_PATH=$GAZEBO_MODEL_PATH:$(ros2 pkg prefix ur_worlds)/share/ur_worlds/models
fi

exec "$@"