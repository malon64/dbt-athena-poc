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
3. **Set up SSM paramters**

      Before deploying the infrastructure, ensure that you have the following SSM parameters set up in the AWS SSM Parameter Store:

   - /dev/dagster/postgres/DB_NAME
   - /dev/dagster/postgres/DB_USERNAME
   - /dev/dagster/postgres/DB_PASSWORD (encrypted)

   These parameters will be used to configure the Postgres database for the Dagster instance.

4. **Get the correct Dagster config in `dbt_code/orchestration/`**

    You need to have this config in `workspace.yaml`:
    ```yaml
    load_from:
    - grpc_server:
        host: "dagster-usercode.main-cluster.local"
        port: 4000
        location_name: "user_code_location"
    ```
    And this run_launcher config in `dagster.yaml`:
    ```yaml
    run_launcher:
        module: dagster_aws.ecs
        class: EcsRunLauncher
        config:
            # Optionally, specify the container name (defaults to 'run')
            container_name: "dagster_run"

            # Whether to include sidecars in the launched tasks
            include_sidecars: true

            # Use the current ECS task configuration for launching new tasks
            use_current_ecs_task_config: true
            secrets_tag: ""
    ```

5. **Apply Terraform Configuration**
    Apply the Terraform configuration to create the necessary AWS resources. There is no need to specify a variable file as the terraform.tfvars file is already in the directory.
    ```bash
    terraform apply
    ```
6. **Accessing the Containerized App**

    After the deployment is complete, Terraform will output a clickable HTTP link to access the Dagster webserver through the ALB.

    Example output:
    ```bash
    webserver_dns = "http://<alb-dns-name>"
    ```

