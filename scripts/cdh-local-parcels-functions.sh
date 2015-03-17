#!/bin/bash
source /vagrant/scripts/cm-api.sh

add_local_parcels_config () {
  echo "Adding local parcel repo to cloudera manager configuration"
  data=$(jq . /vagrant/scripts/data/parcels-local-repo.json -c)
  cm_api_put "/cm/config" $data
  # TODO: check if we need to set a proxy
}
