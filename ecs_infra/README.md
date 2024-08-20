# ECS Infra for Dagster and DBT

This directory contains the Terraform configuration files for deploying a multi-container architecture on AWS ECS using Fargate. The setup includes an Application Load Balancer (ALB) in front of the webserver for managing traffic.

## Directory Structure

- `vpc.tf`: Defines the VPC, subnets, and internet gateway.
- `security_groups.tf`: Defines the security groups for ECS and RDS.
- `ecr.tf`: Defines the ECR repositories and the build/push script.
- `ecs.tf`: Defines the ECS cluster, task definitions, and services for the webserver, daemon, and user code containers.
- `iam.tf`: Defines the IAM roles and policies for ECS task execution and access to AWS resources.
- `rds.tf`: Configures the RDS PostgreSQL instance used for Dagster's persistent storage.
- `outputs.tf`: Outputs the Terraform configuration, including the DNS link to the webserver.
- `variables.tf`: Variables for the Terraform configuration.
- `data.tf`: Retrieves SSM parameters for storing sensitive information.
- `service_discovery.tf`: Sets up DNS service discovery for the ECS services.
- `terraform.tfvars`: Stores user-specific variables, such as your IP address for security group configuration.
- `build_and_push.sh`: Script to build and push the Docker images to ECR.

## Deployment Steps

1. **Configure `terraform.tfvars`**

   Before applying the Terraform configuration, update the `terraform.tfvars` file in the `ecs_infra` directory with your IP address. This will ensure that your IP address is allowed access through the security group.

   Example `terraform.tfvars`:
   ```hcl
   user_ip = "0.0.0.0"
   ```

2. **Initialize Terraform**
    Navigate to the ecs_infra directory and initialize Terraform.
    ```bash
    cd ecs_infra
    terraform init
    ```

3. **Apply Terraform Configuration**
    Apply the Terraform configuration to create the necessary AWS resources. There is no need to specify a variable file as the terraform.tfvars file is already in the directory.
    ```bash
    terraform apply
    ```
4. **Accessing the Containerized App**

    After the deployment is complete, Terraform will output a clickable HTTP link to access the Dagster webserver through the ALB.

    Example output:
    ```bash
    webserver_dns = "http://<alb-dns-name>"
    ```

