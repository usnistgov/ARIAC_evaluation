#!/bin/bash

#---------------------------------------------------------
# Example usage:./run_trial.sh nist_competitor trial_name
#---------------------------------------------------------
if [[ ! $1 ]] ; then
    echo "Team configuration argument not passed" 
    exit 1
fi

# teamName=$1

# Create a folder to copy log files from docker
if [ ! -d /$PWD/logs/$teamName ]; then
  mkdir -p /$PWD/logs/$teamName/;
fi


# if [[ $2 ]] ; then
#     echo "==== Running trial: $2"
#     i=1
#     if [ ! -d /$PWD/logs/$teamName/$2_$i ]; then
#         mkdir -p /$PWD/logs/$teamName/$2_$i/;
#     else
#         while [ -d /$PWD/logs/$teamName/$2_$i ]; do
#             let i++  
#         done
#         mkdir -p /$PWD/logs/$teamName/$2_$i/;
#     fi
#     docker exec -it $teamName bash -c ". /container_scripts/run_trial.sh $1 $2"
#     echo "==== Copying logs to"

#     docker cp $teamName:/tmp/score.txt $PWD/logs/$teamName/$2_$i/score.txt
#     docker cp $teamName:/tmp/sensor_cost.txt $PWD/logs/$teamName/$2_$i/sensor_cost.txt

# fi

function run_trial() {
    local teamname="$1"
    local trialname="$2"
    echo "$trialname"
    echo "$teamname"
    i=1;
    if [ ! -d /$PWD/logs/$teamname/$trialname\_$i ]; then
        mkdir -p /$PWD/logs/$teamname/$trialname\_$i/;
    else
        while [ -d /$PWD/logs/$teamname/$trialname\_$i ]; do
            let i++  
        done
        mkdir -p /$PWD/logs/$teamname/$trialname\_$i/;
    fi
    docker exec -it $teamname bash -c ". /container_scripts/run_trial.sh $teamname $trialname"
    echo "==== Copying logs to"
    
    docker cp $teamname:/tmp/score.txt $PWD/logs/$teamname/$trialname\_$i/score.txt
    docker cp $teamname:/tmp/sensor_cost.txt $PWD/logs/$teamname/$trialname\_$i/sensor_cost.txt
}


# ##Different script to run all trials
# #runalltrials.sh and takes arguments of number of trials to run
if [[ "$2" != "run-all" ]] ; then
    run_trial $1 $2

else
    if [[ ! $3 ]] ; then
        iterations=1
    else
        iterations=$3
    fi
    
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

        for ((i=1;i<=iterations;i++)); do
            run_trial $1 $trial_name
        done

    done
fi


