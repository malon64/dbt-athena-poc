# Welcome to your new dbt project!

This project is organized to transform and analyze data using dbt, with orchestration handled by Dagster.

## Using the Starter Project

Try running the following commands:

- `dbt run`: Executes your dbt models, creating or updating tables and views in your data warehouse. This command handles both full model builds and incremental updates, processing only new or changed data for incremental models.

- `dbt test`: Runs your data quality tests, ensuring that the data meets defined standards, like uniqueness or not null constraints, before it's used downstream.

- `dbt run --full-refresh`: Forces a complete rebuild of incremental models, dropping and recreating them from scratch. Use this when you need to reset an incremental model after changes in data or logic.

## How dbt Works

dbt (data build tool) allows data analysts and engineers to transform data in their warehouse more effectively. Here are the core components of a dbt project:

### Seeds

Seeds are CSV files in your dbt project (located in the `seeds/` directory). You can load these CSV files into your data warehouse using the `dbt seed` command. This is useful for small, static datasets that you want to include in your project.

### Models

Models are SQL files (located in the `models/` directory) that contain transformation logic. You define your models using SELECT statements. When you run `dbt run`, dbt compiles these SQL files into executable queries and runs them against your database.

### Tests

Tests are assertions you can make about your data. There are two types of tests in dbt:
- **Schema tests**: These tests are defined in your `schema.yml` files and are used to test data integrity (e.g., uniqueness, non-null constraints).
- **Data tests**: These are custom SQL queries that you define in the `tests/` directory. If the query returns any results, the test fails.

### Macros

Macros are reusable SQL snippets or Jinja functions that you can define in the `macros/` directory. They allow you to DRY (Don't Repeat Yourself) your SQL.

### Configuration Files

#### `dbt_project.yml`

This file contains the configuration for your dbt project. Here you can define settings like the name of your project, the directory paths for your models, seeds, and tests, and configurations for specific models.

#### `profiles.yml`

This file contains connection details for your data warehouse. Here's an example configuration for connecting to AWS Athena:

```yaml
athena_profile:
  target: dev
  outputs:
    dev:
      type: athena
      s3_staging_dir: 's3://your-s3-bucket/path/to/your/staging/dir/'
      region_name: 'your-aws-region'
      schema: 'your-database-name'
      database: 'athena'
      aws_profile: 'your-aws-profile'  # If you're using AWS CLI profiles
```
Ensure that your profiles.yml is correctly set up with the information from your static infrastructure.


## Deployment

For deploying the dbt app locally using Dagster, refer to the orchestration folder.

For more details on the orchestration setup with Dagster, refer to the [Dagster Orchestration README](./orchestration/)