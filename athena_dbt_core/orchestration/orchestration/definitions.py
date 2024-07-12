import os

from dagster import Definitions
from dagster_dbt import DbtCliResource

from orchestration.assets import athena_dbt_core_dbt_assets
from orchestration.constants import dbt_project_dir
from orchestration.schedules import schedules

defs = Definitions(
    assets=[athena_dbt_core_dbt_assets],
    schedules=schedules,
    resources={
        "dbt": DbtCliResource(project_dir=os.fspath(dbt_project_dir)),
    },
)