#!/bin/bash

IMAGE_NAME="jwalapj02/devops-build-dev:"
VERSION_FILE="version.txt"

# Create version file if not exists
if [ ! -f $VERSION_FILE ]; then
  echo "0" > $VERSION_FILE
fi

VERSION=$(cat $VERSION_FILE)
NEW_VERSION=$((VERSION + 1))

echo $NEW_VERSION > $VERSION_FILE

echo "Building version v$NEW_VERSION"

docker build -t $IMAGE_NAME:v$NEW_VERSION .
docker tag $IMAGE_NAME:v$NEW_VERSION $IMAGE_NAME:latest

echo "Build complete: v$NEW_VERSION"