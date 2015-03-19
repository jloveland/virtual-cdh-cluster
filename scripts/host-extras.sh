#!/bin/bash
source /vagrant/scripts/cm-api.sh

# install jq packages
install_package "jq"

echo "setting vm.swappiness=0"
sysctl vm.swappiness=0
echo "vm.swappiness = 0" >> /etc/sysctl.conf
