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
    cd /workspace/src && \
    git clone https://github.com/usnistgov/ARIAC.git -b logging_updates && \
    cd /workspace && \
    sudo apt update -qq && \
    sudo rosdep update && \
    rosdep install --from-paths src --ignore-src -y && \
    colcon build