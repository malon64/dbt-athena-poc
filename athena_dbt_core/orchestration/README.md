# Dagster Orchestration

This directory contains the Dagster project used to orchestrate the dbt pipeline.

## Directory Structure
```
└── 📁orchestration
    └── README.md
    └── dagster.yaml
    └── 📁orchestration
        └── __init__.py
        └── assets.py
        └── constants.py
        └── definitions.py
        └── schedules.py
    └── pyproject.toml
    └── setup.py
    └── workspace.yaml
```


### Explanation of Files

- `dagster.yaml`: Configures the Dagster instance.
- `orchestration/`: Contains Python scripts for the Dagster project.
  - `__init__.py`: Initializes the module.
  - `assets.py`: Defines the dbt models as Dagster assets.
  - `constants.py`: Stores constants such as paths and configuration values.
  - `definitions.py`: Defines the Dagster job, including assets and schedules.
  - `schedules.py`: Defines schedules for running Dagster jobs.
- `pyproject.toml`: Configuration for the Python project, including dependencies.
- `setup.py`: Script for setting up the Python project.
- `workspace.yaml`: Configures the Dagster workspace to include the orchestration code.

## Running Dagster Locally

To run the Dagster server locally:

1. **Activate the Python Virtual Environment**

    Navigate to the root directory of the project and activate your virtual environment:

    ```bash
    source dbt-env/bin/activate  # On Windows use `dbt-env\Scripts\activate`
    ```

2. **Install Dependencies**

    Ensure all dependencies are installed:

    ```bash
    pip install -r athena_dbt_core/requirements.txt
    ```

3. **Run Dagster**

    Navigate to the `athena_dbt_core/orchestration` directory and run the Dagster development server:

    ```bash
    cd athena_dbt_core/orchestration
    DAGSTER_DBT_PARSE_PROJECT_ON_LOAD=1 dagster dev -f orchestration/definitions.py
    ```

This will start the Dagster webserver and make it accessible at `http://localhost:3000`.
