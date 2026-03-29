-- ============================================
-- Query: ICU LOS Cleaning
-- Description: Clean ICU length of stay data by removing invalid values,
-- handling missing timestamps, and preparing LOS for analysis.
-- Source: MIMIC-IV (PhysioNet)
-- Note: Dataset identifiers are anonymized for public sharing.
-- Replace `project.dataset` with your own BigQuery environment.
-- Author: Olga Karachyntseva
-- ============================================

CREATE OR REPLACE TABLE `project.dataset.icu_los_clean_v1` AS

SELECT
  subject_id,
  hadm_id,
  stay_id,
  intime,
  outtime,
  TIMESTAMP_DIFF(outtime, intime, HOUR) AS los_hours,
  ROUND(TIMESTAMP_DIFF(outtime, intime, HOUR) / 24.0, 2) AS los_days

FROM `project.dataset.icustays`

WHERE
  intime IS NOT NULL
  AND outtime IS NOT NULL
  AND TIMESTAMP_DIFF(outtime, intime, HOUR) > 0
  AND TIMESTAMP_DIFF(outtime, intime, HOUR) < 24 * 30;
