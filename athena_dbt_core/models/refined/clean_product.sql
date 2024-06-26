{{ config(
    materialized='incremental',
    table_type='iceberg',
    incremental_strategy='merge',
    unique_key='product_id',
    format='parquet'
) }}

with new_data as (
    select
        product_id,
        product_name,
        price,
        row_number() over (partition by product_id order by price desc) as row_num
    from {{ ref('stg_product') }}
    where price > 0
),
deduped_new_data as (
    select
        product_id,
        product_name,
        price
    from new_data
    where row_num = 1
)

{% if is_incremental() %}

-- Merge logic for incremental loads
,
final_data as (
    select
        dnd.product_id,
        dnd.product_name,
        dnd.price
    from deduped_new_data dnd
    left join {{ this }} existing
    on dnd.product_id = existing.product_id

    union all

    select
        existing.product_id,
        existing.product_name,
        existing.price
    from {{ this }} existing
    left join deduped_new_data dnd
    on existing.product_id = dnd.product_id
    where dnd.product_id is null
)

select * from final_data

{% else %}

select * from deduped_new_data

{% endif %}