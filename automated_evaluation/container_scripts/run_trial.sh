#!/bin/bash

cd /container_scripts

chmod +x run_trial.py

source /opt/ros/iron/setup.bash
source /workspace/install/setup.bash

python3 run_trial.py $1 $2