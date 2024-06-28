# DBT + Athena Incremental Loading PoC

This PoC demonstrates how to use DBT with AWS Athena for incremental data loading, transformations, and data quality checks.

## Project Structure

```
project-root/
├── static_infra/
│ └── main.tf
├── athena_dbt_core/
│ ├── dbt_project.yml
│ ├── models/
│ │ ├── staging/
│ │ │ ├── stg_client.sql
│ │ │ ├── stg_product.sql
│ │ │ └── schema.yml
│ │ └── refined/
│ │ ├── clean_client.sql
│ │ ├── clean_product.sql
│ │ ├── joined_product_client.sql
│ │ └── schema.yml
│ ├── seeds/
│ │ ├── client_data.csv
│ │ └── product_data.csv
│ ├── profiles.yml
│ └── macros/
│ ├── name_format.sql
│ ├── date_format.sql
│ └── numeric_format.sql
```

## Steps to Run the Project with Incremental Loading

### Step 1: Set Up Infrastructure

1. Navigate to the `static_infra` directory:
    ```bash
    cd static_infra
    ```

2. Initialize and apply the Terraform configuration:
    ```bash
    terraform init
    terraform apply
    ```

### Step 2: Set Up DBT Environment

1. Create a virtual environment:
    ```bash
    python3 -m venv dbt-env
    source dbt-env/bin/activate
    ```

2. Install DBT and the Athena adapter:
    ```bash
    pip install dbt-core dbt-athena-community
    ```

3. Navigate to the `athena_dbt_core` directory:
    ```bash
    cd ../athena_dbt_core
    ```

4. Configure the DBT profile in `profiles.yml`:
    ```yaml
    my_dbt_project:
      target: dev
      outputs:
        dev:
          type: athena
          region_name: eu-west-1
          s3_staging_dir: s3://athena-results-bucket/staging/
          schema: dbt_database
          database: awsdatacatalog
          aws_profile: default
          work_group: primary
    ```

### Step 3: Run DBT Models

1. **Seed the Data**:
    ```bash
    dbt seed
    ```

2. **Run Full Refresh**:
    ```bash
    dbt run --full-refresh
    ```

3. **Update Data**: Modify `seeds/client_data.csv` and `seeds/product_data.csv` to add new rows or update existing ones.

4. **Run Incremental Update**:
    ```bash
    dbt run
    ```

By following these steps, you will be able to run the project with incremental data loading, ensuring that updates are applied efficiently and data quality checks are enforced.