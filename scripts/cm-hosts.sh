#!/bin/bash
source /vagrant/scripts/cm-api.sh
source /vagrant/scripts/cm-hosts-functions.sh

# Check if the Cloudera Manager is already provisioning hosts
get_hosts_installing
# Check if hosts are already provisioned
all_hosts_provisioned
if [[ $hosts_installing == false || all_hosts_provisioned == false ]]; then
  echo "Adding the nodes to the cluster using the Cloudera Manager."
  data=$(jq . /vagrant/scripts/data/cm-hosts.json -c)
  cm_api_post "/cm/commands/hostInstall" $data
else
  echo "Hosts installed or Global Host install already executing. Please wait for completion and re-provision.."
fi
