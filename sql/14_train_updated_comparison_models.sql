-- Train matched raw-LOS and log-LOS linear regression models
-- Both models use the same 75,489 training ICU stays
-- and the same predictor set.

-- =========================================================
-- 1. RAW LOS MODEL
-- =========================================================

CREATE OR REPLACE MODEL
  `mimic-analysis-491010.mimic_results.icu_los_raw_linear_compare_v1`

OPTIONS(
  model_type = 'linear_reg',
  input_label_cols = ['icu_los_days'],
  data_split_method = 'NO_SPLIT'
)

AS

SELECT
  d.icu_los_days,
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
USING (stay_id);


-- =========================================================
-- 2. LOG-TRANSFORMED LOS MODEL
-- =========================================================

CREATE OR REPLACE MODEL
  `mimic-analysis-491010.mimic_results.icu_los_log_linear_compare_v1`

OPTIONS(
  model_type = 'linear_reg',
  input_label_cols = ['log_icu_los'],
  data_split_method = 'NO_SPLIT'
)

AS

SELECT
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
USING (stay_id);
