# Static Infra for DBT and Athena

This directory contains the Terraform configuration files for setting up the static infrastructure required for DBT and Athena.

## Prerequisites

- Terraform installed
- AWS CLI installed and configured with appropriate permissions

## Directory Structure

- `provider.tf`: Configures the AWS provider.
- `s3.tf`: Defines the S3 bucket.
- `athena.tf`: Defines the Athena database.
- `iam.tf`: Defines the IAM roles and policies.
- `variables.tf`: Variables for the Terraform configuration.
- `outputs.tf`: Outputs for the Terraform configuration.
- `terraform.tfvars`: Contains the value for the AWS region variable.

## Deployment Steps

1. **Initialize Terraform**

    Navigate to the `static_infra` directory and initialize Terraform.

    ```bash
    cd static_infra
    terraform init
    ```

2. **Apply Terraform Configuration**

    Apply the Terraform configuration to create the necessary AWS resources.

    ```bash
    terraform apply
    ```

## Outputs

After applying the Terraform configuration, you will see the following outputs:

- `s3_bucket_name`: The name of the created S3 bucket.
- `athena_database_name`: The name of the created Athena database.
