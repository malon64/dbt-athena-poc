#!/bin/bash

# Ensure the script stops on the first error
set -e

# Variables
IMAGE_NAME=$1
ECR_REPO=$2
IMAGE_TAG=$3
DOCKERFILE_PATH=$4
CONTEXT_PATH=$5
REGION="eu-west-1"

# Check if Docker is available
if ! [ -x "$(command -v docker)" ]; then
  echo 'Error: docker is not installed or not available in the PATH.' >&2
  exit 1
fi

# Disable Docker BuildKit
export DOCKER_BUILDKIT=0

# Authenticate Docker to ECR
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ECR_REPO

# Build the Docker images
docker build -t $IMAGE_NAME:$IMAGE_TAG -f $DOCKERFILE_PATH $CONTEXT_PATH

# Tag the Docker images
docker tag $IMAGE_NAME:$IMAGE_TAG $ECR_REPO:$IMAGE_TAG

# Push the Docker images to ECR
docker push $ECR_REPO:$IMAGE_TAG
