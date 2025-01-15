curl https://download.docker.com/linux/centos/docker-ce.repo -o /etc/yum.repos.d/docker-ce.repo 
sed -i -e "s/enabled=1/enabled=0/g" /etc/yum.repos.d/docker-ce.repo 
ls
sed -i -e "s/enabled=1/enabled=0/g" /etc/yum.repos.d/docker-ce.repo
yum --enablerepo=docker-ce-stable -y install docker-ce
systemctl enable --now docker
systemctl status docker
docker images
docker version
docker search ubuntu
mkdir containers
cd containers/
ls
cd home
mkdir IMAPP24
cd IMAPP24/
nano test.sj
cp test.sj test.sh
rm test.sj 
ls
docker run ubuntu test.sh 
docker run ubuntu ./test.sh 
clear
FROM ubuntu:latest 
docker run -it ubuntu bash
docker ps
docker run -it ubuntu bash
docker ps
docker commit d65b3c0d5377 build_docker
git
docker run build_docker bash
docker run -it build_docker bash
ls
docker run -it build_docker bash
docker run -it v /. build_docker bash
mkdir test
ls
./test.sh
cd..
 cd ..
cd IMAPP24/
#######################################
####### INSTALL DOCKER on CENTOS8
#######################################
# add port 8080 to firewall on google cloud dashboard. "default-allow-http"
# become superuser
sudo su -
# installing useful tools
yum -y install nano wget curl git
yum install --enablerepo=powertools elinks -y
# download the examples from github
git clone https://github.com/chierici/IMAPP_2024.git
# install the docker repo
curl https://download.docker.com/linux/centos/docker-ce.repo -o /etc/yum.repos.d/docker-ce.repo 
sed -i -e "s/enabled=1/enabled=0/g" /etc/yum.repos.d/docker-ce.repo 
# install docker
yum --enablerepo=docker-ce-stable -y install docker-ce 
# start docker
systemctl enable --now docker
systemctl status docker
#######################
#### start using docker
#######################
docker --version
docker version # more details
docker search ubuntu
docker pull ubuntu
docker run ubuntu echo "hello from the container"
docker run -i -t  ubuntu /bin/bash
#### now you are in a shell running inside the container, remeber to exit to go back in the host shell: type exit or Ctrl+D
docker images
time docker run ubuntu echo "hello from the container"
docker run ubuntu ping www.google.com # something unexpected?
docker run ubuntu /bin/bash -c "apt update; apt -y install iputils-ping"
docker run ubuntu ping www.google.com # still something?
docker run ubuntu /bin/bash -c "apt update; apt -y install iputils-ping; ping -c 5 www.google.com"
docker ps
docker ps -a 
docker images
docker commit <get the container ID using docker ps -a> ubuntu_with_ping
docker images
docker run ubuntu_with_ping ping -c 5 www.google.com
docker system df
docker system prune
docker images
docker ps -a
############################################
# Interacting with docker-hub
docker login
docker images
docker tag 5c2538cecdc2 ataruz/imap_2023:ubuntu_with_ping_1.0
docker push ataruz/imap_2023:ubuntu_with_ping_1.0
############################################
# Bulding docker images using Dockerfiles
mkdir -p containers/simple
cd IMAPP_2023/Containers/
cp Dockerfile index.html ~/containers/simple/
cd ~/containers/simple/
# Dockerfile should be like this
# cat Dockerfile
FROM ubuntu
RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y apache2
ENV DEBIAN_FRONTEND=noninteractive
COPY index.html /var/www/html/
EXPOSE 80
CMD ["apachectl", "-D", "FOREGROUND"]
# index.html file should be like this
# cat index.html
<html>
This is an exercise for the IMAPP course.
</html>
# let's put all this together
docker images
docker build -t ubuntu_web_server .
docker images
docker ps -a
docker run -d -p 8080:80 ubuntu_web_server
docker ps
ip a
# Check that everything works opening in a elinks the page:
elinks http://<VM_ip_address>:8080
# to attach a shell...
docker exec -ti  <docker ID> /bin/bash 
# inside the container verify the web server is running (you should see apache2 processes running)
ps -ef
# exit the container with ctrl+d
docker stop <docker ID>
####################################
####  Docker volumes
# map a local directory
mkdir -p $HOME/containers/scratch 
cd $HOME/containers/scratch
head -c 10M < /dev/urandom > dummy_file
docker run -v $HOME/containers/scratch/:/container_data -i -t ubuntu /bin/bash
# try: ll /container_data from inside the container
docker stop <docker ID>
##################################################
# attach a volume to a docker container
docker volume create some-volume
docker volume ls 
docker volume inspect some-volume
docker volume rm some-volume
docker run -i -t --name myname -v some-volume:/app ubuntu /bin/bash
# exit the docker
docker volume rm <volume_name>
# is previous command working? If not try removing the docker first
docker rm <docker ID>
docker volume prune
#########################################
#########  Docker compose
#########################################
cd $HOME
curl -L "https://github.com/docker/compose/releases/download/v2.6.0/docker-compose-linux-x86_64" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
mkdir p $HOME/containers/compose
cd $HOME/containers/compose
nano docker-compose.yml
# copy this file into the editor window
version: '3'
services:
   database:
      image: mysql:5.7
      environment:
         - MYSQL_DATABASE=wordpress
         - MYSQL_USER=wordpress
         - MYSQL_PASSWORD=testwp
         - MYSQL_RANDOM_ROOT_PASSWORD=yes
      networks:
         - backend
   wordpress:
      image: wordpress:latest
      depends_on:
         - database
      environment:
         - WORDPRESS_DB_HOST=database:3306
         - WORDPRESS_DB_USER=wordpress
         - WORDPRESS_DB_PASSWORD=testwp
         - WORDPRESS_DB_NAME=wordpress
      ports:
         - 8080:80
      networks:
         - backend
         - frontend
