#!/bin/bash
source /vagrant/scripts/cm-api.sh

add_yarn_service () {
  echo "Setting up yarn service."
  data=$(jq . /vagrant/scripts/data/yarn-service.json -c)
  cm_api_post "/clusters/mars-development/services" $data
}

add_yarn_gateway_config () {
  echo "Setting up yarn gateway config"
  data=$(jq . /vagrant/scripts/data/yarn-gateway.json -c)
  cm_api_put "/clusters/mars-development/services/yarn/roleConfigGroups/yarn-GATEWAY-BASE/config" $data
}

add_yarn_jobhistory_config () {
  echo "Setting up yarn jobhistory config"
  data=$(jq . /vagrant/scripts/data/yarn-jobhistory.json -c)
  cm_api_put "/clusters/mars-development/services/yarn/roleConfigGroups/yarn-JOBHISTORY-BASE/config" $data
}

add_yarn_nodemanager_config () {
  echo "Setting up yarn nodemanager config"
  data=$(jq . /vagrant/scripts/data/yarn-nodemanager.json -c)
  cm_api_put "/clusters/mars-development/services/yarn/roleConfigGroups/yarn-NODEMANAGER-BASE/config" $data
}

add_yarn_resourcemanager_config () {
  echo "Setting up yarn resourcemanager config"
  data=$(jq . /vagrant/scripts/data/yarn-resourcemanager.json -c)
  cm_api_put "/clusters/mars-development/services/yarn/roleConfigGroups/yarn-RESOURCEMANAGER-BASE/config" $data
}

add_yarn_roleConfigGroups () {
  echo "Setting up yarn roleConfigGroups."
  # data=$(jq . /vagrant/scripts/data/yarn-role-config-groups.json -c)
  # cm_api_post "/clusters/mars-development/services/yarn/roleConfigGroups" $data
  add_yarn_gateway_config
  add_yarn_jobhistory_config
  add_yarn_nodemanager_config
  add_yarn_resourcemanager_config
}

add_yarn_roles () {
  echo "Setting up yarn roles."
  data=$(jq . /vagrant/scripts/data/yarn-roles.json -c)
  cm_api_post "/clusters/mars-development/services/yarn/roles" $data
}

first_run_yarn () {
  echo "First run for yarn."
  data='{}'
  cm_api_post "/clusters/mars-development/services/yarn/commands/firstRun" $data
}

start_yarn () {
  echo "Starting yarn."
  data='{}'
  cm_api_post "/clusters/mars-development/services/yarn/commands/start" $data
}

status_yarn () {
  echo "Getting yarn status."
  data='{}'
  cm_api_post "/clusters/mars-development/services/yarn/commands/status" $data
}

stop_yarn () {
  echo "Stopping yarn."
  data='{}'
  cm_api_post "/clusters/mars-development/services/yarn/commands/stop" $data
}

get_config_yarn_nodeemanager () {
  echo "Getting config for yarn nodeemanager."
  cm_api_get "/clusters/mars-development/services/yarn/roleConfigGroups/yarn-NODEMANAGER-BASE/config" true
}

get_config_yarn () {
  echo "Getting config for yarn."
  cm_api_get "/clusters/mars-development/services/yarn/config" true
}

deploy_client_config_yarn () {
  echo "Deploying client config for yarn."
  data='{}'
  cm_api_post "/clusters/mars-development/services/yarn/commands/deployClientConfig" $data
}

if [[ $CM_USE_PARCELS = false ]]; then
  echo " Installing yarn rpm packages."
  # install yarn packages
  install_package "hadoop-yarn"
fi

# check for cluster to be available
cm_get_cluster_name
if [[ $CM_CLUSTER_NAME == $CLUSTER_NAME ]]; then
  echo "Adding yarn Service to Cluster: $CLUSTER_NAME..."
  add_yarn_service
  add_yarn_roleConfigGroups
  add_yarn_roles
  # deploy_client_config_yarn
  # first_run_yarn
  start_yarn
  get_config_yarn
else
  echo "Cluster is not ready yet, please provision again."
fi
