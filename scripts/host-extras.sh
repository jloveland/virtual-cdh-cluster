#!/bin/bash

echo "installing jq to parse JSON api response."
yum install -y jq

echo "setting vm.swappiness=0"
sysctl vm.swappiness=0
echo "vm.swappiness = 0" >> /etc/sysctl.conf
