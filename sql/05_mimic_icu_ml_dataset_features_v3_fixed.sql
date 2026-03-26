-- ============================================
-- Query: Feature Engineering Final (v3_fixed)
-- Description: Final feature set including number of procedures and
--              diagnosis-related variables for improved model performance.
-- Author: Olga Karachyntseva
-- ============================================
CREATE OR REPLACE TABLE `mimic-analysis-491010.mimic_results.icu_ml_dataset_features_v3_fixed` AS
SELECT
  base.*,
  diag.diagnosis_group
FROM `mimic-analysis-491010.mimic_results.icu_ml_dataset_features_v2` base
LEFT JOIN `mimic-analysis-491010.mimic_results.diagnosis_clean_v1` diag
  ON base.hadm_id = diag.hadm_id;
