{{ config(
    materialized='incremental',
    table_type='iceberg',
    incremental_strategy='merge',
    unique_key=['client_id'],
    format='parquet'
) }}

with new_data as (
    select
        client_id,
        client_name,
        join_date,
        row_number() over (partition by client_id order by join_date desc) as row_num
    from {{ ref('stg_client') }}
    where client_name is not null
        and join_date <= current_date
),
deduped_new_data as (
    select
        client_id,
        client_name,
        join_date
    from new_data
    where row_num = 1
)

{% if is_incremental() %}

-- Merge logic for incremental loads
,
final_data as (
    select
        dnd.client_id,
        dnd.client_name,
        dnd.join_date
    from deduped_new_data dnd
    left join {{ this }} existing
    on dnd.client_id = existing.client_id

    union all

    select
        existing.client_id,
        existing.client_name,
        existing.join_date
    from {{ this }} existing
    left join deduped_new_data dnd
    on existing.client_id = dnd.client_id
    where dnd.client_id is null
)

select * from final_data

{% else %}

select * from deduped_new_data

{% endif %}