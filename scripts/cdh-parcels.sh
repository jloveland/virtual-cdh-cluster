#!/bin/bash
source /vagrant/scripts/cm-api.sh
source /vagrant/scripts/cdh-parcels-functions.sh
source /vagrant/scripts/cdh-local-parcels-functions.sh

if [[ $CM_USE_PARCELS == true ]]; then
  update_parcels_config

  if [[ $CM_LOCAL_PARCEL_REPO == true ]]; then
    add_local_parcels_config
  fi

  # check for cluster to be available
  cm_get_cluster_name
  echo "Cluster name in cdh-parcels $CLUSTER_NAME"
  if [[ "$CLUSTER_NAME" == "mars-development" ]]; then
    echo "Successfully in cdh-parcels $CLUSTER_NAME"
    # echo 'Getting Parcel List for mars-development cluster'
    # cm_api_get "/clusters/mars-development/parcels"
    # response=$(jq . /vagrant/scripts/response/cm-api-get.json -c)
    # # parcels_json=$(echo $response | jq -r '[.items[] | select(.stage | contains("AVAILABLE_REMOTELY")) | del(.clusterRef)]')
    # parcels_json=$(echo $response | jq -r '[.items[] | del(.clusterRef)]')
    #
    # declare -A myarray
    # while IFS="=" read -r key value
    # do
    #   myarray[$key]="$value"
    # done < <(echo $parcels_json | jq -r "to_entries|map(\"\(.key)=\(.value|tostring)\")|.[]")
    get_parcels_array
    for key in "${!myarray[@]}"
    do
      product=$(echo ${myarray[$key]} | jq -r '.product')
      version=$(echo ${myarray[$key]} | jq -r '.version')
      stage=$(echo ${myarray[$key]} | jq -r '.stage')
      if [[ $stage == "AVAILABLE_REMOTELY" ]]; then
        echo "Downloading $product version $version..this could take a while.."
        echo "Please re-provision once parcels are downloaded."
        data="{}"
        cm_api_post "clusters/mars-development/parcels/products/$product/versions/$version/commands/startDownload" $data
      fi

      if [[ $stage == "DOWNLOADING" ]]; then
        echo "Downloading $product version $version..this could take a while.."
      fi

      if [[ $stage == "DOWNLOADED" ]]; then
        echo "Downloaded $product version $version successfully.."
        echo 'Distributing Parcels for $product version $version..this could take a while..'
        data="{}"
        cm_api_post "clusters/mars-development/parcels/products/$product/versions/$version/commands/startDistribution" $data
      fi

      if [[ $stage == "DISTRIBUTING" ]]; then
        echo "Distributing $product version $version..this could take a while.."
      fi

      if [[ $stage == "DISTIBUTED" ]]; then
        echo "Distributed $product version $version successfully.."
        echo 'Activating Parcels for $product version $version..this could take a while..'
        data="{}"
        cm_api_post "clusters/mars-development/parcels/products/$product/versions/$version/commands/startActivation" $data
      fi

      if [[ $stage == "ACTIVATING" ]]; then
        echo "Activating $product version $version..this could take a while.."
      fi

      if [[ $stage == "ACTIVATED" ]]; then
        echo "Activated $product version $version successfully.."
      fi

      if [[ $stage == "UNDISTRIBUTING" ]]; then
        echo "Undistributing $product version $version..this could take a while.."
      fi

    done
  else
    echo "cluster not ready yet, please provision again"
fi

fi
