from dagster import AssetExecutionContext, Config
from dagster_dbt import DbtCliResource, dbt_assets

from .constants import dbt_manifest_path

@dbt_assets(manifest=dbt_manifest_path)
def athena_dbt_assets(context: AssetExecutionContext, dbt: DbtCliResource):
    yield from dbt.cli(["build"], context=context).stream()
