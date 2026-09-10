-- Evaluate diagnosis-specific ICU LOS models against the pooled raw-LOS model.
--
-- Two diagnosis groups are evaluated:
-- 1. Infectious and parasitic diseases
-- 2. Diseases of the circulatory system
--
-- Evaluation uses the same held-out test cohort as the pooled model.

WITH test_data AS (

  SELECT
    d.stay_id,
    d.diagnosis_group,
    d.icu_los_days AS actual_los_days,
    d.age_at_icu_admission,
    d.gender,
    d.admission_type,
    d.first_careunit,
    d.n_procedures

  FROM
    `mimic-analysis-491010.mimic_results.icu_ml_dataset_rebuilt` d

  INNER JOIN (
    SELECT DISTINCT stay_id
    FROM
      `mimic-analysis-491010.mimic_results.icu_test_predictions_log`
  ) te
  USING (stay_id)

  WHERE
    d.diagnosis_group IN (
      'Infectious and parasitic diseases',
      'Diseases of the circulatory system'
    )
),

infectious_specific AS (

  SELECT
    stay_id,
    predicted_icu_los_days AS predicted_specific_los

  FROM
    ML.PREDICT(
      MODEL `mimic-analysis-491010.mimic_results.icu_los_raw_infectious_specific_v1`,
      (
        SELECT
          stay_id,
          age_at_icu_admission,
          gender,
          admission_type,
          first_careunit,
          n_procedures
        FROM test_data
        WHERE diagnosis_group = 'Infectious and parasitic diseases'
      )
    )
),

circulatory_specific AS (

  SELECT
    stay_id,
    predicted_icu_los_days AS predicted_specific_los

  FROM
    ML.PREDICT(
      MODEL `mimic-analysis-491010.mimic_results.icu_los_raw_circulatory_specific_v1`,
      (
        SELECT
          stay_id,
          age_at_icu_admission,
          gender,
          admission_type,
          first_careunit,
          n_procedures
        FROM test_data
        WHERE diagnosis_group = 'Diseases of the circulatory system'
      )
    )
),

specific_predictions AS (

  SELECT
    stay_id,
    'Infectious and parasitic diseases' AS diagnosis_group,
    predicted_specific_los
  FROM infectious_specific

  UNION ALL

  SELECT
    stay_id,
    'Diseases of the circulatory system' AS diagnosis_group,
    predicted_specific_los
  FROM circulatory_specific
),

comparison AS (

  SELECT
    t.stay_id,
    t.diagnosis_group,
    t.actual_los_days,

    p.predicted_raw_los_days AS predicted_pooled_los,

    s.predicted_specific_los

  FROM
    test_data t

  INNER JOIN
    `mimic-analysis-491010.mimic_results.icu_test_predictions_compare_v1` p
  USING (stay_id)

  INNER JOIN
    specific_predictions s
  ON
    t.stay_id = s.stay_id
    AND t.diagnosis_group = s.diagnosis_group
),

grouped AS (

  SELECT
    *,

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
    END AS los_sort

  FROM
    comparison
),

long_format AS (

  SELECT
    diagnosis_group,
    los_group,
    los_sort,
    actual_los_days,
    predicted_pooled_los AS predicted_los,
    'Pooled RAW model' AS model
  FROM grouped

  UNION ALL

  SELECT
    diagnosis_group,
    los_group,
    los_sort,
    actual_los_days,
    predicted_specific_los AS predicted_los,
    'Diagnosis-specific RAW model' AS model
  FROM grouped
)

SELECT
  diagnosis_group,
  'Overall' AS analysis_level,
  'All stays' AS los_group,
  model,

  COUNT(*) AS n_stays,

  AVG(actual_los_days) AS mean_actual_los,

  AVG(predicted_los) AS mean_predicted_los,

  AVG(
    ABS(predicted_los - actual_los_days)
  ) AS mae_days,

  SQRT(
    AVG(
      POW(predicted_los - actual_los_days, 2)
    )
  ) AS rmse_days,

  AVG(
    predicted_los - actual_los_days
  ) AS bias_days

FROM
  long_format

GROUP BY
  diagnosis_group,
  model

UNION ALL

SELECT
  diagnosis_group,
  'LOS-stratified' AS analysis_level,
  los_group,
  model,

  COUNT(*) AS n_stays,

  AVG(actual_los_days) AS mean_actual_los,

  AVG(predicted_los) AS mean_predicted_los,

  AVG(
    ABS(predicted_los - actual_los_days)
  ) AS mae_days,

  SQRT(
    AVG(
      POW(predicted_los - actual_los_days, 2)
    )
  ) AS rmse_days,

  AVG(
    predicted_los - actual_los_days
  ) AS bias_days

FROM
  long_format

GROUP BY
  diagnosis_group,
  los_group,
  los_sort,
  model

ORDER BY
  diagnosis_group,
  analysis_level,
  los_group,
  model;
