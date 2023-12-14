#!/bin/bash

#---------------------------------------------------------
# Example usage:./run_trial.sh nist_competitor trial_name
#---------------------------------------------------------
if [[ ! $1 ]] ; then
    echo "Team configuration argument not passed" 
    exit 1
fi

teamName=$1

# Create a folder to copy log files from docker
if [ ! -d /$PWD/logs/$teamName ]; then
  mkdir -p /$PWD/logs/$teamName/;
fi


