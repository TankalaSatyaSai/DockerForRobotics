#!/bin/bash

# Get the directory of the current script
SCRIPT_PATH=$(dirname $(realpath "$0"))

# Get the parent directory of the script directory
PARENT_PATH=$(dirname "$SCRIPT_PATH")

# Function to build the Docker image
build_docker_image()
{
    LOG="Building Docker image robot_sim:latest ..."

    print_debug

    # Build the Docker image with no cache
    sudo docker image build -f $SCRIPT_PATH/Dockerfile -t robot_sim:latest $PARENT_PATH --no-cache
}

# Function to create the shared folder if it doesn't exist
create_shared_folder()
{
    if [ ! -d "$HOME/$USER/shared/ros2"]; then
        LOG="Creating $HOME/$USER/shared/ros2 ..."

        print_debug()

        # Create the shared folder
        mkdir -p $HOME/$USER/shared/ros2
    fi        
}

# Function to print debug messages
print_debug()
{
    echo ""
    echo $LOG
    echo ""
}

# Create the shared folder
create_shared_folder

# Build the Docker image
build_docker_image