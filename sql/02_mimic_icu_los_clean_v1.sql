-- ============================================
-- Query: ICU LOS Cleaning
-- Description: Cleans ICU length of stay data by removing invalid values,
--              handling missing data, and preparing LOS for analysis.
-- Author: Olga Karachyntseva
-- ============================================
CREATE OR REPLACE TABLE `mimic-analysis-491010.mimic_results.icu_los_clean_v1` AS
SELECT
  subject_id,
  hadm_id,
  stay_id,
  intime,
  outtime,
  TIMESTAMP_DIFF(outtime, intime, HOUR) AS los_hours,
  ROUND(TIMESTAMP_DIFF(outtime, intime, HOUR) / 24.0, 2) AS los_days
FROM `physionet-data.mimiciv_3_1_icu.icustays`
WHERE
  intime IS NOT NULL
  AND outtime IS NOT NULL
  AND TIMESTAMP_DIFF(outtime, intime, HOUR) > 0
  AND TIMESTAMP_DIFF(outtime, intime, HOUR) < 24 * 30;
