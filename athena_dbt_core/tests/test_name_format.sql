SELECT client_name
FROM {{ref('clean_client')}}
WHERE NOT REGEXP_LIKE(client_name, '^[A-Za-z ]+$')