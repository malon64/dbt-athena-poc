# DBT and Dagster Project on AWS

This project is divided into three parts to set up and deploy a data pipeline using DBT and Dagster on AWS ECS with Fargate. The three parts are:

1. **athena_infra**: Sets up the database and S3 bucket required for the project.
2. **dbt_code**: Contains the DBT code for loading and transforming data, along with a Dagster project to orchestrate the DBT pipeline.
3. **ecs_infra**: Dockerizes the `dbt_code` project and deploys it on AWS ECS.

## Prerequisites

- **AWS CLI** installed and configured with appropriate permissions.
- **Terraform** installed.
- **Python 3.10** installed.
- **Docker** installed.

## Project Structure

- `athena_infra/`: Contains Terraform configuration for setting up AWS Athena and S3 bucket.
- `dbt_code/`: Contains DBT models and Dagster orchestration code.
- `ecs_infra/`: Contains Terraform configuration for deploying the containerized DBT and Dagster project on ECS.

## Setting Up the Environment

1. **Deploy Static Infrastructure**

    First, set up the AWS Athena database and S3 bucket, which are essential for the project. Navigate to the athena_infra directory and apply the Terraform configuration:

    ```bash
    cd athena_infra
    terraform init
    terraform apply
    ```

2. **Configure and Test DBT Models Locally**

    Once the static infrastructure is set up, you can explore and run the DBT models locally. Begin by setting up a Python virtual environment:

    ```bash
    python3.10 -m venv dbt-env
    source dbt-env/bin/activate  # On Windows use `dbt-env\Scripts\activate`
    ```

    With the virtual environment activated, navigate to the dbt_code directory and install the required packages:

    ```bash
    cd dbt_code
    pip install -r requirements.txt
    ```

    You can now test the DBT models by running them against the Athena database:

    ```bash
    dbt run # or dbt run --full-refresh
    ```

3. **Deploy Local Orchestration with Dagster**

    Next, you can set up a local instance of Dagster to orchestrate the DBT pipeline. This is done within the dbt_code/orchestration directory:

    ```bash
    cd dbt_code/orchestration
    # Follow the instructions in the README.md to configure and run Dagster locally
    ```

4. **Deploy the Containerized Application on ECS**

    If you want to deploy the entire orchestration setup on AWS, navigate to the ecs_infra directory and apply the Terraform configuration to build the Docker image and deploy it on ECS:

    ```bash
    cd ecs_infra
    # Follow the instructions in the README.md to configure and run Dagster in AWS
    ```
    This will set up the multi-container architecture on AWS, allowing you to run your DBT and Dagster workflows in a fully managed environment. 

## Further Details

For more detailed instructions on each part of the project, please refer to the `README.md` files located in each respective directory:

[Static Infrastructure](./athena_infra/)

[DBT Project with Dagster orchestration](./dbt_code/)

[Dynamic infrastructure](./ecs_infra/)