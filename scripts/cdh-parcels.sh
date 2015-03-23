#!/bin/bash
source /vagrant/scripts/cm-api.sh
source /vagrant/scripts/cdh-parcels-functions.sh
source /vagrant/scripts/cdh-local-parcels-functions.sh

if [[ $CM_USE_PARCELS = true ]]; then
  # using parcels and updating cloudera manager configuration
  update_parcels_config

  if [[ $CM_LOCAL_PARCELS_REPO = true ]]; then
    # using local parcels and updating cloudera manager configuration
    add_local_parcels_config
  fi

  # check for cluster to be available
  cm_get_cluster_name
  if [[ $CM_CLUSTER_NAME = $CLUSTER_NAME ]]; then
    # get the list of parcels
    get_parcels_array

    for p in "${!parcelsarray[@]}"
    do
      product=$(echo ${parcelsarray[$p]} | jq -r '.product')
      version=$(echo ${parcelsarray[$p]} | jq -r '.version')
      stage=$(echo ${parcelsarray[$p]} | jq -r '.stage')

      if [[ $stage == "AVAILABLE_REMOTELY" ]]; then
        echo "Downloading $product version $version..this could take a while.."
        echo "Please re-provision once parcels are downloaded."
        data="{}"
        cm_api_post "/clusters/mars-development/parcels/products/$product/versions/$version/commands/startDownload" $data
      fi

      if [[ $stage == "DOWNLOADING" ]]; then
        echo "Downloading $product version $version..this could take a while.."
      fi

      if [[ $stage == "DOWNLOADED" ]]; then
        echo "Downloaded $product version $version successfully.."
        echo "Distributing Parcels for $product version $version..this could take a while.."
        data="{}"
        cm_api_post "/clusters/mars-development/parcels/products/$product/versions/$version/commands/startDistribution" $data
      fi

      if [[ $stage == "DISTRIBUTING" ]]; then
        echo "Distributing $product version $version..this could take a while.."
      fi

      if [[ $stage == "DISTRIBUTED" ]]; then
        echo "Distributed $product version $version successfully.."
        echo "Activating Parcels for $product version $version..this could take a while.."
        data="{}"
        cm_api_post "/clusters/mars-development/parcels/products/$product/versions/$version/commands/activate" $data
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
    echo "Cluster is not ready yet, please provision again"
  fi

fi
