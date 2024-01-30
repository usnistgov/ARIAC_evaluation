FROM osrf/ros:iron-desktop-full

# Set default shell
SHELL ["/bin/bash", "-c"]

# Add new user
RUN useradd --system --create-home --home-dir /home/user --shell /bin/bash --gid root --groups sudo,video,users --uid 1000 --password user@123 user && \ 
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER $USER

WORKDIR /workspace

RUN mkdir -p /workspace/src

RUN source /opt/ros/iron/setup.bash && \
    apt-get update -qq && \
    apt-get install python3-pip -y && \
    pip install setuptools==58.2.0 && \
    cd /workspace/src && \
    git clone https://github.com/usnistgov/ARIAC.git -b ariac2024 && \
    cd /workspace && \
    rosdep update && \
    rosdep install --from-paths src --ignore-src -y && \
    rm -r /workspace/src/ARIAC/ariac_gazebo/config/trials && \
    colcon build
