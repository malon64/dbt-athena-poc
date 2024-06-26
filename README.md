# DBT + Athena Incremental Loading PoC

This Proof of Concept (PoC) demonstrates how to use DBT (Data Build Tool) with AWS Athena to implement incremental loading of data. The goal is to show how to handle data transformations, enforce data quality checks, and efficiently process updates and new data using incremental models.

## Prerequisites

- AWS account with necessary permissions
- Terraform installed
- DBT Core installed
- AWS CLI configured with your credentials

## Project Structure

Sure, here's a more concise and precise README.md file reflecting your project structure and including the necessary instructions.

markdown

# DBT + Athena Incremental Loading PoC

This Proof of Concept (PoC) demonstrates how to use DBT (Data Build Tool) with AWS Athena to implement incremental loading of data. The goal is to show how to handle data transformations, enforce data quality checks, and efficiently process updates and new data using incremental models.

## Project Structure

```
dbt-athena-poc/
├── static_infra/
│ └── main.tf
│
└── athena_dbt_core/
├─── dbt_project.yml
├─── models/
│ ├── staging/
│ │ ├─ stg_client.sql
│ │ ├─ stg_product.sql
│ │ └─ schema.yml
│ └── refined/
│ ├─── clean_client.sql
│ ├─── clean_product.sql
│ └─── schema.yml
├── seeds/
│ ├── client_data.csv
│ └── product_data.csv
├── profiles.yml
└── tests/
├─── test_name_format.sql
└─── test_date_format.sql
```

## Step 1: Setting Up Infrastructure

Use Terraform to create the necessary AWS resources.

1. Navigate to the `static_infra` directory:
    ```bash
    cd static_infra
    ```

2. Initialize and apply the Terraform configuration:
    ```bash
    terraform init
    terraform apply
    ```

3. To destroy the infrastructure when done:
    ```bash
    terraform destroy
    ```

## Step 2: Setting Up DBT Environment

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

4. Set up the DBT profile by editing `profiles.yml`:
    ```yaml
    athena_dbt_core:
        target: dev
        outputs:
            dev:
            type: athena
            s3_staging_dir: <S3 Location to store request output>
            region_name: <Your S3 Region>
            schema: <Athena Database name>
            database: <Athena Data Catalog used (default -> awsdatacatalog)>
            aws_profile: default -> or use credntials to log with aws
            work_group: primary -> default
    ```

## Step 3: Seeding Data

Seed data is stored in CSV files and will be loaded into Athena.

1. **Client Data (`seeds/client_data.csv`)**:
    ```csv
    client_id,client_name,join_date
    1,Company A,2022-01-15
    2,Company B,2021-05-22
    3,Company C,2023-03-19
    2,Company B Duplicate,2021-05-22
    4,,2023-04-01
    5,Company E,2024-06-23
    6,Company F,2024-06-24
    6,Company F Duplicate,2024-06-24
    7,Company G,
    ```

2. **Product Data (`seeds/product_data.csv`)**:
    ```csv
    product_id,product_name,price
    1,Product X,99.99
    2,Product Y,199.99
    3,Product Z,299.99
    3,Product Z Duplicate,299.99
    4,Product W,
    5,Product V,499.99
    6,Product U,599.99
    6,Product U Duplicate,599.99
    7,,
    ```

3. Seed the data using DBT:
    ```bash
    dbt seed
    ```

### Explanation

Seeding in DBT allows you to load static data from CSV files into your database. This step is essential for initializing your dataset before running any transformations.

## Step 4: Running the Models

Run the DBT models to create the staging and refined tables.

1. **Initial Full Refresh**:
    ```bash
    dbt run --full-refresh
    ```

2. **Subsequent Incremental Runs**:
    ```bash
    dbt run
    ```

### Explanation

- **Full Refresh**: This creates the tables from scratch, ensuring that all data is loaded fresh from the seeds.
- **Incremental Run**: This only processes new or updated records, making the process more efficient.

## Step 5: Editing Original Data and Rerunning

1. **Edit the Seed Data**:
    Update the `client_data.csv` and `product_data.csv` with new records or updates. For example:

    **Updated Client Data (`seeds/client_data.csv`)**:
    ```csv
    client_id,client_name,join_date
    1,Company A,2022-01-15
    2,Company B,2021-05-22
    3,Company C,2023-03-19
    2,Company B Updated,2021-05-22
    4,,2023-04-01
    5,Company E,2024-06-23
    6,Company F,2024-06-24
    6,Company F Duplicate,2024-06-24
    7,Company G,
    8,Company H,2024-06-25
    ```

    **Updated Product Data (`seeds/product_data.csv`)**:
    ```csv
    product_id,product_name,price
    1,Product X,99.99
    2,Product Y,199.99
    3,Product Z,299.99
    3,Product Z Updated,299.99
    4,Product W,399.99
    5,Product V,499.99
    6,Product U,599.99
    6,Product U Duplicate,599.99
    7,Product T,699.99
    ```

2. **Re-seed the Data**:
    ```bash
    dbt seed
    ```

3. **Run DBT Models Incrementally**:
    ```bash
    dbt run
    ```

### Explanation

By editing the seed data and rerunning the workflow, you can see how incremental loading updates existing records with new data, demonstrating the efficiency of processing only new or updated records.

## Conclusion

This PoC demonstrates how to use DBT with AWS Athena to handle data transformations, enforce data quality, and efficiently process incremental updates. By following these steps, you can see the advantages of using incremental loading over full refreshes, especially when dealing with large datasets.
