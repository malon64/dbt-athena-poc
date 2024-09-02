{% test date_format(model, column_name) %}
  SELECT *
  FROM {{ model }}
  WHERE {{ column_name }} IS NULL OR {{ column_name }} > CURRENT_DATE
{% endtest %}