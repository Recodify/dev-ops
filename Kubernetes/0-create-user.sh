#!/bin/bash

groupadd kubeadmin
useradd kubeadmin -g kubeadmin  -G admin -s /bin/bash -d /home/kubeadmin
mkdir -p /home/kubeadmin
cp -r /root/.ssh /home/kubeadmin/.ssh
chown -R kubeadmin:kubeadmin /home/kubeadmin
echo "kubeadmin ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers
