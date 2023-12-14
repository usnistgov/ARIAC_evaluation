#!/usr/bin/env python3

import os
import sys
import subprocess
import yaml


def main():
    # Get yaml file name
    if len(sys.argv) <= 1:
        print("Please include an argument for the yaml file to run")
        exit()
    yaml_file = sys.argv[1] + '.yaml'
    print(f'running {yaml_file}')
    
    if not os.path.isfile(yaml_file):
        print(f'{yaml_file} not found')
        exit()

    # Parse yaml file
    with open(yaml_file, "r") as stream:
        try:
            data = yaml.safe_load(stream)
        except yaml.YAMLError:
            print("Unable to parse yaml file")
            sys.exit()

    # Store data from yaml filyaml_path
    try:
        repository = data["github"]["repository"]
    except KeyError:
        print("Unable to find repository link")
        sys.exit()
    
    try:
        token = data["github"]["personal_access_token"]
    except KeyError:
        print("Unable to find personal_access_token")
        sys.exit()

    try:
        tag = data["github"]["tag"]
    except KeyError:
        print("No tag specified, using main")
        tag = ""

    try:
        team_name = data["team_name"]
    except KeyError:
        print("Unable to find package_name")
        sys.exit()
    
    # Clone the repository
    if not tag:
        clone_cmd = f"git clone https://{token}@{repository} /workspace/src/{team_name}"
    else:
        clone_cmd = f"git clone https://{token}@{repository} /workspace/src/{team_name} --branch {tag}"
    
    subprocess.run(clone_cmd, shell=True)

    # Run custom build scripts
    os.chdir('/competitor_build_scripts')
    for script in data["build"]["pre_build_scripts"]:
        subprocess.run(f"chmod +x {script}", shell=True)
        subprocess.run(f"./{script}", shell=True)

    # Install rosdep packages
    os.chdir('/workspace') 
    rosdep_cmd = "rosdep install --from-paths src --ignore-src -y"
    rosdep_update_cmd = "rosdep update --include-eol-distros"
    rosdep_fix_cmd = " sudo apt-get update"
    subprocess.run(rosdep_fix_cmd, shell=True)
    subprocess.run(rosdep_update_cmd, shell=True)
    subprocess.run(rosdep_cmd, shell=True)

    # Build the workspace
    build_cmd = "colcon build --packages-skip ariac_controllers ariac_description ariac_gui ariac_human ariac_moveit_config ariac_msgs ariac_plugins ariac_sensors test_competitor "
    subprocess.run(build_cmd, shell=True)


if __name__=="__main__":
    main()
