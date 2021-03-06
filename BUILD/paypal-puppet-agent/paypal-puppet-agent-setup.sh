#!/bin/bash

####################################################
#This script will prompt the installer for the key #
#information related to each specific terminal     #
####################################################

#variables for the config files to modify/create
PUPPET_CONF=/etc/puppet/puppet.conf
FACTS_CONF=/etc/facter/facts.d/pos.txt
mkdir -p /etc/facter/facts.d

usage()
{
    echo "This script will create the required configuration files for the PayPal Puppet Agent that will run on each POS Terminal"
    echo ""
    echo "./paypal-puppet-agent-setup.sh"
    echo "\t-h --help"
    echo "\t--puppet-master-hostname=<Hostname>"
    echo "\t--geo-location=<GEO Location>"
    echo "\t--store-number=<Store Number>"
    echo "\t--silent-mode"
    echo ""
}

#define global variables
PUPPET_MASTER_PARAM=""
GEO_LOCATION_PARAM=""
STORE_NUMBER_PARAM=""
SILENT_MODE=false
 
while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $1 | awk -F= '{print $2}'`
    case $PARAM in
        -h | --help)
            usage
            exit
            ;;
        --silent-mode)
            SILENT_MODE=true
            ;;
        --puppet-master-hostname)
            PUPPET_MASTER_PARAM=$VALUE
            ;;
        --geo-location)
            GEO_LOCATION_PARAM=$VALUE
            ;;
        --store-number)
            STORE_NUMBER_PARAM=$VALUE
            ;;
        *)
            echo "ERROR: unknown parameter \"$PARAM\""
            usage
            exit 1
            ;;
    esac
    shift
done



#####################################################
# Helper function to prompt for user input and      #
# sets the provided variable with the value entered #
#####################################################
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

#####################################################
# Main function to prompt for values for config(s)  #
#####################################################
setupQuestions() {
  echo "========= PayPal Puppet Agent Setup ========="

  if [[ -z "$PUPPET_MASTER_PARAM" ]]; then
    promptForValue "Please enter the PUPPET MASTER HOSTNAME" puppet_master
  else
    puppet_master=$PUPPET_MASTER_PARAM
  fi

  if [[ -z "$GEO_LOCATION_PARAM" ]]; then
    promptForValue "Please enter the GEO LOCATION CODE" geo_location
  else
    geo_location=$GEO_LOCATION_PARAM
  fi

  if [[ -z "$STORE_NUMBER_PARAM" ]]; then
    promptForValue "Please enter the STORE NUMBER" store_number
  else
    store_number=$STORE_NUMBER_PARAM
  fi
  
  

  echo ""
  echo "You entered:"
  printf "%-25s %s\n" "PUPPET MASTER HOSTNAME:" $puppet_master
  printf "%-25s %s\n" "GEO LOCATION CODE:" $geo_location
  printf "%-25s %s\n" "STORE_NUMBER:" $store_number
  echo ""

}


#execute the main function until the user is satisfied
while [ !$SILENT_MODE ]
do
  #execute the main function
  setupQuestions

  read -p "Are these values correct? (y|n): " choice
  case "$choice" in 
    y|Y ) break;;
    * ) echo "Please try again...";;
  esac
done


#set the puppet.conf content
echo '#Generated by paypal-puppet-agent-setup.sh' > $PUPPET_CONF
echo '[main]' >> $PUPPET_CONF
echo '   logdir = /var/log/puppet' >> $PUPPET_CONF
echo '   rundir = /var/run/puppet' >> $PUPPET_CONF
echo '   ssldir = $vardir/ssl' >> $PUPPET_CONF
echo '[agent]' >> $PUPPET_CONF
echo '   classfile = $vardir/classes.txt' >> $PUPPET_CONF
echo '   localconfig = $vardir/localconfig' >> $PUPPET_CONF
echo "   server = $puppet_master" >> $PUPPET_CONF
echo '   runinterval = 1m' >> $PUPPET_CONF
echo '   pluginsync = true' >> $PUPPET_CONF
echo '   report = true' >> $PUPPET_CONF
echo "Puppet configuration file created at $PUPPET_CONF"
cat $PUPPET_CONF
echo "-------------------------------------------------"

#set the pos.txt FACTS file
echo "geo_location=$geo_location" > $FACTS_CONF
echo "store_number=$store_number" >> $FACTS_CONF
echo "Custom Facter facts file created at $FACTS_CONF"
cat $FACTS_CONF
echo "-------------------------------------------------"

#Start the service and set to start on boot
sudo service puppet start
sudo chkconfig puppet on

sleep 10
echo "Testing Puppet Agent connection to server..."
sudo puppet agent --test
