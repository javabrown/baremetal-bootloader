#!/bin/bash

# Set the image name
IMAGE_NAME="baremetal-dev"

echo "🔍 Checking if Docker image '$IMAGE_NAME' exists..."
if docker image inspect $IMAGE_NAME > /dev/null 2>&1; then
    echo "⚠️ Docker image '$IMAGE_NAME' found. Deleting it..."
    docker rmi -f $IMAGE_NAME
else
    echo "✅ No existing image found."
fi

echo "🚀 Building new Docker image '$IMAGE_NAME'..."
docker build -t $IMAGE_NAME .

echo "✅ Build complete. Running the container..."

# Run the container, mounting host files for development
docker run --rm -it \
    -v $(pwd)/src:/app/src \
    -v $(pwd)/bin:/app/bin \
    -v $(pwd)/scripts:/app/scripts \
    $IMAGE_NAME /bin/bash