networks:
    backend:
    frontend:
#########################################
# now try these commands
docker-compose up --build --no-start
docker-compose start
# Check that everything works opening in a browser this page: http://<VM_ip_address>:8080/ 
# now we can stop everything
docker-compose stop
docker-compose down
docker images
docker system prune
#########################################
#########  udocker
#########################################
git clone --depth=1 https://github.com/indigo-dc/udocker.git
export PATH=`pwd`/udocker/udocker:$PATH
udocker search ubuntu
ls
cd ..
ls
cd IMAPP24/
ls
chmod +x ./test.sh
cd ..
docker run -it -v ./IMAPP24/ build_docker
docker run -it -v ./ build_docker
cd IMAPP24/
docker run -it -v ./ build_docker
yum -y install nano wget curl git
curl https://download.docker.com/linux/centos/docker-ce.repo -o /etc/yum.repos.d/docker-ce.repo 
ls
#######################################
####### INSTALL DOCKER on CENTOS8
#######################################
# add port 8080 to firewall on google cloud dashboard. "default-allow-http"
# become superuser
sudo su -
# installing useful tools
yum -y install nano wget curl git
yum install --enablerepo=powertools elinks -y
# download the examples from github
git clone https://github.com/chierici/IMAPP_2024.git
# install the docker repo
curl https://download.docker.com/linux/centos/docker-ce.repo -o /etc/yum.repos.d/docker-ce.repo 
sed -i -e "s/enabled=1/enabled=0/g" /etc/yum.repos.d/docker-ce.repo 
# install docker
yum --enablerepo=docker-ce-stable -y install docker-ce 
# start docker
systemctl enable --now docker
systemctl status docker
#######################
#### start using docker
#######################
docker --version
docker version # more details
docker search ubuntu
docker pull ubuntu
docker run ubuntu echo "hello from the container"
docker run -i -t  ubuntu /bin/bash
#### now you are in a shell running inside the container, remeber to exit to go back in the host shell: type exit or Ctrl+D
docker images
time docker run ubuntu echo "hello from the container"
docker run ubuntu ping www.google.com # something unexpected?
docker run ubuntu /bin/bash -c "apt update; apt -y install iputils-ping"
docker run ubuntu ping www.google.com # still something?
docker run ubuntu /bin/bash -c "apt update; apt -y install iputils-ping; ping -c 5 www.google.com"
docker ps
docker ps -a 
docker images
docker commit <get the container ID using docker ps -a> ubuntu_with_ping
docker images
docker run ubuntu_with_ping ping -c 5 www.google.com
docker system df
docker system prune
docker images
docker ps -a
############################################
# Interacting with docker-hub
docker login
docker images
docker tag 5c2538cecdc2 ataruz/imap_2023:ubuntu_with_ping_1.0
docker push ataruz/imap_2023:ubuntu_with_ping_1.0
############################################
# Bulding docker images using Dockerfiles
mkdir -p containers/simple
cd IMAPP_2023/Containers/
cp Dockerfile index.html ~/containers/simple/
cd ~/containers/simple/
# Dockerfile should be like this
# cat Dockerfile
FROM ubuntu
RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y apache2
ENV DEBIAN_FRONTEND=noninteractive
COPY index.html /var/www/html/
EXPOSE 80
CMD ["apachectl", "-D", "FOREGROUND"]
# index.html file should be like this
# cat index.html
<html>
This is an exercise for the IMAPP course.
</html>
# let's put all this together
docker images
docker build -t ubuntu_web_server .
docker images
docker ps -a
docker run -d -p 8080:80 ubuntu_web_server
docker ps
ip a
# Check that everything works opening in a elinks the page:
elinks http://<VM_ip_address>:8080
# to attach a shell...
docker exec -ti  <docker ID> /bin/bash 
# inside the container verify the web server is running (you should see apache2 processes running)
ps -ef
# exit the container with ctrl+d
docker stop <docker ID>
####################################
####  Docker volumes
# map a local directory
mkdir -p $HOME/containers/scratch 
cd $HOME/containers/scratch
head -c 10M < /dev/urandom > dummy_file
docker run -v $HOME/containers/scratch/:/container_data -i -t ubuntu /bin/bash
# try: ll /container_data from inside the container
docker stop <docker ID>
##################################################
# attach a volume to a docker container
docker volume create some-volume
docker volume ls 
docker volume inspect some-volume
docker volume rm some-volume
docker run -i -t --name myname -v some-volume:/app ubuntu /bin/bash
# exit the docker
docker volume rm <volume_name>
# is previous command working? If not try removing the docker first
docker rm <docker ID>
docker volume prune
#########################################
#########  Docker compose
#########################################
cd $HOME
curl -L "https://github.com/docker/compose/releases/download/v2.6.0/docker-compose-linux-x86_64" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
mkdir p $HOME/containers/compose
cd $HOME/containers/compose
nano docker-compose.yml
# copy this file into the editor window
version: '3'
services:
   database:
      image: mysql:5.7
      environment:
         - MYSQL_DATABASE=wordpress
         - MYSQL_USER=wordpress
         - MYSQL_PASSWORD=testwp
         - MYSQL_RANDOM_ROOT_PASSWORD=yes
      networks:
         - backend
   wordpress:
      image: wordpress:latest
      depends_on:
         - database
      environment:
         - WORDPRESS_DB_HOST=database:3306
         - WORDPRESS_DB_USER=wordpress
         - WORDPRESS_DB_PASSWORD=testwp
         - WORDPRESS_DB_NAME=wordpress
      ports:
         - 8080:80
      networks:
         - backend
         - frontend
