-- Generate predictions from the matched raw-LOS and log-LOS models
-- on the same held-out test cohort.
--
-- Duan's smearing factor is estimated from TRAINING residuals only,
-- then applied to log-model predictions in the test set.

CREATE OR REPLACE TABLE
  `mimic-analysis-491010.mimic_results.icu_test_predictions_compare_v1`
AS

WITH train_data AS (

  SELECT
    d.stay_id,
    d.log_icu_los,
    d.age_at_icu_admission,
    d.gender,
    d.admission_type,
    d.first_careunit,
    d.n_procedures,
    d.diagnosis_group

  FROM
    `mimic-analysis-491010.mimic_results.icu_ml_dataset_rebuilt` d

  INNER JOIN (
    SELECT DISTINCT stay_id
    FROM
      `mimic-analysis-491010.mimic_results.icu_train_predictions_log`
  ) tr
  USING (stay_id)
),

train_log_predictions AS (

  SELECT
    stay_id,
    log_icu_los AS actual_log_los,
    predicted_log_icu_los

  FROM
    ML.PREDICT(
      MODEL `mimic-analysis-491010.mimic_results.icu_los_log_linear_compare_v1`,
      TABLE train_data
    )
),

smearing AS (

  SELECT
    AVG(
      EXP(actual_log_los - predicted_log_icu_los)
    ) AS smearing_factor

  FROM
    train_log_predictions
),

test_data AS (

  SELECT
    d.stay_id,
    d.icu_los_days AS actual_los_days,
    d.log_icu_los AS actual_log_los,
    d.diagnosis_group,
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
),

raw_predictions AS (

  SELECT
    stay_id,
    predicted_icu_los_days AS predicted_raw_los_days

  FROM
    ML.PREDICT(
      MODEL `mimic-analysis-491010.mimic_results.icu_los_raw_linear_compare_v1`,
      (
        SELECT
          stay_id,
          age_at_icu_admission,
          gender,
          admission_type,
          first_careunit,
          n_procedures,
          diagnosis_group
        FROM test_data
      )
    )
),

log_predictions AS (

  SELECT
    stay_id,
    predicted_log_icu_los

  FROM
    ML.PREDICT(
      MODEL `mimic-analysis-491010.mimic_results.icu_los_log_linear_compare_v1`,
      (
        SELECT
          stay_id,
          age_at_icu_admission,
          gender,
          admission_type,
          first_careunit,
          n_procedures,
          diagnosis_group
        FROM test_data
      )
    )
)

SELECT
  t.stay_id,
  t.actual_los_days,
  t.actual_log_los,
  t.diagnosis_group,

  r.predicted_raw_los_days,

  l.predicted_log_icu_los,

  EXP(l.predicted_log_icu_los)
    AS predicted_log_naive_days,

  EXP(l.predicted_log_icu_los) * s.smearing_factor
    AS predicted_log_smearing_days

FROM
  test_data t

INNER JOIN
  raw_predictions r
USING (stay_id)

INNER JOIN
  log_predictions l
USING (stay_id)

CROSS JOIN
  smearing s;
