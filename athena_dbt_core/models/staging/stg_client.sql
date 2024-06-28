{{ config(
    materialized='view'
) }}

SELECT
    client_id,
    client_name,
    join_date
FROM
    {{ ref('client_data') }}
WHERE
    client_id is not null
    and client_name is not null
    and join_date is not null
