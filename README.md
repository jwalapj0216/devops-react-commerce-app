Installing jenkins 
==================

sudo apt update
sudo apt install fontconfig openjdk-21-jre
java -version


sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update
sudo apt install jenkins

Plugins 
========
docker 
dodcker pipeline 
Pipeline: Stage View

Configure 
=========
1.add docker and git username and password in jenkins Credentials 
2. Put the clone link to multibranch 
3. 

Setting up docker in server
===========================

# Install Docker
sudo apt update
sudo apt install docker.io -y

# Start Docker
sudo systemctl start docker
sudo systemctl enable docker

# Add Jenkins user to Docker group
sudo usermod -aG docker jenkins

# Restart Jenkins
sudo systemctl restart jenkins

# docker compose 
sudo apt install docker-compose -y
