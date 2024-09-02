{{ config(
    materialized='incremental',
    table_type='iceberg',
    incremental_strategy='merge',
    unique_key='product_id',
    update_condition='target.client_name != src.client_name OR target.product_name != src.product_name',
    format='parquet'
) }}

SELECT
    p.product_id,
    p.product_name,
    p.product_date,
    p.price,
    c.client_id,
    c.client_name,
    c.join_date
FROM {{ ref('clean_product') }} p
JOIN {{ ref('clean_client') }} c
ON p.client_id = c.client_id
