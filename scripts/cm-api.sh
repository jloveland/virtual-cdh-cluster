#!/bin/bash

if [[ $CLUSTER_NAME == '' ]]; then
  CLUSTER_NAME="mars-development"
fi

if [[ $CM_HOST == '' ]]; then
  CM_HOST="nasa-orion-1"
fi

if [[ $CM_PORT == '' ]]; then
  CM_PORT="7180"
fi

if [[ $CM_USER == '' || $CM_PASSWORD == '' ]]; then
  CM_USER="admin"
  CM_PASSWORD="admin"
fi

if [[ $CM_API_VERSION == '' ]]; then
  CM_API_VERSION=9
fi

if [[ $CM_SECURE != true ||  $CM_SECURE != false ]]; then
  CM_SECURE=false
fi

if [[ $CM_SECURE == true ]]; then
  HTTP_PROTOCOL="https://"
else
  HTTP_PROTOCOL="http://"
fi

# HEADER="\"Content-Type: application/json\""

CM_BASE_URL="$HTTP_PROTOCOL$CM_HOST:$CM_PORT/api/v$CM_API_VERSION"

CM_USE_PARCELS=true

# TODO: use this to populate data/parcels.json
# CM_PARCELS="CDH,IMPALA,SOLR,SPARK,NAVIGATOR,SQOOP_NETEZZA,SQOOP_TERADATA,KEYTRUSTEE,ACCUMULO"

CM_LOCAL_PARCELS_REPO=false

cm_api_get() {
  curl -s -u "$CM_USER:$CM_PASSWORD" "$CM_BASE_URL$1" --noproxy $CM_HOST > /vagrant/scripts/response/cm-api-get.json
  if [[ $2 == true ]]; then echo /vagrant/scripts/response/cm-api-get.json; fi
}

cm_api_post() {
  curl -s -H 'Content-Type: application/json' -u "$CM_USER:$CM_PASSWORD" "$CM_BASE_URL$1" --noproxy $CM_HOST -X POST --data $2
}

cm_api_put() {
  curl -s -H 'Content-Type: application/json' -u "$CM_USER:$CM_PASSWORD" "$CM_BASE_URL$1" --noproxy $CM_HOST -X PUT --data $2
}

cm_get_cluster_name() {
  cm_api_get "/clusters"
  CM_CLUSTER_NAME=$(jq . /vagrant/scripts/response/cm-api-get.json -c | jq -r ".items[0].name")
  echo "Cluster Name: $CM_CLUSTER_NAME"
}
