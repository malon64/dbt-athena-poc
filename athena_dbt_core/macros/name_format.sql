{% test name_format(model, column_name) %}
  SELECT *
  FROM {{ model }}
  WHERE NOT REGEXP_LIKE({{ column_name }}, '^[A-Za-z\s]+$')
{% endtest %}
