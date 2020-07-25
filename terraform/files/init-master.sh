#!/bin/bash
set -e

echo "********************************** INITIALISE KUBEADM ***********************************************"

kubeadm init --pod-network-cidr 10.244.0.0/16 --apiserver-advertise-address=10.0.0.137

echo "about to mkdir"

mkdir -p /home/ubuntu/.kube
cp -f /etc/kubernetes/admin.conf /home/ubuntu/.kube/config
chown $(id -u):$(id -g) /home/ubuntu/.kube/config
chmod -R 755 /home/ubuntu/.kube
cp /usr/bin/kubectl /usr/bin/k
