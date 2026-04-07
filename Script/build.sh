#!/bin/bash
set -e

echo "----------------------------------------------------------"
echo "Building Docker Image"

IMAGE_NAME=$1
TAG=$2

if [ -z "$IMAGE_NAME" ] || [ -z "$TAG" ]; then
  echo "❌ ERROR: IMAGE_NAME or TAG not provided"
  exit 1
fi

echo "Image Name: $IMAGE_NAME"
echo "Tag: $TAG"

# Build image with Jenkins tag
docker build -t ${IMAGE_NAME}:${TAG} .

# Optional latest tag
docker tag ${IMAGE_NAME}:${TAG} ${IMAGE_NAME}:latest

echo "✅ Build complete: ${IMAGE_NAME}:${TAG}"
echo "----------------------------------------------------------"
echo "----------------------------------------------------------"
