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

    if os.path.exists('/root/.ros/log'):
        os.remove('/root/.ros/log')

    trial_name = sys.argv[2]

    process = Popen(["ros2", "launch", package_name, launch_file, f"trial_name:={trial_name}", '--noninteractive'])

    # Continue execution of trial until log file is generated
    time.sleep(10)

    files = glob.glob(os.path.expanduser("/workspace/src/ARIAC/ariac_log/*"))
    current_log_path = sorted(files, key=lambda t: -os.stat(t).st_mtime)[0]

    while True:
        if os.path.exists(f'{current_log_path}/trial_log.txt'):
            if os.path.exists('/tmp/trial_log.txt'):
                os.remove('/tmp/trial_log.txt')
            if os.path.exists('/tmp/sensor_cost.txt'):
                os.remove('/tmp/sensor_cost.txt')
            shutil.copy(
                f'{current_log_path}/trial_log.txt', '/tmp/trial_log.txt')
            shutil.copy(
                f'{current_log_path}/sensor_cost.txt', '/tmp/sensor_cost.txt')
            break
        try:
            output = subprocess.check_output(
                "gz topic -l", shell=True).decode("utf-8")

            if output == '' or output.count('An instance of Gazebo is not running') > 0:
                print('Gazebo not running')
                create_score_cmd = "echo 'Gazebo Crashed score not recorded' > /tmp/trial_log.txt"
                subprocess.run(create_score_cmd, shell=True)
                shutil.copy(
                    f'{current_log_path}/sensor_cost.txt', '/tmp/sensor_cost.txt')
                break
        except subprocess.CalledProcessError:
            pass

    print(f"==== Trial {trial_name} completed")

    # process.send_signal(SIGTERM)
    process.kill()
    # Might raise a TimeoutExpired if it takes too long
    return_code = process.wait(timeout=10)
    print(f"return_code: {return_code}")


if __name__ == "__main__":
    main()
