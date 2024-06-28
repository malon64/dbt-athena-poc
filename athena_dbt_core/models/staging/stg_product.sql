{{ config(
    materialized='view'
) }}

SELECT
    product_id,
    product_name,
    client_id,
    product_date,
    price
FROM
    {{ ref('product_data') }}
WHERE
    product_id is not null
    and product_name is not null
    and price is not null
    and client_id is not null
    and product_date is not null