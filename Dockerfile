ARG ROS_DISTRO="jazzy"

################################
# Base Image for UR Simulation #
################################

FROM osrf/ros:${ROS_DISTRO}-desktop AS base

ENV ROS_DISTRO=${ROS_DISTRO}

SHELL ["/bin/bash", "-c"]

RUN mkdir -p /ur_ws/src
WORKDIR /ur_ws/src
COPY dependancies.repos .
RUN vcs import &lt; dependancies.repos

WORKDIR /ur_ws
RUN source /opt/ros/${ROS_DISTRO}/setup.bash \
    && apt-get update -y \
    && rosdep install --from-paths src --ignore src -y \
    && colcon build --symlink-install \
    && rm -rf /var/lib/apt/lists \
    && apt-get clean
    
ENV UR_TYPE=ur5e

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    ros-${ROS_DISTRO}-rmw-cyclonedds-cpp \
    && RMW_IMPLEMENTATION=rmw_cyclonedds_cpp \
    && rm -rf /var/lib/apt/lists \
    && apt-get clean

###################################
# Overlay Image for UR Simulation #
###################################

FROM base AS overlay

RUN mkdir -p overlay_ws/src
WORKDIR /overlay_ws
COPY ./Ur_Pose_Optimisation ./src/ur_optim
RUN source /ur_ws/install/setup.bash \
    && apt-get update -y \
    && rosdep install --from-paths src --ignore src -y \
    && colcon build --symlink-install \
    && rm -rf /var/lib/apt/lists \
    && apt-get clean

COPY ./entrypoint.sh /
ENTRYPOINT [ "/entrypoint.sh" ]

#####################
# Development Image #
#####################

FROM overlay AS dev

ARG USERNAME=devuser
ARG UID=1000
ARG GID=${UID}

RUN apt-get update \
    &amp;&amp; apt-get install -y --no-install-recommends \
    gdb gdbserver nano

RUN groupadd --gid $GID $USERNAME \
    &amp;&amp; useradd --uid ${GID} --gid ${UID} --create-home ${USERNAME} \
    &amp;&amp; echo ${USERNAME} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME} \
    &amp;&amp; chmod 0440 /etc/sudoers.d/${USERNAME} \
    &amp;&amp; mkdir -p /home/${USERNAME} \
    &amp;&amp; chown -R ${UID}:${GID} /home/${USERNAME}
    
RUN chown -R ${UID}:${GID} /overlay_ws/

USER ${USERNAME}
RUN echo "source /entrypoint.sh" >> /home/${USERNAME}/.bashrc