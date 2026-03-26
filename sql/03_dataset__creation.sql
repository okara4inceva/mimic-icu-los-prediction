-- ============================================
-- Query: Base ML Dataset Creation
-- Description: Combines cleaned ICU LOS data with patient demographics
--              to create the initial dataset for machine learning.
-- Author: Olga Karachyntseva
-- ============================================
CREATE OR REPLACE TABLE `mimic-analysis-491010.mimic_results.icu_ml_dataset_v1` AS
SELECT
  icu.subject_id,
  icu.hadm_id,
  icu.stay_id,

  -- target
  icu.los_days,

  -- gender
  pat.gender,

  -- age calculation
  EXTRACT(YEAR FROM icu.intime) - pat.anchor_year + pat.anchor_age AS age

FROM `mimic-analysis-491010.mimic_results.icu_los_clean_v1` icu

LEFT JOIN `physionet-data.mimiciv_3_1_hosp.patients` pat
ON icu.subject_id = pat.subject_id;
