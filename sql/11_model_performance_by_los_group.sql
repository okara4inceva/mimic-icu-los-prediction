WITH grouped_predictions AS (

  SELECT
    actual_los_days,

    CASE
      WHEN actual_los_days < 3 THEN '<3 days'
      WHEN actual_los_days < 7 THEN '3–<7 days'
      WHEN actual_los_days < 14 THEN '7–<14 days'
      ELSE '14+ days'
    END AS los_group,

    CASE
      WHEN actual_los_days < 3 THEN 1
      WHEN actual_los_days < 7 THEN 2
      WHEN actual_los_days < 14 THEN 3
      ELSE 4
    END AS sort_order,

    predicted_raw_los_days,
    predicted_log_naive_days,
    predicted_log_smearing_days

  FROM
    `mimic-analysis-491010.mimic_results.icu_test_predictions_compare_v1`
),

long_format AS (

  SELECT
    los_group,
    sort_order,
    actual_los_days,
    predicted_raw_los_days AS predicted_los_days,
    'Raw LOS model' AS model
  FROM grouped_predictions

  UNION ALL

  SELECT
    los_group,
    sort_order,
    actual_los_days,
    predicted_log_naive_days AS predicted_los_days,
    'Log LOS - naive retransformation' AS model
  FROM grouped_predictions

  UNION ALL

  SELECT
    los_group,
    sort_order,
    actual_los_days,
    predicted_log_smearing_days AS predicted_los_days,
    'Log LOS - Duan smearing' AS model
  FROM grouped_predictions
)

SELECT
  los_group,
  model,
  COUNT(*) AS n_stays,

  AVG(actual_los_days) AS mean_actual_los,

  AVG(predicted_los_days) AS mean_predicted_los,

  AVG(
    ABS(predicted_los_days - actual_los_days)
  ) AS mae_days,

  AVG(
    predicted_los_days - actual_los_days
  ) AS bias_days

FROM
  long_format

GROUP BY
  los_group,
  sort_order,
  model

ORDER BY
  sort_order,
  model;
