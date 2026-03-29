-- ============================================
-- Query: Final Feature Engineering (v3_fixed)
-- Description: Add diagnosis-group information to the engineered feature set
-- to improve model performance and clinical interpretability.
-- Source: MIMIC-IV (PhysioNet)
-- Note: Dataset identifiers are anonymized for public sharing.
-- Replace `project.dataset` with your own BigQuery environment.
-- Author: Olga Karachyntseva
-- ============================================

CREATE OR REPLACE TABLE `project.dataset.icu_ml_dataset_features_v3_fixed` AS

SELECT
  base.*,
  diag.diagnosis_group

FROM `project.dataset.icu_ml_dataset_features_v2` AS base

LEFT JOIN `project.dataset.diagnosis_clean_v1` AS diag
  ON base.hadm_id = diag.hadm_id;
