-- ============================================
-- Query: Model Training (Log-Transformed LOS)
-- Description: Train a linear regression model using log-transformed ICU
-- length of stay (LOS) to address right-skewed distribution.
-- Source: MIMIC-IV (PhysioNet)
-- Note: Dataset identifiers are anonymized for public sharing.
-- Replace `project.dataset` with your own BigQuery environment.
-- Categorical features: gender, first_careunit, admission_type, diagnosis_group
-- Numerical features: age, num_procedures
-- Author: Olga Karachyntseva
-- ============================================

CREATE OR REPLACE MODEL `project.dataset.los_model_v4_log`

OPTIONS(
  model_type = 'linear_reg',
  input_label_cols = ['log_los']
) AS

SELECT
  -- Target variable (log-transformed LOS)
  LOG(los_days + 1) AS log_los,

  -- Features
  age,
  gender,
  first_careunit,
  admission_type,
  num_procedures,
  diagnosis_group

FROM `project.dataset.icu_ml_dataset_features_v3_fixed`

WHERE
  los_days IS NOT NULL
  AND los_days BETWEEN 0 AND 30;
