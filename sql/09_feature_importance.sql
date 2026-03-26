-- ============================================
-- Query: Feature Importance Analysis
-- Description: Extracts model weights to identify key drivers of ICU
--              length of stay.
-- Author: Olga Karachyntseva
-- ============================================
SELECT *
FROM ML.WEIGHTS(
  MODEL `mimic-analysis-491010.mimic_results.los_model_v4_log`
)
ORDER BY ABS(weight) DESC;
