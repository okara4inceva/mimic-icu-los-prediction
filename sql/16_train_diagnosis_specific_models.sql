-- Diagnosis-specific ICU LOS models
-- These models test whether training within broad diagnosis groups
-- improves prediction compared with the pooled raw-LOS model.
--
-- The same predefined training cohort is used.
-- Diagnosis group itself is not included as a feature because it is
-- constant within each diagnosis-specific model.

-- =========================================================
-- 1. INFECTIOUS AND PARASITIC DISEASES
-- Training stays: 9,001
-- =========================================================

CREATE OR REPLACE MODEL
  `mimic-analysis-491010.mimic_results.icu_los_raw_infectious_specific_v1`

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
  d.n_procedures

FROM
  `mimic-analysis-491010.mimic_results.icu_ml_dataset_rebuilt` d

INNER JOIN (
  SELECT DISTINCT stay_id
  FROM
    `mimic-analysis-491010.mimic_results.icu_train_predictions_log`
) tr
USING (stay_id)

WHERE
  d.diagnosis_group = 'Infectious and parasitic diseases';


-- =========================================================
-- 2. DISEASES OF THE CIRCULATORY SYSTEM
-- Training stays: 26,140
-- =========================================================

CREATE OR REPLACE MODEL
  `mimic-analysis-491010.mimic_results.icu_los_raw_circulatory_specific_v1`

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
  d.n_procedures

FROM
  `mimic-analysis-491010.mimic_results.icu_ml_dataset_rebuilt` d

INNER JOIN (
  SELECT DISTINCT stay_id
  FROM
    `mimic-analysis-491010.mimic_results.icu_train_predictions_log`
) tr
USING (stay_id)

WHERE
  d.diagnosis_group = 'Diseases of the circulatory system';
