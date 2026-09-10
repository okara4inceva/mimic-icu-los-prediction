WITH long_predictions AS (

  SELECT
    diagnosis_group,
    actual_los_days,
    predicted_raw_los_days AS predicted_los_days,
    'Raw LOS model' AS model
  FROM
    `mimic-analysis-491010.mimic_results.icu_test_predictions_compare_v1`

  UNION ALL

  SELECT
    diagnosis_group,
    actual_los_days,
    predicted_log_naive_days AS predicted_los_days,
    'Log LOS - naive retransformation' AS model
  FROM
    `mimic-analysis-491010.mimic_results.icu_test_predictions_compare_v1`

  UNION ALL

  SELECT
    diagnosis_group,
    actual_los_days,
    predicted_log_smearing_days AS predicted_los_days,
    'Log LOS - Duan smearing' AS model
  FROM
    `mimic-analysis-491010.mimic_results.icu_test_predictions_compare_v1`
),

diagnosis_counts AS (

  SELECT
    diagnosis_group,
    COUNT(*) AS n_test_stays
  FROM
    `mimic-analysis-491010.mimic_results.icu_test_predictions_compare_v1`
  GROUP BY
    diagnosis_group
),

top_diagnoses AS (

  SELECT
    diagnosis_group,
    n_test_stays,
    ROW_NUMBER() OVER (
      ORDER BY n_test_stays DESC
    ) AS diagnosis_rank
  FROM
    diagnosis_counts
  QUALIFY
    diagnosis_rank <= 6
)

SELECT
  p.diagnosis_group,
  p.model,

  COUNT(*) AS n_stays,

  AVG(p.actual_los_days) AS mean_actual_los,

  AVG(p.predicted_los_days) AS mean_predicted_los,

  AVG(
    ABS(p.predicted_los_days - p.actual_los_days)
  ) AS mae_days,

  SQRT(
    AVG(
      POW(p.predicted_los_days - p.actual_los_days, 2)
    )
  ) AS rmse_days,

  AVG(
    p.predicted_los_days - p.actual_los_days
  ) AS bias_days

FROM
  long_predictions p

INNER JOIN
  top_diagnoses d
ON
  p.diagnosis_group = d.diagnosis_group

GROUP BY
  p.diagnosis_group,
  p.model,
  d.diagnosis_rank

ORDER BY
  d.diagnosis_rank,
  p.model;
