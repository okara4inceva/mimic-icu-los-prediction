-- ============================================
-- Query: Feature Engineering v2
-- Description: Add clinical and operational features including ICU type,
-- admission type, and a procedure-based severity proxy.
-- Source: MIMIC-IV (PhysioNet)
-- Note: Dataset identifiers are anonymized for public sharing.
-- Replace `project.dataset` with your own BigQuery environment.
-- Author: Olga Karachyntseva
-- ============================================

CREATE OR REPLACE TABLE `project.dataset.icu_ml_dataset_features_v2` AS

SELECT
  icu.subject_id,
  icu.hadm_id,
  icu.stay_id,

  -- Target variable
  icu.los_days,

  -- Demographic features
  icu.age,
  icu.gender,

  -- ICU context
  icu_src.first_careunit,

  -- Admission context
  adm.admission_type,

  -- Procedure-based severity proxy
  COUNT(proc.icd_code) AS num_procedures

FROM `project.dataset.icu_ml_dataset_clean_v1` AS icu

LEFT JOIN `project.dataset.icustays` AS icu_src
  ON icu.stay_id = icu_src.stay_id

LEFT JOIN `project.dataset.admissions` AS adm
  ON icu.hadm_id = adm.hadm_id

LEFT JOIN `project.dataset.procedures_icd` AS proc
  ON icu.hadm_id = proc.hadm_id

GROUP BY
  icu.subject_id,
  icu.hadm_id,
  icu.stay_id,
  icu.los_days,
  icu.age,
  icu.gender,
  icu_src.first_careunit,
  adm.admission_type;
