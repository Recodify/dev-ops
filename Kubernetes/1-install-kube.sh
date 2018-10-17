#!/bin/bash

## Allow https in apt repository sources
sudo apt-get update 
sudo apt-get install -y apt-transport-https

## Install Docker
sudo apt install docker.io
sudo systemctl start docker
sudo systemctl enable docker

## Install kubernetes install key
sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add 
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list > /dev/null

## Install kubernetes
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl kubernetes-cni

## Initialize master
sudo kubeadm init

## Setup kubectl with a config
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
cp -r /root/.ssh /home/kubeadmin/.ssh
chown -R kubeadmin:kubeadmin /home/kubeadmin


## Deploy pod network
sudo kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
sudo kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/k8s-manifests/kube-flannel-rbac.yml

kubectl get nodes --watch

