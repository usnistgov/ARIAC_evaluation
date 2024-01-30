teamName=$1
trial=$2 

docker cp $PWD/logs/$teamName/$trial/state.log $teamName:/home

docker exec -it $teamName bash -c ". /container_scripts/playback_trial.sh"
        