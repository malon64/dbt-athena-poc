SELECT join_date
FROM {{ref('clean_client')}}
WHERE join_date > CURRENT_DATE
