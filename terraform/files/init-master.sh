#!/bin/bash
set -e

function logIt {
  local text=$$1
  echo "=====> $${text}" | tee -a /tmp/kubeadm-install.log
}

logIt "********************************** INITIALISE KUBEADM ***********************************************"

kubeadm init --pod-network-cidr 10.244.0.0/16 --apiserver-advertise-address=10.0.0.137

logIt "setup kubeconfig for ubuntu user"
mkdir -p /home/ubuntu/.kube
cp -f /etc/kubernetes/admin.conf /home/ubuntu/.kube/config
chown $(id -u):$(id -g) /home/ubuntu/.kube/config
chmod -R 755 /home/ubuntu/.kube

logIt "create kubectl alias"
cp /usr/bin/kubectl /usr/bin/k

