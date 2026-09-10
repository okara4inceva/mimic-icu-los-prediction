-- Compare raw LOS and log-transformed LOS models
-- Evaluation cohort: 18,955 held-out ICU stays

WITH long_predictions AS (

  SELECT
    actual_los_days,
    predicted_raw_los_days AS predicted_los_days,
    'Raw LOS model' AS model
  FROM
    `mimic-analysis-491010.mimic_results.icu_test_predictions_compare_v1`

  UNION ALL

  SELECT
    actual_los_days,
    predicted_log_naive_days AS predicted_los_days,
    'Log LOS - naive retransformation' AS model
  FROM
    `mimic-analysis-491010.mimic_results.icu_test_predictions_compare_v1`

  UNION ALL

  SELECT
    actual_los_days,
    predicted_log_smearing_days AS predicted_los_days,
    'Log LOS - Duan smearing' AS model
  FROM
    `mimic-analysis-491010.mimic_results.icu_test_predictions_compare_v1`
),

mean_actual AS (

  SELECT
    AVG(actual_los_days) AS mean_actual_los
  FROM
    `mimic-analysis-491010.mimic_results.icu_test_predictions_compare_v1`
)

SELECT
  model,
  COUNT(*) AS n_test_stays,

  AVG(
    ABS(predicted_los_days - actual_los_days)
  ) AS mae_days,

  SQRT(
    AVG(
      POW(predicted_los_days - actual_los_days, 2)
    )
  ) AS rmse_days,

  AVG(
    predicted_los_days - actual_los_days
  ) AS bias_days,

  1 -
  (
    SUM(
      POW(actual_los_days - predicted_los_days, 2)
    )
    /
    SUM(
      POW(actual_los_days - mean_actual_los, 2)
    )
  ) AS r2

FROM
  long_predictions
CROSS JOIN
  mean_actual

GROUP BY
  model

ORDER BY
  mae_days;
