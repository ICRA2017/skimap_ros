FROM ros:kinetic-perception

RUN apt-get update && apt-get install -y \
	python-catkin-pkg python-rosdep python-wstool \
	python-catkin-tools ros-kinetic-catkin \
	software-properties-common \
	&& rm -rf /var/lib/apt/lists

ENV CATKIN_WS=/root/catkin_ws
RUN rm /bin/sh \
	&& ln -s /bin/bash /bin/sh
	
RUN source /ros_entrypoint.sh \
	&& mkdir -p $CATKIN_WS/src \
	&& cd $CATKIN_WS \
	&& catkin init \
	&& cd $CATKIN_WS/src \
	&& git clone https://github.com/ICRA2017/skimap_ros.git

RUN source /ros_entrypoint.sh \
	&& apt-get update \
	&& cd $CATKIN_WS/src \
	&& rosdep install -y --from-paths ./ --ignore-src --rosdistro kinetic

RUN apt-get update && apt-get install -y \
	ros-kinetic-geometry \
	&& rm -rf /var/lib/apt/lists

RUN source /ros_entrypoint.sh \
	&& cd $CATKIN_WS \
	&& catkin build
	