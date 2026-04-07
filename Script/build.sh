#!/bin/bash

set -e  # Exit immediately if a command fails

echo "----------------------------------------------------------"
echo "Building Docker Image for DevOps Build Environment"

IMAGE_NAME="jwalapj02/devops-build-dev"
VERSION_FILE="version.txt"

# Create version file if not exists
if [ ! -f "$VERSION_FILE" ]; then
  echo "0" > "$VERSION_FILE"
fi

# Read version safely
VERSION=$(cat "$VERSION_FILE")
NEW_VERSION=$((VERSION + 1))

# Update version file
echo "$NEW_VERSION" > "$VERSION_FILE"

echo "Building version v$NEW_VERSION"

# Check if Docker exists
if ! command -v docker &> /dev/null
then
    echo "ERROR: Docker is not installed or not in PATH"
    exit 1
fi

# Build and tag image
docker build -t "$IMAGE_NAME:v$NEW_VERSION" .
docker tag "$IMAGE_NAME:v$NEW_VERSION" "$IMAGE_NAME:latest"

echo "Build complete: v$NEW_VERSION"
echo "----------------------------------------------------------"