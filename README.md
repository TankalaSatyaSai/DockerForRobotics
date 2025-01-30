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

