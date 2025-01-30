#!bin/bash

ROS_DISTRO="rolling"

export XDG_RUNTIME_DIR=/tmp/runtime-$USER
mkdir -p $XDG_RUNTIME_DIR
chmod 700 $XDG_RUNTIME_DIR

ROS_WS="/root/ros2_ws"

ROS2_SHARED="/root/shared/ros2"

ROS_DOMAIN_ID_FILE="$ROS2_SHARED/ros_domain_id.txt"

if [ ! -f "$ROS_DOMAIN_ID_FILE"]; then
    echo "0" >  "$ROS_DOMAIN_ID_FILE"
    echo "Successfully created ROS_DOMAIN_ID_FILE at $ROS_DOMAIN_ID_FILE"
fi

if ! grep -q "export ROS_DOMAIN_ID" /root/.bashrc; then
  ros_domain_id=$(cat "$ROS_DOMAIN_ID_FILE")
  echo "export ROS_DOMAIN_ID=$ros_domain_id" >> /root/.bashrc
fi

export ROS_DOMAIN_ID=$(cat "$ROS_DOMAIN_ID_FILE")

source /opt/ros/$ROS_DISTRO/setup.bash

source $ROS_WS/install/setup.bash

source /root/.bashrc

cd $ROS_WS

colcon build 

cd 

source /root/.bashrc

exec "$@"