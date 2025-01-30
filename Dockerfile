ARG ROS_DISTRO="rolling"

FROM ros:${ROS_DISTRO}-ros-base

LABEL maintainer="TankalaSatyaSai<satyasai2004.edu@gmail.com>"

ENV PIP_BREAK_SYSTEM_PACKAGES=1
ENV DEBIAN_FRONTEND=noninteractive

SHELL ["/bin/bash", "-c"]

RUN apt-get update -q && \
    apt-get upgrade -yq && \
    apt-get install -yq --no-install-recommends apt-utils wget curl git build-essential \
    vim sudo lsb-release locales bash-completion tzdata gosu gedit htop nano libserial-dev

RUN apt-get update -q && \
    apt-get install -y gnupg2 iputils-ping usbutils \
    python3-argcomplete python3-colcon-common-extensions python3-networkx python3-pip python3-rosdep python3-vcstool

RUN rosdep update && \
    grep -F "source /opt/ros/${ROS_DISTRO}/setup.bash" /root/.bashrc || echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> /root/.bashrc && \
    grep -F "source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash" /root/.bashrc || echo "source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash" >> /root/.bashrc

RUN apt-get update && \
    apt-get install -y \
    ros-${ROS_DISTRO}-joint-state-publisher-gui \
    ros-${ROS_DISTRO}-xacro \
    ros-${ROS_DISTRO}-demo-nodes-cpp \
    ros-${ROS_DISTRO}-demo-nodes-py \
    ros-${ROS_DISTRO}-rviz2 \
    ros-${ROS_DISTRO}-rqt-reconfigure    

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    DEBIAN_FRONTEND=noninteractive add-apt-repository ppa:kisak/kisak-mesa

RUN mkdir -p /etc/udev/rules.d
    # mkdir -p /root/ros2_ws/src/ur5e # Create the metapkg directory in the Image
    
# COPY . /root/ros2_ws/src/ur5e    # Change the path to your metapkg directory

COPY docker/workspace.sh /root/
COPY docker/entrypoint.sh /root/
COPY docker/bash_aliases.txt /root/.bashrc_aliases

RUN chmod +x /root/workspace.sh /root/entrypoint.sh

RUN cat /root/.bashrc_aliases >> /root/.bashrc

WORKDIR /root
RUN ./workspace.sh

RUN echo "source /root/ros2_ws/install/setup.bash" >> /root/.bashrc

ENTRYPOINT ["/root/entrypoint.sh"]

CMD ["/bin/bash", "-c", "tail -f /dev/null"]
