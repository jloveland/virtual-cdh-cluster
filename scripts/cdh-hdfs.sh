#!/bin/bash
source /vagrant/scripts/cm-api.sh

add_hdfs () {
  echo "Setting up hdfs."
  data=$(jq . /vagrant/scripts/data/hdfs.json -c)
  cm_api_post "/clusters/mars-development/services" $data
}

first_run_hdfs () {
  echo "First run for hdfs."
  data=$(jq . /vagrant/scripts/data/cluster.json -c)
  cm_api_post "/clusters/mars-development/services/hdfs1/commands/firstRun" $data
}

start_hdfs () {
  echo "Starting hdfs."
  data=$(jq . /vagrant/scripts/data/cluster.json -c)
  cm_api_post "/clusters/mars-development/services/hdfs1/commands/start" $data
}

status_hdfs () {
  echo "Getting hdfs status."
  data=$(jq . /vagrant/scripts/data/cluster.json -c)
  cm_api_post "/clusters/mars-development/services/hdfs1/commands/status" $data
}

stop_hdfs () {
  echo "Stopping hdfs."
  data=$(jq . /vagrant/scripts/data/cluster.json -c)
  cm_api_post "/clusters/mars-development/services/hdfs1/commands/stop" $data
}

get_config_hdfs_dn () {
  echo "Getting config for hdfs datanode."
  cm_api_get "/clusters/mars-development/services/hdfs1/roleConfigGroups/hdfs-DATANODE-BASE/config" true
}

get_config_hdfs () {
  echo "Getting config for hdfs datanode."
  cm_api_get "/clusters/mars-development/services/hdfs1/config" true
}

if [[ $CM_USE_PARCELS = false ]]; then
  echo " Installing hdfs rpm packages."
  # install hdfs packages
  yum install -y hadoop-hdfs
fi

# check for cluster to be available
cm_get_cluster_name
if [[ $CM_CLUSTER_NAME == $CLUSTER_NAME ]]; then
  echo "Adding HDFS Service to Cluster: $CLUSTER_NAME..."
  add_hdfs
  first_run_hdfs
  get_config_hdfs
else
  echo "Cluster is not ready yet, please provision again."
fi
