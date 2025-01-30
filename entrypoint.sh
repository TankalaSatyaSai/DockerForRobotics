#!/bin/bash

# Set the ROS distribution to use
ROS_DISTRO="rolling" # Change this to the distro you want 

# Set up the runtime directory for the user
export XDG_RUNTIME_DIR=/tmp/runtime-$USER
mkdir -p $XDG_RUNTIME_DIR
chmod 700 $XDG_RUNTIME_DIR

# Define the ROS workspace and shared directory paths
ROS_WS="/root/ros2_ws"
ROS2_SHARED="/root/shared/ros2"

# Define the path to the ROS domain ID file
ROS_DOMAIN_ID_FILE="$ROS2_SHARED/ros_domain_id.txt"

# Create the ROS domain ID file with a default value of 0 if it doesn't exist
if [ ! -f "$ROS_DOMAIN_ID_FILE" ]; then
  echo "0" > "$ROS_DOMAIN_ID_FILE"
  echo "Created ROS domain ID file with default value 0"
fi

# Check if the ROS_DOMAIN_ID export command is already in .bashrc, if not, add it
if ! grep -q "export ROS_DOMAIN_ID" /root/.bashrc; then
  ros_domain_id=$(cat "$ROS_DOMAIN_ID_FILE")
  echo "export ROS_DOMAIN_ID=$ros_domain_id" >> /root/.bashrc
fi

# Export the ROS_DOMAIN_ID environment variable
export ROS_DOMAIN_ID=$(cat "$ROS_DOMAIN_ID_FILE")

# Source the ROS setup script
source /opt/ros/${ROS_DISTRO}/setup.bash

# Source the ROS workspace setup script
source $ROS_WS/install/setup.bash

# Source the .bashrc file to apply any changes
source /root/.bashrc

# Change directory to the ROS workspace
cd $ROS_WS

# Build the ROS workspace using colcon
colcon build 

# Source the .bashrc file again to apply any changes made by the build
source /root/.bashrc

# Execute the command passed as arguments to this script
exec "$@"