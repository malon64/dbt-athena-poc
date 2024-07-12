#!/bin/bash

# Ensure the script stops on the first error
set -e

# Variables
ECR_REPO_URI=$1
REGION="eu-west-1"

# Check if Docker is available
if ! [ -x "$(command -v docker)" ]; then
  echo 'Error: docker is not installed or not available in the PATH.' >&2
  exit 1
fi

# Disable Docker BuildKit
export DOCKER_BUILDKIT=0

# Authenticate Docker to ECR
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ECR_REPO_URI

# Build the Docker image
docker build -t dagster-dbt-app ../athena_dbt_core

# Tag the Docker image
docker tag dagster-dbt-app:latest $ECR_REPO_URI:latest

# Push the Docker image to ECR
docker push $ECR_REPO_URI:latest
