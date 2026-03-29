-- ============================================
-- Query: ICU LOS Raw Extraction
-- Description: Extract ICU stay records and compute length of stay (LOS) in hours
-- from MIMIC-IV ICU tables.
-- Source: MIMIC-IV (PhysioNet)
-- Note: Dataset identifiers are anonymized for public sharing.
-- Replace `project.dataset` with your own BigQuery environment.
-- Author: Olga Karachyntseva
-- ============================================
SELECT
  subject_id,
  hadm_id,
  intime,
  outtime,
  TIMESTAMP_DIFF(outtime, intime, HOUR) AS los_hours
FROM `project.dataset.icustays`
LIMIT 100;
