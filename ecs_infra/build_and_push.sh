#!/bin/bash

# Ensure the script stops on the first error
set -e

# Variables
ECR_REPO_APP=$1
ECR_REPO_USER_CODE=$2
REGION="eu-west-1"

# Check if Docker is available
if ! [ -x "$(command -v docker)" ]; then
  echo 'Error: docker is not installed or not available in the PATH.' >&2
  exit 1
fi

# Disable Docker BuildKit
export DOCKER_BUILDKIT=0

# Authenticate Docker to ECR
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ECR_REPO_APP
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ECR_REPO_USER_CODE

# Build the Docker images
docker build -t dagster-app:latest -f ../athena_dbt_core/orchestration/Dockerfile_dagster ../athena_dbt_core/orchestration
docker build -t dagster-user-code:latest -f ../athena_dbt_core/orchestration/Dockerfile_code ../athena_dbt_core

# Tag the Docker images
docker tag dagster-app:latest $ECR_REPO_APP:latest
docker tag dagster-user-code:latest $ECR_REPO_USER_CODE:latest

# Push the Docker images to ECR
docker push $ECR_REPO_APP:latest
docker push $ECR_REPO_USER_CODE:latest
