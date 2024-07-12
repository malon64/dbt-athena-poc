# ECS Infra for Dagster and DBT

This directory contains the Terraform configuration files for deploying a Dagster and DBT application on AWS ECS using Fargate.

## Prerequisites

- Terraform installed
- AWS CLI installed and configured with appropriate permissions

## Directory Structure

- `vpc.tf`: Defines the VPC, subnets, and internet gateway.
- `security_groups.tf`: Defines the security groups for ECS.
- `ecr.tf`: Defines the ECR repository and build/push script.
- `ecs.tf`: Defines the ECS cluster, task definition, and service.
- `iam.tf`: Defines the IAM roles and policies.
- `outputs.tf`: Outputs for the Terraform configuration.
- `variables.tf`: Variables for the Terraform configuration.
- `build_and_push.sh`: Script to build and push the Docker image to ECR.
- `README.md`: This file.

## Deployment Steps

1. **Initialize Terraform**

    Navigate to the `ecs_infra` directory and initialize Terraform.

    ```bash
    cd ecs_infra
    terraform init
    ```

2. **Apply Terraform Configuration**

    Apply the Terraform configuration to create the necessary AWS resources. Ensure that your `terraform.tfvars` file is located in the root directory of your project.

    ```bash
    terraform apply -var-file="../terraform.tfvars"
    ```

3. **Build and Push Docker Image**

    The `build_and_push.sh` script is automatically triggered by Terraform to build and push the Docker image to ECR.

## Accessing the Containerized App

1. **Navigate to the ECS console in the AWS Management Console**.
2. **Select your ECS cluster** (e.g., `main-cluster`).
3. **Select the ECS service** (e.g., `dagster-dbt-service`).
4. **Select the running task**.
5. **Find the public IP address** assigned to the task under the `Network` section.
6. **Open your web browser** and navigate to the public IP address of the running task with port 3000 (e.g., `http://<publicIP>:3000`).

    Alternatively, you can find the full URL of the ECS service in the Terraform output after applying the configuration.
