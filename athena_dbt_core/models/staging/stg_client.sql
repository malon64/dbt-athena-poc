{{ config(
    materialized='view'
) }}

SELECT
    client_id,
    client_name,
    join_date
FROM
    {{ ref('client_data') }}
