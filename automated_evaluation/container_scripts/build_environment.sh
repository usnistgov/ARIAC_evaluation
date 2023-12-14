#!/bin/bash

cd /container_scripts/

chmod +x build_competitor_code.py

rm -r /workspace/src/ARIAC/ariac_gazebo/config/trials
mv /trials  /workspace/src/ARIAC/ariac_gazebo/config/

source /opt/ros/iron/setup.bash
python3 build_competitor_code.py $1