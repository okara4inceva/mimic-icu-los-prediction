-- Estimate Duan's smearing factor from training residuals only
-- Used to correct retransformation bias from log(LOS) back to days

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

  INNER JOIN
    `mimic-analysis-491010.mimic_results.icu_train_predictions_log` t
  USING (stay_id)
),

train_predictions AS (
  SELECT
    stay_id,
    log_icu_los AS actual_log_los,
    predicted_log_icu_los

  FROM
    ML.PREDICT(
      MODEL `mimic-analysis-491010.mimic_results.icu_los_log_linear_compare_v1`,
      TABLE train_data
    )
)

SELECT
  COUNT(*) AS n_training_stays,

  AVG(
    EXP(actual_log_los - predicted_log_icu_los)
  ) AS duan_smearing_factor

FROM
  train_predictions;
