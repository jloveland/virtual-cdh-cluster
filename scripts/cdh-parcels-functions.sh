#!/bin/bash
source /vagrant/scripts/cm-api.sh

get_parcels_array () {
  cm_api_get "/clusters/mars-development/parcels"
  response=$(jq . /vagrant/scripts/response/cm-api-get.json -c)
  parcels_json=$(echo $response | jq -r '[.items[] | del(.clusterRef)]')

  while IFS="=" read -r key value
  do
    # echo "parcel $key = $value"
    parcelsarray[$key]="$value"
  done < <(echo $parcels_json | jq -r "to_entries|map(\"\(.key)=\(.value|tostring)\")|.[]")
}

update_parcels_config () {
  echo "Using parcels and updating cloudera manager configuration"
  data=$(jq . /vagrant/scripts/data/parcels.json -c)
  cm_api_put "/cm/config" $data
  # TODO: check if we need to set a proxy
}

get_parcel_status () {
  # get the list of parcels
  get_parcels_array
  parcel_activated=false

  for p in "${!parcelsarray[@]}"
  do
    product=$(echo ${parcelsarray[$p]} | jq -r '.product')
    version=$(echo ${parcelsarray[$p]} | jq -r '.version')
    stage=$(echo ${parcelsarray[$p]} | jq -r '.stage')

    if [[ $stage == "ACTIVATED" && $product == $parcel_product ]]; then
      parcel_activated=true
    fi
  done
}
