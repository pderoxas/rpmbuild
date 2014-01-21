#!/bin/bash

#This script will prompt the installer for the key information related to each specific terminal

#variables for the config files to modify/create
PUPPET_CONF=/etc/puppet/puppet.conf
FACTS_CONF=/etc/facter/facts.d/pos.txt
mkdir -p /etc/facter/facts.d

promptForValue() {

  read -p "$1": userResponse

  local  __valueVar=$2
  local  value=$userResponse
  if [[ "$__valueVar" ]]; then
     eval $__valueVar="$value"
  else
     echo "$value"
  fi
}


promptForValue "Please enter the PUPPET MASTER HOSTNAME" puppet_master
promptForValue "Please enter the GEO LOCATION CODE" geo_location
promptForValue "Please enter the GROUP NAME" group_name
promptForValue "Please enter the STORE NUMBER" store_number

echo "-------------------------------------------------"
echo "Summary:"
echo "PUPPET MASTER=$puppet_master"
echo "GEO LOCATION=$geo_location"
echo "GROUP NAME=$group_name"
echo "STORE_NUMBER=$store_number"
echo "-------------------------------------------------"

#set the puppet.conf content
echo "[agent]" > $PUPPET_CONF
echo "   server = $puppet_master" >> $PUPPET_CONF
echo "Puppet configuration file created at $PUPPET_CONF"
cat $PUPPET_CONF
echo "-------------------------------------------------"

#set the pos.txt FACTS file
echo "geo_location=$geo_location" > $FACTS_CONF
echo "group_name=$group_name" >> $FACTS_CONF
echo "store_number=$store_number" >> $FACTS_CONF
echo "Custom Facter facts file created at $FACTS_CONF"
cat $FACTS_CONF
echo "-------------------------------------------------"
