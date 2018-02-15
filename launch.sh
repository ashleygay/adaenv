#!/bin/bash

CUR_PATH=`pwd`
source $CUR_PATH/.variables.sh

# Setup and build the container here
{
	xhost +local:docker
	cp Dockerfile project/Dockerfile
	docker build -t ada project
}

# We forward the X server so that the container can use a GUI
# When mounting, we overwrite the default g++ of Ubuntu by
# the one from the linaro toolchain
{
	docker run -e DISPLAY=$DISPLAY\
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v $CUR_PATH/$__toolchain__/:/usr/gnat/ \
	-v $CUR_PATH/project:/home/gps/ada/ \
	-v ~/.vimrc:/home/gps/.vimrc \
	-t -i ada:latest
}
