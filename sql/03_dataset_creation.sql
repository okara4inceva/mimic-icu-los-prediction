-- ============================================
-- Query: Base ML Dataset Creation
-- Description: Combine cleaned ICU LOS data with patient demographics
-- to create the initial dataset for machine learning.
-- Source: MIMIC-IV (PhysioNet)
-- Note: Dataset identifiers are anonymized for public sharing.
-- Replace `project.dataset` with your own BigQuery environment.
-- Author: Olga Karachyntseva
-- ============================================

CREATE OR REPLACE TABLE `project.dataset.icu_ml_dataset_v1` AS

SELECT
  icu.subject_id,
  icu.hadm_id,
  icu.stay_id,

  -- Target variable
  icu.los_days,

  -- Demographic features
  pat.gender,

  -- Approximate age at ICU stay
  EXTRACT(YEAR FROM icu.intime) - pat.anchor_year + pat.anchor_age AS age_at_icu_admission

FROM `project.dataset.icu_los_clean_v1` AS icu

LEFT JOIN `project.dataset.patients` AS pat
  ON icu.subject_id = pat.subject_id;
