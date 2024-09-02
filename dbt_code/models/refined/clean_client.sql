{{ config(
    materialized='incremental',
    table_type='iceberg',
    incremental_strategy='merge',
    unique_key='client_id',
    update_condition='target.client_name != src.client_name AND src.join_date > target.join_date',
    format='parquet'
) }}

WITH latest_records AS (
    SELECT
        client_id,
        client_name,
        join_date,
        ROW_NUMBER() OVER (PARTITION BY client_id ORDER BY join_date DESC) AS row_num
    FROM {{ ref('stg_client') }}
)

SELECT
    client_id,
    client_name,
    join_date
FROM latest_records
WHERE row_num = 1