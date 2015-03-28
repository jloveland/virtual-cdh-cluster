#!/bin/bash
source /vagrant/scripts/cm-api.sh

add_hdfs_service () {
  echo "Setting up hdfs service."
  data=$(jq . /vagrant/scripts/data/hdfs-service.json -c)
  cm_api_post "/clusters/mars-development/services" $data
}

add_hdfs_balancer_config () {
  echo "Setting up hdfs balancer config"
  data=$(jq . /vagrant/scripts/data/hdfs-balancer.json -c)
  cm_api_put "/clusters/mars-development/services/hdfs/roleConfigGroups/hdfs-BALANCER-BASE/config" $data
}

add_hdfs_datanode_config () {
  echo "Setting up hdfs datanode config"
  data=$(jq . /vagrant/scripts/data/hdfs-datanode.json -c)
  cm_api_put "/clusters/mars-development/services/hdfs/roleConfigGroups/hdfs-DATANODE-BASE/config" $data
}

add_hdfs_failovercontroller_config () {
  echo "Setting up hdfs failovercontroller config"
  data=$(jq . /vagrant/scripts/data/hdfs-failovercontroller.json -c)
  cm_api_put "/clusters/mars-development/services/hdfs/roleConfigGroups/hdfs-FAILOVERCONTROLLER-BASE/config" $data
}

add_hdfs_gateway_config () {
  echo "Setting up hdfs gateway config"
  data=$(jq . /vagrant/scripts/data/hdfs-gateway.json -c)
  cm_api_put "/clusters/mars-development/services/hdfs/roleConfigGroups/hdfs-GATEWAY-BASE/config" $data
}

add_hdfs_journalnode_config () {
  echo "Setting up hdfs journalnode config"
  data=$(jq . /vagrant/scripts/data/hdfs-journalnode.json -c)
  cm_api_put "/clusters/mars-development/services/hdfs/roleConfigGroups/hdfs-JOURNALNODE-BASE/config" $data
}

add_hdfs_namenode_config () {
  echo "Setting up hdfs namenode config"
  data=$(jq . /vagrant/scripts/data/hdfs-namenode.json -c)
  cm_api_put "/clusters/mars-development/services/hdfs/roleConfigGroups/hdfs-NAMENODE-BASE/config" $data
}

add_hdfs_nfsgateway_config () {
  echo "Setting up hdfs nfsgateway config"
  data=$(jq . /vagrant/scripts/data/hdfs-nfsgateway.json -c)
  cm_api_put "/clusters/mars-development/services/hdfs/roleConfigGroups/hdfs-NFSGATEWAY-BASE/config" $data
}

add_hdfs_secondarynamenode_config () {
  echo "Setting up hdfs namenode config"
  data=$(jq . /vagrant/scripts/data/hdfs-secondarynamenode.json -c)
  cm_api_put "/clusters/mars-development/services/hdfs/roleConfigGroups/hdfs-SECONDARYNAMENODE-BASE/config" $data
}

add_hdfs_roleConfigGroups () {
  echo "Setting up hdfs roleConfigGroups."
  # data=$(jq . /vagrant/scripts/data/hdfs-role-config-groups.json -c)
  # cm_api_post "/clusters/mars-development/services/hdfs/roleConfigGroups" $data
  add_hdfs_balancer_config
  add_hdfs_datanode_config
  add_hdfs_failovercontroller_config
  add_hdfs_gateway_config
  add_hdfs_journalnode_config
  add_hdfs_namenode_config
  add_hdfs_nfsgateway_config
  add_hdfs_secondarynamenode_config
}

add_hdfs_roles () {
  echo "Setting up hdfs roles."
  data=$(jq . /vagrant/scripts/data/hdfs-roles.json -c)
  cm_api_post "/clusters/mars-development/services/hdfs/roles" $data
}

first_run_hdfs () {
  echo "First run for hdfs."
  data='{}'
  cm_api_post "/clusters/mars-development/services/hdfs/commands/firstRun" $data
}

start_hdfs () {
  echo "Starting hdfs."
  data='{}'
  cm_api_post "/clusters/mars-development/services/hdfs/commands/start" $data
}

status_hdfs () {
  echo "Getting hdfs status."
  data='{}'
  cm_api_post "/clusters/mars-development/services/hdfs/commands/status" $data
}

stop_hdfs () {
  echo "Stopping hdfs."
  data='{}'
  cm_api_post "/clusters/mars-development/services/hdfs/commands/stop" $data
}

get_config_hdfs_datanode () {
  echo "Getting config for hdfs datanode."
  cm_api_get "/clusters/mars-development/services/hdfs/roleConfigGroups/hdfs-DATANODE-BASE/config" true
}

get_config_hdfs () {
  echo "Getting config for hdfs."
  cm_api_get "/clusters/mars-development/services/hdfs/config" true
}

deploy_client_config_hdfs () {
  echo "Deploying client config for hdfs."
  # get client config state, if stale, then deploy client config
  data='{}'
  cm_api_post "/clusters/mars-development/services/hdfs/commands/deployClientConfig" $data
}

if [[ $CM_USE_PARCELS = false ]]; then
  echo " Installing hdfs rpm packages."
  # install hdfs packages
  install_package "hadoop-hdfs"
fi

# check for cluster to be available
cm_get_cluster_name
if [[ $CM_CLUSTER_NAME == $CLUSTER_NAME ]]; then
  echo "Adding HDFS Service to Cluster: $CLUSTER_NAME..."
  add_hdfs_service
  add_hdfs_roleConfigGroups
  add_hdfs_roles
  # deploy_client_config_hdfs
  # first_run_hdfs
  start_hdfs
  get_config_hdfs
else
  echo "Cluster is not ready yet, please provision again."
fi
