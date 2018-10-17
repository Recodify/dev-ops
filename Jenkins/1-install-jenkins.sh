
#!/bin/bash

## Install pre-reqs

sudo apt install openjdk-8-jdk

## Install jenkins
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update
sudo apt install jenkins

## Start jenkins
sudo systemctl start jenkins

echo "Jenkins installed and running. Ensure you open your firewall"
