# ARIAC_evaluation

## Prerequisites

1. **Platform**: Ubuntu 20/22.
2. Install Docker Engine (CLI not Docker Desktop).
3. Install or update Nvidia drivers.
4. To enable Nvidia capabilities in docker, install the following package:
   - [Nvidia Container ToolKit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)

## Steps to run automated evaluation

1. Clone this repository into your workspace:
```
git clone https://github.com/usnistgov/ARIAC_evaluation.git
```

2. Build the docker image with Nvidia capabilities:
```
cd ARIAC_evaluation/docker && \
docker build -t ariac2024_image -f iron-cuda Dockerfile .
```
2.1 If you want to build the docker image without Nvidia capabilities, run:
```
cd ARIAC_evaluation/docker && \
docker build -t ariac2024_image -f Dockerfile .
```

3. To run automated evaluation, run:
```
cd ARIAC_evaluation/automated_evaluation && \
./build_container.sh nist_competitor
```

4. To run the trial evaluation, run:
```
./run_trial.sh nist_competitor kitting
```
