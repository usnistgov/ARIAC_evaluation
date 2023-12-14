#!/usr/bin/env python3

import os
import sys
from subprocess import Popen, call
from signal import SIGINT, SIGTERM
import yaml
import time
import glob
import subprocess
import shutil

def main():
    # Get team file name
    yaml_file = sys.argv[1] + '.yaml'

    if not os.path.isfile(yaml_file):
        print(f'{yaml_file} not found')
        sys.exit()

    # Parse yaml file
    with open(yaml_file, "r") as stream:
        try:
            data = yaml.safe_load(stream)
        except yaml.YAMLError:
            print("Unable to parse yaml file")
            sys.exit()

    # Store data from yaml filyaml_path
    try:
        package_name = data["competition"]["package_name"]
        print('Package_name: ', package_name)
    except KeyError:
        print("Unable to find package_name")
        sys.exit()

    try:
        launch_file = data["competition"]["launch_file"]
        print('Launch_file: ', launch_file)
    except KeyError:
        print("Unable to find launch_file")
        sys.exit()

    trial_name = sys.argv[2]

    process = Popen(["ros2", "launch", package_name, launch_file, f"competitor_pkg:={package_name}",
                    f"trial_name:={trial_name}", '--noninteractive'])

    
    # Continue execution of trial until log file is generated
    time.sleep(10)

    files = glob.glob(os.path.expanduser("/workspace/src/ARIAC/ariac_log/*"))
    sorted_by_mtime_descending = sorted(files, key=lambda t: -os.stat(t).st_mtime)[0]
    
    while True:
        if os.path.exists(f'{sorted_by_mtime_descending}/score.txt'):
            ##check tmp directory exists if it exists empty the temp directory if doesnot exist create one  
            shutil.move(f'{sorted_by_mtime_descending}/score.txt', '/tmp/score.txt')
            shutil.move(f'{sorted_by_mtime_descending}/sensor_cost.txt', '/tmp/sensor_cost.txt')
            ##check copy fuction instead of move exists.
            break

    print(f"==== Trial {trial_name} completed")

    # process.send_signal(SIGTERM)
    process.kill()
    # Might raise a TimeoutExpired if it takes too long
    return_code = process.wait(timeout=10)
    print(f"return_code: {return_code}")

if __name__ == "__main__":
    main()

# ros2 topic echo --once /ariac/trial_config

# ros2 topic echo --once /clock