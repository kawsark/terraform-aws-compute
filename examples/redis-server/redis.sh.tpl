#!/bin/bash
#Install Docker
apt-get update -y
apt-get install linux-image-extra-$(uname -r) linux-image-extra-virtual -y
apt-get install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update -y
apt-get install docker-ce -y
groupadd docker
usermod -aG docker ubuntu
systemctl enable docker

#Download application and build image
cd /tmp && git clone https://github.com/kawsark/redis-client-service.git -b password
cd redis-client-service && sudo docker build -t python-clientms .

sudo docker run -p 6379:6379 --name redis -d redis redis-server --requirepass ${redis_password}
