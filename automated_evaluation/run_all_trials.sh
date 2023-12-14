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

trials_dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )" # https://stackoverflow.com/a/4774063/99379

for entry in "$trials_dir"/trials/*
do  
    echo $entry
    # e.g., kitting.yaml
    trial_file="${entry##*/}"
    # e.g., kitting
    trial_name=${trial_file::-5}

    
    echo "==== Copying logs to /tmp/.ariac2023/logs/$teamName"
    
    docker exec -it $teamName bash -c ". /container_scripts/run_trial.sh $1 $trial_name"
    
    echo "==== Copying logs to"
    
    if [ $flag -eq 0 ]; then
        docker cp $teamName:/tmp/score.txt $PWD/logs/$teamName/$trial_name/score.txt
        docker cp $teamName:/tmp/sensor_cost.txt $PWD/logs/$teamName/$trial_name/sensor_cost.txt
    else
        docker cp $teamName:/tmp/score.txt $PWD/logs/$teamName/$trial_name_$i/score.txt
        docker cp $teamName:/tmp/sensor_cost.txt $PWD/logs/$teamName/$trial_name_$i/sensor_cost.txt
    fi

done
