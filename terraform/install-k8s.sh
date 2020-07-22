#!/bin/bash

function logIt {
  local TEXT=$1
  echo "=====> ${1}"
}

logIt "check root access"
if [[ $(id -u) -ne 0 ]] ; then logIt "please run as root" ; exit 1 ; fi

logIt "enable bridged traffic in iptables (allows the iptables to see bridged traffic)"
logIt "https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/"
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system


logIt "install docker ce"
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

echo "establish docker service directory"
mkdir -p /etc/systemd/system/docker.service.d

#echo "install systemd - cmon this should be available n ubuntu!"
#apt-get -y install systemd

echo "enable docker service start on boot"
systemctl enable docker
