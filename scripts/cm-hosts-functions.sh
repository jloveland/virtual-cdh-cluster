#!/bin/bash

get_hosts_installing () {
  cm_api_get "/cm/commands/hostInstall"
  response=$(jq . /vagrant/scripts/response/cm-api-get.json -c)
  global_host_install=$(echo $response | jq -r '[.items[] | select(.name | contains("GlobalHostInstall")) | contains({active: true})] | .[]')
  if [[ global_host_install == true ]]; then
    echo "Global Host install actively running."
    hosts_installing=true
  else
    echo "Global Host install not running."
    hosts_installing=false
  fi
}

all_hosts_provisioned () {
  # Get all hosts from our configuration files
  configHostsArray=($(jq . /vagrant/scripts/data/cm-hosts.json -c | jq -r '.hostNames | .[]'))

  # Get all hosts from Cloudera Manager
  cm_api_get "/hosts"
  response=$(jq . /vagrant/scripts/response/cm-api-get.json -c)

  for key in "${!configHostsArray[@]}"
  do
    hname="${configHostsArray[$key]}"
    cmHostsArray[$key]=$(echo $response | jq -r ".items[] | select(.hostname == \"$hname\") | .hostname")
  done

  # Determine if there is a difference between our config and the Cloudera Manager
  # TODO: this will not work is there's more hosts in the manager than whats in your config
  diff=$(diff <(printf "%s\n" "${configHostsArray[@]}") <(printf "%s\n" "${cmHostsArray[@]}"))
  if [[ -z "$diff" ]]; then
    all_hosts_provisioned=true
  else
    all_hosts_provisioned=false
  fi
}
