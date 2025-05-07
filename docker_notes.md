# Docker Notes

This document provides an overview of Docker concepts, commands, and best practices, particularly for working with ROS (Robot Operating System) images.

---

## What is Docker?

Docker is a platform for developing, shipping, and running applications inside lightweight, portable containers. Containers ensure consistency across environments, making it easier to develop and deploy applications.

---

## Dockerfile Example

Below is an example `Dockerfile` for setting up a ROS-based container:

```Dockerfile
FROM osrf/ros:humble-desktop-full

RUN apt-get update && \
  apt-get install -y --no-install-recommends nano && \
  rm -rf /var/lib/apt/lists/* && \
  apt-get clean

COPY config/ /site_config/

ARG USERNAME=ros
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
  && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
  && mkdir /home/$USERNAME/.config && chown $USER_UID:$USER_GID /home/$USERNAME/.config

USER ros

USER root

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["bin/bash", "entrypoint.sh"]

CMD ["bash"]
```

### Key Notes:
- **ENV**: Used to set environment variables.
- **LABEL**: Used to specify metadata like maintainer and email.
- **ARG**: Allows passing build-time variables.

---

## Entrypoint Script Example

Below is an example `entrypoint.sh` script:

```bash
#!/bin/bash

set -e 

source /opt/ros/jazzy/setup.bash

echo "Provided arguments: $@"

exec $@
```

---

## Important Concepts

- **UID and GID**: 
  - Root user UID is `0`.
  - Default user UID is `1000`.
- **Groups**: Allow multiple users to access shared resources.
- **Inter-Process Communication (IPC)**: Enables shared memory for processes.
- **X Server Access**:
  - Use `xhost +` to grant access to all users.
  - Use `xhost +local:` for local users.
  - Disable access with `xhost -`.
- **Privileged Mode**: Grants the container elevated permissions to access host devices.
- **Device Access**:
  - Use `xxd` to view device file contents (e.g., `sudo xxd /dev/input/mouse1`).
  - Bind mount device files and use `--device-cgroup-rule` for access.
  - Serial device access requires the user to be in the `dialout` group.

---

## Common Docker Commands

### Images
- `docker images` or `docker image ls`: List images.
- `docker image pull <name:tag>`: Pull an image.
- `docker image rm -f <image>`: Forcefully remove an image.

### Containers
- `docker container ls` or `docker ps`: List running containers.
- `docker run -it <image> --name <container_name> --rm --user ros --network=host --ipc=host -v /tmp/.X11-unix:/tmp/.X11-unix:rw --env=DISPLAY --device=/dev/input/js0`: Run a container interactively.
- `docker container stop <container_name>`: Stop a container.
- `docker container start -i <container_name>`: Start a stopped container interactively.
- `docker container rm <container_name>`: Remove a container.
- `docker container prune`: Remove all stopped containers.
- `docker exec -it <container_name> /bin/bash`: Execute a command in a running container.

### System Cleanup
- `docker system prune -a --volumes`: Remove unused data.

### Building Images
- `docker image build -t <image_name> -f <Dockerfile> -v <host_path>:<container_path>`: Build an image.

---

## Best Practices for ROS Containers

1. **Docker Installation**:
   - Use the convenience script method for installation.
   - Complete post-installation steps and ensure Docker is enabled (`systemctl`).

2. **Network and Connectivity**:
   - Ensure local setup without external pulls or curls from the web.
   - Use private registries if privacy is a concern.

3. **ROS Images**:
   - Use `osrf/ros` images for development.
   - Refer to [ijnek's GitHub repository](https://github.com/athackst/dockerfiles) for examples.

4. **Environment Variables**:
   - Use `.env` files to streamline communication between containers.

5. **Container Management**:
   - Avoid running containers as root; use specific users with required access rights.
   - Use `--rm` to automatically remove containers after they stop.
   - Use `docker volumes` for efficient container storage and bind mounts for external access.

6. **Cleanup**:
   - Use `docker system prune` and `docker container prune` to clean up unused resources.

---

## Additional Notes

- **X Server**: Set `--network=host` for host access to the X server.
- **Device Access**: Bind mount `/dev/input` and use appropriate device rules.
- **ROS Sourcing**: Source ROS in `.bashrc` instead of the entrypoint script for better usability.
- **Development vs Production**:
  - Use `FROM <base_image> as Base` for multi-stage builds.
  - Separate development and production configurations.

---

## Future Tasks

- Record and replay a sequence of data from `/dev/input/mouse1`.
- Experiment with device access and permissions.

---

This document serves as a quick reference for Docker usage, particularly for ROS-based development. For more details, refer to the official Docker and ROS documentation.
