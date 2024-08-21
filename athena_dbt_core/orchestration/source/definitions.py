import os

from dagster import Definitions
from dagster_dbt import DbtCliResource

from source.assets import athena_dbt_assets
from source.constants import dbt_project_dir
from source.schedules import schedules

defs = Definitions(
    assets=[athena_dbt_assets],
    schedules=schedules,
    resources={
        "dbt": DbtCliResource(project_dir=os.fspath(dbt_project_dir)),
    },
)