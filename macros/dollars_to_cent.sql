{#- turn an integer amount in cents into dollars with 2 decimals -#}
{% macro cents_to_dollars(column_name, decimals=2) %}
    cast({{ column_name }} / 1000.0 as decimal(16, {{ decimals }}))
{% endmacro %}