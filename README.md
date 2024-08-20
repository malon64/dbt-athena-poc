# DBT and Dagster Project on AWS

This project is divided into three parts to set up and deploy a data pipeline using DBT and Dagster on AWS ECS with Fargate. The three parts are:

1. **static_infra**: Sets up the database and S3 bucket required for the project.
2. **athena_dbt_core**: Contains the DBT code for loading and transforming data, along with a Dagster project to orchestrate the DBT pipeline.
3. **ecs_infra**: Dockerizes the `athena_dbt_core` project and deploys it on AWS ECS.

## Prerequisites

- **AWS CLI** installed and configured with appropriate permissions.
- **Terraform** installed.
- **Python 3.10** installed.
- **Docker** installed.

## Project Structure

- `static_infra/`: Contains Terraform configuration for setting up AWS Athena and S3 bucket.
- `athena_dbt_core/`: Contains DBT models and Dagster orchestration code.
- `ecs_infra/`: Contains Terraform configuration for deploying the containerized DBT and Dagster project on ECS.

## Setting Up the Environment

1. **Create a Python Virtual Environment**

    Navigate to the root directory of the project and create a virtual environment:

    ```bash
    python3.10 -m venv dbt-env
    source dbt-env/bin/activate  # On Windows use `dbt-env\Scripts\activate`
    ```

2. **Install DBT and Dagster**

    With the virtual environment activated, navigate to the `athena_dbt_core` directory and install the required packages:

    ```bash
    cd athena_dbt_core
    pip install -r requirements.txt
    ```

## Deployment Steps

### 1. Deploy Static Infrastructure

Navigate to the `static_infra` directory and follow the steps outlined in its `README.md` to set up the AWS Athena database and S3 bucket.

```bash
cd static_infra
terraform init
terraform apply
```
### 2. Configure and Test DBT and Dagster

Navigate to the athena_dbt_core directory to configure and test the DBT models and Dagster orchestration. Refer to the `README.md` in athena_dbt_core for detailed instructions.

```bash
cd athena_dbt_core
# Follow the instructions in the athena_dbt_core README.md
```

### 3. Deploy the Containerized Application on ECS

Navigate to the ecs_infra directory and follow the steps outlined in its `README.md` to build the Docker image and deploy it on ECS.

```bash
cd ecs_infra
terraform init
terraform apply"
```

## Further Details

For more detailed instructions on each part of the project, please refer to the `README.md` files located in each respective directory:

[Static Infrastructure](./static_infra/README.md)

[DBT Project with Dagster orchestration](./athena_dbt_core/README.md)

[Dynamic infrastructure](./ecs_infra/README.md)