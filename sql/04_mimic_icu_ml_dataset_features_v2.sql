-- ============================================
-- Query: Feature Engineering v2
-- Description: Adds clinical and operational features including ICU type,
--              admission type, and basic patient characteristics.
-- Author: Olga Karachyntseva
-- ============================================
CREATE OR REPLACE TABLE `mimic-analysis-491010.mimic_results.icu_ml_dataset_features_v2` AS
SELECT
  icu.subject_id,
  icu.hadm_id,
  icu.stay_id,

  -- target
  icu.los_days,

  -- demographics
  icu.age,
  icu.gender,

  -- ICU info
  icu2.first_careunit,

  -- admission
  adm.admission_type,

  -- severity proxy
  COUNT(proc.icd_code) AS num_procedures

FROM `mimic-analysis-491010.mimic_results.icu_ml_dataset_clean_v1` icu

LEFT JOIN `physionet-data.mimiciv_3_1_icu.icustays` icu2
  ON icu.stay_id = icu2.stay_id

LEFT JOIN `physionet-data.mimiciv_3_1_hosp.admissions` adm
  ON icu.hadm_id = adm.hadm_id

LEFT JOIN `physionet-data.mimiciv_3_1_hosp.procedures_icd` proc
  ON icu.hadm_id = proc.hadm_id

GROUP BY
  icu.subject_id,
  icu.hadm_id,
  icu.stay_id,
  icu.los_days,
  icu.age,
  icu.gender,
  icu2.first_careunit,
  adm.admission_type;
