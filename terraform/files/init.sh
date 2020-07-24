#!/bin/bash

echo "setup hosts file"
cat <<EOT >> /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
10.0.0.137	master
10.0.0.181	worker1
10.0.0.182	worker2
EOT

echo "***********************************************************"
echo "===> KUBEADM PREREQUISITES <==="

function logIt {
  local text=$1
  echo "=====> $${text}"
}

logIt "check root access"
if [[ $(id -u) -ne 0 ]] ; then logIt "please run as root" ; exit 1 ; fi


logIt "load the br_netfilter module"
modprobe br_netfilter

logIt "enable bridged traffic in iptables (allows the iptables to see bridged traffic)"
logIt "https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/"
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system

logIt "https://kubernetes.io/docs/setup/production-environment/container-runtimes/"
logIt "set up the repository:"
logIt "install packages to allow apt to use a repository over https"
apt-get update && apt-get install -y \
  apt-transport-https ca-certificates curl software-properties-common gnupg2

logIt "add docker’s official gpg key"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

logIt "add the Docker apt repository"
add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) \
  stable"

echo "install docker ce"
apt-get update && apt-get install -y \
  containerd.io=1.2.13-2 \
  docker-ce=5:19.03.11~3-0~ubuntu-$(lsb_release -cs) \
  docker-ce-cli=5:19.03.11~3-0~ubuntu-$(lsb_release -cs)

logIt "set up the docker daemon"
mkdir /etc/docker
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

logIt "establish docker service directory"
mkdir -p /etc/systemd/system/docker.service.d

logIt "restart docker"
systemctl daemon-reload
systemctl restart docker

logIt "enable docker service start on boot"
systemctl enable docker

echo "*************************** KUBECTL, KUBEADM, KUBELET **************************************"

logIt  "install kubelet, kubeadm, kubectl"
sudo apt-get update && sudo apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl






