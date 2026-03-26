-- ============================================
-- Query: Model Training (Log-Transformed LOS)
-- Description: Trains the final regression model using log-transformed
--              ICU length of stay to handle skewed distribution.
-- Author: Olga Karachyntseva
-- ============================================
CREATE OR REPLACE MODEL `mimic-analysis-491010.mimic_results.los_model_v4_log`
OPTIONS(
  model_type = 'linear_reg',
  input_label_cols = ['log_los']
) AS
SELECT
  LOG(los_days + 1) AS log_los,
  age,
  gender,
  first_careunit,
  admission_type,
  num_procedures,
  diagnosis_group
FROM `mimic-analysis-491010.mimic_results.icu_ml_dataset_features_v3_fixed`
WHERE los_days IS NOT NULL
  AND los_days BETWEEN 0 AND 30;
