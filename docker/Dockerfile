FROM osrf/ros:iron-desktop-full

# Set default shell
SHELL ["/bin/bash", "-c"]

# Add new user
RUN useradd --system --create-home --home-dir /home/user --shell /bin/bash --gid root --groups sudo,video,users --uid 1000 --password user@123 user && \ 
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER $USER
# WORKDIR $HOME

# # Setup ROS workspace directory
# RUN mkdir -p $HOME/workspace

WORKDIR /workspace

RUN mkdir -p /workspace/src
# RUN source /opt/ros/iron/setup.bash && \
#     cd $HOME/workspace/src && \
#     git clone https://github.com/ros-controls/ros2_control.git -b 3.20.0 && \
#     cd ~/workspace && \
#     sudo apt update -qq && \
#     sudo rosdep update && \
#     rosdep install --from-paths src --ignore-src -y && \
#     colcon build

RUN source /opt/ros/iron/setup.bash && \
    cd /workspace/src && \
    git clone https://github.com/usnistgov/ARIAC.git -b logging_updates && \
    cd /workspace && \
    sudo apt update -qq && \
    sudo rosdep update && \
    rosdep install --from-paths src --ignore-src -y && \
    colcon build

# Set up working directory and bashrc
# WORKDIR /workspace

# RUN source /opt/ros/iron/setup.bash && \
#     cd /workspace && \
#     git clone https://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@github.com/saahu27/test_competitor.git && \
#     cd /workspace && \
#     sudo apt update -qq && \
#     sudo rosdep update && \
#     rosdep install --from-paths src --ignore-src -y && \
#     colcon build

# RUN echo 'source /opt/ros/iron/setup.bash' >> $HOME/.bashrc && \
#     echo 'source /workspace/install/setup.bash' >> $HOME/.bashrc

# RUN sudo apt update

CMD /bin/bash