-- ============================================
-- Query: Feature Importance Analysis
-- Description: Extract model coefficients to identify key drivers of ICU
-- length of stay (LOS) from the trained regression model.
-- Source: MIMIC-IV (PhysioNet)
-- Note: Dataset identifiers are anonymized for public sharing.
-- Note: Positive weights indicate increase in LOS, negative weights indicate decrease
-- Replace `project.dataset` with your own BigQuery environment.
-- Author: Olga Karachyntseva
-- ============================================

SELECT
  processed_input,
  weight

FROM ML.WEIGHTS(
  MODEL `project.dataset.los_model_v4_log`
)

ORDER BY ABS(weight) DESC;
