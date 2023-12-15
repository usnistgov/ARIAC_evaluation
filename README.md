# Automated Evaluation

## Overview

To score each teams system, an semi-automated system is used. A docker container is created for each team with the ARIAC environment pre-installed.
we will run a series of automated evaluations and trial evaluations. To properly build and install the competitor's code onto the container each team must submit a configuration file using the following template. The yaml configuration file should be submitted to the Google Drive folder for your team..

---
**NOTE**

1. The configuration file should be named "team_name.yaml".

2. In order to clone from main, the tag in the configuration file should be commented out or set to main.

---

## Configuration File Example

``` yaml
# team configuration for automated evaluation

team_name: "nist_competitor"

github:
  repository: "github.com/usnistgov/nist_competitor.git"
  tag: "2024.1.0"
  personal_access_token: "****"

build:
  pre_build_scripts: ["nist_competitor_pre_build.sh"]

competition:
  package_name: "nist_competitor"
  launch_file: "competitor.launch.py"
```

## Instructions

- Competitors must upload their ROS package to a private github repository. Please ensure that only the ROS package you created is uploaded to this repository. If you include the entire ROS workspace it will not work properly. If you have multiple ROS packages they can all be included in a single folder. The ARIAC repository is an example of this setup.

- For the repository link ensure that it is structured exactly like the example above with the `https://` excluded.

- For the docker container to clone the environment teams will need to create a personal_access_token for the repository, [the intructions for which are shown here](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token). We suggest creating a fine-grain token and only giving read access permissions for the competition repository.

- The build scripts for the docker container will run rosdep automatically to ensure that any ROS packages you have included in your package manifest (`package.xml`) will be installed.

- However if you need to install packages that are not included in rosdep should create a custom build script, add those to the competitor_build_scripts directory and include the file name in the `pre_build_scripts` section of the yaml file. These scripts will also need to be added to the Google Drive folder. For example of this, see the `nist_competitor_pre_build.sh` script in the `competitor_build_scripts` folder.

- The competition section includes a launch file and the name of the package that includes that launch file. For the automated evaluation to work properly competitors must create a custom ROS launch file that starts the environment and any nodes that are necessary to complete the competiition. [Detailed instructions for this launch file are shown here](competition_launch.md)
  - *Note: if you have multiple ROS packages ensure that the package_name is set for the package that includes the launch file*

## Testing the Automated Evaluation

1. To run the automated evaluation you must have docker installed. The instructions for installing Docker Desktop (a GUI program that interfaces with Docker) are found [here](https://docs.docker.com/desktop/install/ubuntu/). The instructions to install Docker Engine with the commanand-line interface only are found [here](https://docs.docker.com/engine/install/ubuntu/). Either should work for testing the automated evaluation.

2. In order to enable Nvidia GPU acceleration for the docker container you must install the [Nvidia Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#docker).

3. After docker is installed pull the ARIAC image from docker hub using the terminal command:

    `docker image pull nistariac/ariac2024:latest`

4. Next ensure that the most up-to-date version of ARIAC2023 (at least version 1.2) is on your machine. You can ensure this by running `git pull` from `~/ariac_ws/src/ariac`

5. Navigate to the `automated_evaluation` folder

    `cd ~/ariac_ws/src/ariac/automated_evaluation`

6. Add your team configuration file to this folder. It can be named however you like.

7. Ensure that the `build_docker_image`, `build_container` and `run_trial` scripts can be run as executables:

    `chmod +x build_docer_image.sh build_container.sh run_trial.sh`

8. Make sure the docker engine is running.

9. Add any trials you want to test to the `~/ariac_ws/src/ariac/automated_evaluation/trials` folder. These will be copied to the container during the build process.

10. Run the build script with the name of your configuration file (without .yaml) as the first argument. If your host machine has nvidia graphics cards you can add the 'nvidia' argument to the build script to enable gpu acceleration. For example to build the nist_competitor example you would run:

    `./build_container.sh nist_competitor nvidia`

    - If you do not have nvidia graphics cards or do not want to use gpu acceleration you can run the script without the nvidia argument:

    `./build_container.sh nist_competitor`

    - To run the nist_competitor example the personal_access_token should be replaced with the following: `github(UNDERSCORE)pat(UNDERSCORE)11AMERXRA0077fKXamvIKb_3YPuZm5p653Jerzr0BB0PfaFjv2OC5aPs1ujpYTeqm6JX6DNC3GXsCg1xYu`

        - replace `(UNDERSCORE)`'s with `_`

    - This will create a container from the ARIAC image and attempt to clone and build the competitor package. You should see output in the terminal. If the build is successful continute onto the next step. If not, delete the created container (e.g., `docker rm nist_competitor --force`), fix the error and run the `build_container` script again. If the build script is successful it only needs to be run once. All trials can be run using this container.

1. To run a trial use the `run_trial.sh` script. The first argument is the team name which should also be the name of the container. The second argument is the name of the trial to be run. To all trials that are in the trials folder you need to pass a second argument `run-all`. For example to run the nist_competitor with  `kitting.yaml` trial you would run:

    `./run_trial.sh nist_competitor kitting`
and to run all trials you would run:

    `./run_trial.sh nist_competitor run-all`

and in order to run all trials multiple times you would run:

    `./run_trial.sh nist_competitor run-all 3`


    - The third argument is the number of times to run each trial. If this argument is not included the trial will only be run once.

12.  The output of the trial will be saved in the `/automated_evaluation/logs` folder. The output will be saved in a folder named after the trial. The output will include the ROS logs, the output of the evaluation script and the output of the scoring script.
```
