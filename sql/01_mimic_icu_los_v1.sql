-- ============================================
-- Query: ICU LOS Raw Extraction
-- Description: Extracts ICU stay information and calculates length of stay (LOS)
--              from MIMIC-IV ICU tables.
-- Author: Olga Karachyntseva
-- ============================================
SELECT
  subject_id,
  hadm_id,
  intime,
  outtime,
  TIMESTAMP_DIFF(outtime, intime, HOUR) AS los_hours
FROM `physionet-data.mimiciv_3_1_icu.icustays`
LIMIT 100;
