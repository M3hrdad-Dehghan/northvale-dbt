# Northvale analytics (dbt + Databricks)

A small, complete dbt project for a simulated online shop, Northvale.
Built in the dbt platform (Studio IDE) on Databricks, one branch and one pull request per step.

## Features used
- sources, staging / intermediate / marts layers
- seeds (product_categories, provinces)
- a macro (cents_to_dollars) and a Jinja loop (payment-method pivot)
- package dbt_utils
- materializations: view, table, incremental
- tests: unique, not_null, accepted_values, relationships, dbt_utils.expression_is_true, one singular test
- Semantic Layer: 2 semantic models, 5 metrics, daily time spine

## Run
```
dbt deps
dbt build
dbt sl query --metrics revenue --group-by metric_time__month
```