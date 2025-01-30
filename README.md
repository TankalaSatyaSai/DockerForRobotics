# DockerForRobotics

## Intial Setup 
* Remove the outdated versions of Docker from your system: 
```bash
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
```

* I suggest you install docker using the convinence script method mentioned in the official docker installation instructions [Page](https://docs.docker.com/engine/install/ubuntu/#install-using-the-convenience-script).

* Verify the Installation using: 
```bash
sudo docker run hello-world
```

* Post-Installation Configuration: 
```bash
sudo groupadd docker
sudo usermod -aG docker $USER
sudo reboot
```

* To test that you can run Docker without using “sudo”, type the following command: 
```bash
docker run hello-world
```

* To enable docker to start on boot: 
```bash
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
```

* If you're using a already docker configured system then check the following: 
```bash
docker info -f '{{ .DockerRootDir}}'
```

* If your docker root is not configured to the docker root directory then change it. You can follow this [Page](https://www.ibm.com/docs/en/z-logdata-analytics/5.1.0?topic=software-relocating-docker-root-directory)   

## Setting up docker for your project

* Clone this repo into your main project folder (The metapkg directory): 
```bash
cd ~/ros2_ws/src/{yourMetaPkgDir}/ 
git clone -b main https://github.com/TankalaSatyaSai/DockerForRobotics.git 
mv -r DockerForRobotics docker 
```

* Create your own docker image:
```bash
cd ./docker
bash image_build.sh
# This will might take sometime,depending on your system speed. 
```

* Check the image, if its created succesfully: 
```bash
docker images | grep {YourImageName}
# By default I've named it robot_sim
```

* After the image is created to run the services in docker compose:
```bash
docker-compose up 
```
* If you want to run only a specific service:
```bash
docker compose up -d robot_sim
```
* To enter into a specific container: 
```bash
docker compose exec robot_sim bash
```
  
## Post Commands

* Provide the control access to the X server, which is responsible for handling graphical displays on linux. You could do this by: 
```bash
# run this in your host shell
xhost +local:root 
#or 
xhost +
```

## Commands to be noted

* To remove all unused Docker resources (images, containers, networks, and volumes), type:
```bash
docker system prune
```
* If at any stage you want to remove the image you just created, type:
```bash
docker rmi manipulation:latest
```
* To remove unused images, you would type:
```bash
docker image prune
```
* To remove all images, you would do this:
```bash
docker image prune -a
```
* You can also free up space on your computer using this command (I run this command regularly):
```bash
docker system prune
```
* To inspect an image’s details:
```bash
docker image inspect manipulation:latest
```
* To view the history of an image’s layers:
```bash
docker history manipulation:latest
```
* To save an image as an archive:
```bash
docker save manipulation:latest > manipulation.tar
```
* To load an image from a tar archive:
```bash
docker load < manipulation.tar
```