#!/bin/bash
source /vagrant/scripts/cm-api.sh

setup_zk () {
  echo " Setting up zookeeper."
  data=$(jq . /vagrant/scripts/data/zookeeper.json -c)
  cm_api_post "/clusters/mars-development/services" $data
}

first_run_zk () {
  echo " First run for zookeeper."
  data=$(jq . /vagrant/scripts/data/cluster.json -c)
  cm_api_post "/clusters/mars-development/services/zookeeper1/commands/firstRun" $data
}

start_zk () {
  echo " Starting zookeeper."
  data=$(jq . /vagrant/scripts/data/cluster.json -c)
  cm_api_post "/clusters/mars-development/services/zookeeper1/commands/start" $data
}

status_zk () {
  echo " Getting zookeeper status."
  data=$(jq . /vagrant/scripts/data/cluster.json -c)
  cm_api_post "/clusters/mars-development/services/zookeeper1/commands/status" $data
}

stop_zk () {
  echo " Stopping zookeeper."
  data=$(jq . /vagrant/scripts/data/cluster.json -c)
  cm_api_post "/clusters/mars-development/services/zookeeper1/commands/stop" $data
}

init_zk () {
  echo " Initializing zookeeper."
  data=$(jq . /vagrant/scripts/data/cluster.json -c)
  cm_api_post "/clusters/mars-development/services/zookeeper1/commands/zooKeeperInit" $data
}

cleanup_zk () {
  echo " Cleaning zookeeper."
  data=$(jq . /vagrant/scripts/data/cluster.json -c)
  cm_api_post "/clusters/mars-development/services/zookeeper1/commands/zooKeeperCleanup" $data
}

if [[ $CM_USE_PARCELS == false ]]; then
  echo " Installing zookeeper rpm packages."
  # install zookeeper packages
  yum install -y zookeeper-server
fi

# check for cluster to be available
cm_get_cluster_name
if [ $CLUSTER_NAME == "\"mars-development\"" ]
then
  setup_zk
  first_run_zk
else
  echo "cluster not ready yet, please provision again"
fi
