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


if [[ $2 ]] ; then
    echo "==== Running trial: $2"
    flag=0
    if [ ! -d /$PWD/logs/$teamName/$2 ]; then
        mkdir -p /$PWD/logs/$teamName/$2/;
    else
        i=2
        flag=1
        while [ -d /$PWD/logs/$teamName/$2_$i ]; do
            let i++
        done
        mkdir -p /$PWD/logs/$teamName/$2_$i/;
    fi
    docker exec -it $teamName bash -c ". /container_scripts/run_trial.sh $1 $2"
    echo "==== Copying logs to"
    if [ $flag -eq 0 ]; then
        docker cp $teamName:/tmp/score.txt $PWD/logs/$teamName/$2/score.txt
        docker cp $teamName:/tmp/sensor_cost.txt $PWD/logs/$teamName/$2/sensor_cost.txt
    else
        docker cp $teamName:/tmp/score.txt $PWD/logs/$teamName/$2_$i/score.txt
        docker cp $teamName:/tmp/sensor_cost.txt $PWD/logs/$teamName/$2_$i/sensor_cost.txt
    fi
fi


##Different script to run all trials
#runalltrials.sh and takes arguments of number of trials to run
if [[ ! $2 ]] ; then
    echo "==== Running all trials from the trials directory"
    # absolute path of the current script
    trials_dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )" # https://stackoverflow.com/a/4774063/99379
    # get each file in the trials folder
    for entry in "$trials_dir"/trials/*
    do
        # e.g., kitting.yaml
        trial_file="${entry##*/}"
        # e.g., kitting
        trial_name=${trial_file::-5}

        docker exec -it $teamName bash -c ". /container_scripts/run_trial.sh $1 $trial_name"
        echo "==== Copying logs to /tmp/.ariac2023/logs/$teamName"
        # docker cp $teamName:/home/ubuntu/logs/$trial_name.txt /tmp/.ariac2023/logs/$teamName

    done
fi


