#!/bin/bash

docker_runtime=runc
if [ "$(docker info|grep nvidia)" == "" ]; then
    echo "no nvidia-docker available"
else
	echo "nvidia-docker found"
	docker_runtime=nvidia
fi

XAUTH=/tmp/.docker.xauth
if [ ! -f $XAUTH ]
then
    xauth_list=$(xauth nlist $DISPLAY)
    xauth_list=$(sed -e 's/^..../ffff/' <<< "$xauth_list")
    if [ ! -z "$xauth_list" ]
    then
        echo "$xauth_list" | xauth -f $XAUTH nmerge -
    else
        touch $XAUTH
    fi
    chmod a+r $XAUTH
fi

# Prevent executing "docker run" when xauth failed.
if [ ! -f $XAUTH ]; then
    echo "[$XAUTH] was not properly created. Exiting..."
    exit 1
fi

BASH_OPTION=bash
if [ ! -z "$1" ]; then
    BASH_OPTION=$@
fi


echo "running $BASH_OPTION in docker"

docker run -it --rm \
        --runtime=$docker_runtime \
        --network host \
        --privileged \
        --name bnn-prediction \
        -e DISPLAY \
        -e QT_X11_NO_MITSHM=1 \
        -e XAUTHORITY=$XAUTH \
        -v "$XAUTH:$XAUTH" \
        -v "/tmp/.X11-unix:/tmp/.X11-unix" \
        -e ROS_MASTER_URI=$ROS_MASTER_URI \
        -v $HOME/.Xauthority:/root/.Xauthority \
        -v /dev:/dev \
        -v "${PWD}:/workspace" \
        -v "/data/datasets:/data" \
        -w /workspace \
        biomotion/bnn-prediction:latest $BASH_OPTION
