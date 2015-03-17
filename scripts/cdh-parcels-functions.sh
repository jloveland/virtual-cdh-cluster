#!/bin/bash
source /vagrant/scripts/cm-api.sh

get_parcels_array () {
  cm_api_get "/clusters/mars-development/parcels"
  response=$(jq . /vagrant/scripts/response/cm-api-get.json -c)
  parcels_json=$(echo $response | jq -r '[.items[] | del(.clusterRef)]')

  declare -A myarray
  while IFS="=" read -r key value
  do
    myarray[$key]="$value"
  done < <(echo $parcels_json | jq -r "to_entries|map(\"\(.key)=\(.value|tostring)\")|.[]")
}

update_parcels_config () {
  echo "Using parcels and updating cloudera manager configuration"
  data=$(jq . /vagrant/scripts/data/parcels.json -c)
  cm_api_put "/cm/config" $data
  # TODO: check if we need to set a proxy
}
