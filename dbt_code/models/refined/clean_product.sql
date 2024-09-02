{{ config(
    materialized='incremental',
    table_type='iceberg',
    incremental_strategy='merge',
    unique_key='product_id',
    update_condition='target.product_name != src.product_name OR target.product_date < src.product_date',
    format='parquet'
) }}

WITH latest_records AS (
    SELECT
        product_id,
        product_name,
        client_id,
        product_date,
        price,
        ROW_NUMBER() OVER (PARTITION BY product_id ORDER BY product_date DESC) AS row_num
    FROM {{ ref('stg_product') }}
)

SELECT
    product_id,
    product_name,
    client_id,
    product_date,
    price
FROM latest_records
WHERE row_num = 1