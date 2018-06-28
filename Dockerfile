FROM nvidia/opengl:1.0-glvnd-devel-ubuntu16.04

RUN export DEBIAN_FRONTEND=noninteractive \
 && apt-get update \
 && apt-get install -y \
    tzdata \
    lsb-release \
    gnupg \
 && ln -fs /usr/share/zoneinfo/America/Los_Angeles /etc/localtime \
 && dpkg-reconfigure --frontend noninteractive tzdata \
 && apt-get clean

RUN echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list \
 && apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116 \
 && apt-get update \
 && apt-get install -y \
    ros-kinetic-desktop-full \
 && rosdep init \
 && apt-get clean

RUN apt-get update && apt-get install -y \
	python-catkin-pkg python-rosdep python-wstool \
	python-catkin-tools ros-kinetic-catkin g++ \
	software-properties-common ros-kinetic-geometry ros-kinetic-rviz

RUN rm -rf /var/lib/apt/lists

ENV CATKIN_WS=/root/catkin_ws
RUN rm /bin/sh \
	&& ln -s /bin/bash /bin/sh
	
RUN source /opt/ros/kinetic/setup.bash \
	&& mkdir -p $CATKIN_WS/src \
	&& cd $CATKIN_WS \
	&& catkin init \
	&& cd $CATKIN_WS/src \
	&& git clone https://github.com/ICRA2017/skimap_ros.git

RUN source /opt/ros/kinetic/setup.bash \
	&& apt-get update \
	&& cd $CATKIN_WS/src \
	&& rosdep update \
	&& rosdep install -y --from-paths ./ --ignore-src --rosdistro kinetic

RUN source /opt/ros/kinetic/setup.bash \
	&& cd $CATKIN_WS \
	&& catkin build

