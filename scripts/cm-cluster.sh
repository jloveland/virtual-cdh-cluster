#!/bin/bash
source /vagrant/scripts/cm-api.sh

echo "Defining the cluster in the Cloudera Manager."
data=$(jq . /vagrant/scripts/data/clusters.json -c)
cm_api_post "/clusters" $data
