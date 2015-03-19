#!/bin/bash
source /vagrant/scripts/cm-api.sh
source /vagrant/scripts/cm-hosts-functions.sh

# Say Hello to make sure the manager is running
echo_cloudera_manager
if [[ $CM_ECHO = "\"Hello, World!\"" ]]; then
  # Check if the Cloudera Manager is already provisioning hosts
  get_hosts_installing
  # Check if hosts are already provisioned
  all_hosts_provisioned
  if [[ $hosts_installing = false && $hosts_provisioned_done = false ]]; then
    echo "Adding the nodes to the cluster using the Cloudera Manager."
    data=$(jq . /vagrant/scripts/data/cm-hosts.json -c)
    cm_api_post "/cm/commands/hostInstall" $data
  else
    echo "Hosts installed or Global Host install already executing. Please wait for completion and re-provision.."
  fi
else
  echo "Cloudera manager not running, please wait for server to start and re-repovision."
fi