networks:
    backend:
    frontend:
#########################################
# now try these commands
docker-compose up --build --no-start
docker-compose start
# Check that everything works opening in a browser this page: http://<VM_ip_address>:8080/ 
# now we can stop everything
docker-compose stop
docker-compose down
docker images
docker system prune
#########################################
#########  udocker
#########################################
git clone --depth=1 https://github.com/indigo-dc/udocker.git
export PATH=`pwd`/udocker/udocker:$PATH
udocker search ubuntu
docker ps
docker search build
docker search build_
docker ps
docker stop ubuntu
docker stop d65b3c0d5377
docker ps
ls
cd ~
ls
cd containers/
ls
cd IMAPP24/
nano Dockerfile
docker build -t build_docker:latest .
nano Dockerfile
docker build -t build_docker:latest .
nano Dockerfile
docker build -t build_docker:latest .
docker ps
docker run ubuntu ping www.google.com
ls
cd ~
ls
cd IMAPP_2024/
ls
cd ..
cd containers/
ls
cd IMAPP24/
ls
nano Dockerfile 
docker build -t test .
docker run test
docker ps
nano Dockerfile 
docker run test pint www.google.com
docker build -t test .
docker run test pint www.google.com
docker run test ping www.google.com
nano Dockerfile 
docker run ubuntu bash
docker ps
docker run -i -t ubuntu /bin/bash
nano Dockerfile 
docker build -t test .
nano Dockerfile 
docker build -t test .
nano Dockerfile 
docker build -t test .
nano Dockerfile 
docker build -t test .
docker build -t test .
nano Dockerfile 
docker build -t test .
nano Dockerfile 
nano Dockerfile 
docker ps
ös
ls
cd ~/containers/IMAPP24/
ls
rm test*
rm -r test/
ls
docker run --name mytmp --tmpfs /app ubuntu /bin/bash
docker run --name mytmp --tmpfs /app ubuntu /bin/bash
docker ps
docker run mytmp
docker run --name mytmp --tmpfs /app ubuntu /bin/bash
clear
docker build -t build_docker
docker build -t build_docker .
docker ps
docker run -dit ubuntu -v .
mkdir test
ls
docker run --rm --tmpfs /tmp:rw,size=64m ubuntu /bin/bash
docker run -u --rm --tmpfs /tmp:rw,size=64m ubuntu /bin/bash
docker run -i --rm --tmpfs /tmp:rw,size=64m ubuntu /bin/bash
cd ~/containers/IMAPP24/
ls
docker build -t build_docker .
docker build -t build_docker .
cd ~/containers/IMAPP24/
docker build -t build_docker .
nano Dockerfile 
docker build -t build_docker .
nano Dockerfile 
nano Dockerfile 
docker build -t build_docker .
nano Dockerfile 
nano Dockerfile 
docker build -t build_docker .
nano Dockerfile 
nano start.sj
nano start.sh
ls
cp Dockerfile start.sh
nano start.sh 
nano Dockerfile 
docker build -t build_docker .
nano Dockerfile 
docker build -t build_docker .
nano Dockerfile 
docker build -t build_docker .
nano Dockerfile 
cd ~/containers/IMAPP24/
/home
nano Dockerfile 
docker build -t build_docker .
docker run  --rm --tmpfs /tmp:rw,size=64m build_docker
nano Dockerfile 
docker build -t build_docker .
docker run  --rm --tmpfs /tmp:rw,size=64m build_docker
nano Dockerfile 
docker build -t build_docker .
docker run  --rm --tmpfs /tmp:rw,size=64m build_docker
nano Dockerfile 
docker run  --rm --tmpfs /tmp:rw,size=64m build_docker
docker build -t build_docker .
nano Dockerfile 
docker build -t build_docker .
docker run  --rm --tmpfs /tmp:rw,size=64m build_docker
ls
nano Dockerfile 
docker build -t build_docker .
docker run  --rm --tmpfs /tmp:rw,size=64m build_docker
docker run  --rm --tmpfs /tmp:rw,size=64m build_docker /bin/bash
ls
docker run  --rm --tmpfs /tmp:rw,size=64m build_docker /bin/bash
docker ps
ls
cd /
ls
cd home
ls
cd chierici/
ls
cd ..
cd tc_ogasa/
ls
cd ..
cd ~
ls
cd ..
cd ~
$PWD
pwd
cd /root
ls
cd containers/
ls
cd IMAPP24/
ls
nano start.sh
./start.sh
chmode -wxr start.sh 
chmod -wxr start.sh 
./start.sh
chmod +wxr start.sh 
./start.sh
l
ls
cd MandelbrotProject/
ls
cd ..
ls
nano start.sh 
./start.sh
nano Dockerfile 
docker build -t build_container .
docker run -d -p build_container
docker run -d -p build_container /bin/bash
docker build -t build_container .
docker run -d -p build_container /bin/bash
docker run -d  build_container /bin/bash
docker run -d  build_container 
docker run -d  build_container bash
docker run -d  build_container /bin/bash
docker run build_container /bin/bash
docker run -i build_container /bin/bash
docker run -it build_container /bin/bash
docker ps
clear
docker volume create vol
docker volume ls
docker volume inspect vol
ls
docker run -v ./:/mnt/ -it build_container /bin/bash
ls
rm -r MandelbrotProject/build/
ls
cd MandelbrotProject/
ls
rm -r build/
rm -r build
rm -rf build
ls
cd ..
docker run -v ./:/mnt/ -it build_container 
docker run -v ./:/mnt/ build_container 
docker run -v ./:/mnt/ -it build_container /bin/bash
nano start.sh 
docker run -v ./:mnt/ build_docker /bin/bash
cd ~
ls
docker run -v ./:mnt/ build_docker /bin/bash
docker run -v ./:mnt/ -it build_docker /bin/bash
docker run -v ./:/mnt/ -it build_docker /bin/bash
ls
docker run -v ./IMAPP_2024/:/mnt/ -it build_docker /bin/bash
docker run -v ./containers/:/mnt/ -it build_docker /bin/bash
docker run -v ./containers/IMAPP24/:/mnt/ -it build_docker /bin/bash
ls
nano containers/IMAPP24/
nano containers/IMAPP24/start.sh 
docker run -v ./containers/IMAPP24/:/mnt/ -it build_docker /bin/bash
docker run -v ./containers/IMAPP24/:/mnt/  build_docker 
cd ..
ös
ls
cd chierici/
ls
cd ~
ls
cd containers/
ls
cd IMAPP24/
ls
cd run_Dockerfile 
nano build_Dockerfile 
nano start.sh 
cp start.sh build.sh
nano build_Dockerfile 
ls
rm start.sh 
ls
clear
ls
nano run_Dockerfile 
cd MandelbrotProject/
ls
cd build/
ls
cd ..
cd ..
nano run_Dockerfile 
cd ..
ls
cd ..
ls
./build.sh 
./run.sh 
cd containers/IMAPP24/MandelbrotProject/
ls
rm -rf build/
ls
cd ..
cd ..
cd ..
ls
./run.sh 
./build.sh 
./run.sh 
cd ~
ls
cd containers/IMAPP24/MandelbrotProject/build/
ls
cd ~
./run.sh 
cd containers/IMAPP24/MandelbrotProject/build/
ls
cd ..
ls
nano main_par.cpp 
ls
cd ..
ls
nano build
nano build.sh 
cd ..
ls
cd ..
ls
cd containers/IMAPP24/
ls
nano run_Dockerfile 
cd ..
cd ..
./run.sh 
cd containers/IMAPP24/
ls
cd MandelbrotProject/
ls
cd main_par.cpp 
nano main_par.cpp 
cd ..
cd ~
ls
./build.sh 
./run.sh 
cd containers/IMAPP24/
ls
cd MandelbrotProject/
cd build/
ls
cd ~
chmod +r run.sh 
./run.sh 
cd containers/IMAPP24/MandelbrotProject/build/
ös
ls
cd ~
ls
nano run.sh 
nano run.sh 
docker run -v ./containers/IMAPP24/:/mnt/ run_container
cd containers/IMAPP24/MandelbrotProject/build/
ls
cd ..
ls
cd 
docker run -v ./containers/IMAPP24/:/mnt/ -it run_container /bin/bash
cd containers/IMAPP24/MandelbrotProject/build/
ls
nano grainsize_duration.txt 
pwd
pwd mandelbrot_par
pwd mandelbrot_par.png 
cd ~
ls
cd containers/IMAPP24/MandelbrotProject/build/
ös
ls
cd ~
cd containers/IMAPP24/MandelbrotProject/build/
ls
cd /root/containers/IMAPP24/MandelbrotProject/build
cd ..
ls
nano main_par.cpp 
cd ~
./build.sh 
./run.sh 
cd containers/IMAPP24/MandelbrotProject/build/
ls
cd ..
ls
rm -rf build/
cd ~
./build.sh 
./run.sh 
cd containers/IMAPP24/MandelbrotProject/build/
ls
cd ..
ls
nano main_par.cpp 
nano main_par.cpp 
cd ~
./build.sh 
./run.sh 
cd /
ls
c d~
cd ~
nano containers/IMAPP24/MandelbrotProject/main_par.cpp 
ls
nano run.sh 
docker run -v ./containers/IMAPP24/:/mnt/ -it run_container /bin/bash
nano containers/IMAPP24/
nano containers/IMAPP24/run_Dockerfile 
./build.sh 
nano containers/IMAPP24/MandelbrotProject/main_par.cpp 
./build.sh 
nano containers/IMAPP24/MandelbrotProject/main_par.cpp 
./build.sh 
nano containers/IMAPP24/MandelbrotProject/main_par.cpp 
./build.sh 
nano containers/IMAPP24/MandelbrotProject/main_par.cpp 
./build.sh 
nano containers/IMAPP24/MandelbrotProject/main_par.cpp 
./build.sh 
./run.sh 
cd containers/IMAPP24/MandelbrotProject/build/
ls
nano grainsize_duration.txt 
pwd
touch /root/containers/IMAPP24/MandelbrotProject/build/mandelbrot_par.png
ls
