#!/bin/bash
source /vagrant/scripts/cm-api.sh

first_run_cluster() {
  echo "First Run for cluster."
  data=$(jq . /vagrant/scripts/data/cluster.json -c)
  cm_api_post "/clusters/mars-development/commands/firstRun" $data
}

first_run_cluster
