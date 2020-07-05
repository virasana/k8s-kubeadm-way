#!/bin/bash

echo "install curl"
apt-update
apt-get install -y curl

     --url 'http://example.com'\
     --output './path/to/file'

echo "setup hosts file"
cat <<EOT >> /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
10.0.0.245	etcd1
10.0.0.246	etcd2
10.0.0.137	controller1
10.0.0.138	controller2
10.0.0.181	worker1
10.0.0.182	worker2
EOT
