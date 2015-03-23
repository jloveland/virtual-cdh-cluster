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
CM_PARCELS_NFS=false #TODO: determine if parcels can be installed using NFS
CM_PARCELS_NFS_SERVER="nasa-orion-1"
# TODO: get these from clusters definition
CM_PARCELS_NFS_CLIENTS=("nasa-orion-2" "nasa-orion-3" "nasa-orion-4")
CM_PARCELS_NFS_SERVER_PATH="/opt/cloudera/parcel-repo"
CM_PARCELS_NFS_CLIENT_PATH="/opt/cloudera/parcels"
# TODO: use this to populate data/parcels.json
# CM_PARCELS="CDH,IMPALA,SOLR,SPARK,NAVIGATOR,SQOOP_NETEZZA,SQOOP_TERADATA,KEYTRUSTEE,ACCUMULO"
# CM_REMOTE_PARCEL_REPO_URLS="http://archive.cloudera.com/cdh5/parcels/latest/,http://archive.cloudera.com/impala/parcels/latest/,http://archive.cloudera.com/search/parcels/latest/,http://archive.cloudera.com/spark/parcels/latest/,http://archive.cloudera.com/navigator-keytrustee5/parcels/latest/,http://archive.cloudera.com/sqoop-connectors/parcels/latest/,http://archive.cloudera.com/accumulo-c5/parcels/latest/"
CM_LOCAL_PARCELS_REPO=false

cm_api_get () {
  curl -s -u "$CM_USER:$CM_PASSWORD" "$CM_BASE_URL$1" --noproxy $CM_HOST > /vagrant/scripts/response/cm-api-get.json
  if [[ $2 == true ]]; then echo /vagrant/scripts/response/cm-api-get.json; fi
}

cm_api_post () {
  curl -s -H 'Content-Type: application/json' -u "$CM_USER:$CM_PASSWORD" "$CM_BASE_URL$1" --noproxy $CM_HOST -X POST --data $2
}

cm_api_put () {
  curl -s -H 'Content-Type: application/json' -u "$CM_USER:$CM_PASSWORD" "$CM_BASE_URL$1" --noproxy $CM_HOST -X PUT --data $2
}

cm_get_cluster_name () {
  cm_api_get "/clusters"
  CM_CLUSTER_NAME=$(jq . /vagrant/scripts/response/cm-api-get.json -c | jq -r ".items[0].name")
  # echo "Cluster Name: $CM_CLUSTER_NAME"
}

echo_cloudera_manager () {
  cm_api_get "/tools/echo"
  response=$(jq . /vagrant/scripts/response/cm-api-get.json -c)
  CM_ECHO=$(echo $response | jq '.message')
  # echo $CM_ECHO
}

install_package () {
  package=$1
  if rpm -qa | grep -q $package; then
    echo "$package already installed."
  else
    echo "installing $package."
    yum install -y $package
  fi
}
