#!/usr/bin/env bash

# Check args
if [ "$#" -ne 1 ]; then
  echo "usage: ./build.sh IMAGE_NAME"
  return 1
fi

# Get this script's path
pushd `dirname $0` > /dev/null
SCRIPTPATH=`pwd`
popd > /dev/null

BUILD_DATE=$(date -u +'%Y-%m-%d-%H:%M:%S')
CODE_NAME='xenial'
LIBGLVND_VERSION='v1.1.0'
JETPACK_VERSION='4.4.1'
TAG="jetpack-$JETPACK_VERSION-$CODE_NAME"

# use tar to dereference the symbolic links from the current directory,
# and then pipe them all to the docker build - command

# Build the docker image
tar -czh . | docker build\
  --build-arg REPOSITORY=arm64v8/ubuntu \
  --build-arg TAG=$CODE_NAME \
  --build-arg LIBGLVND_VERSION=$LIBGLVND_VERSION \
  --build-arg BUILD_VERSION=$JETPACK_VERSION \
  --build-arg BUILD_DATE=$BUILD_DATE \
  --build-arg user=$USER\
  --build-arg uid=$UID\
  --build-arg home=$HOME\
  --build-arg workspace=$SCRIPTPATH\
  --build-arg shell=$SHELL\
  -t $1 .
