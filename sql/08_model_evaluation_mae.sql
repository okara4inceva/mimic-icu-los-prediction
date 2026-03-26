-- ============================================
-- Query: Model Evaluation (MAE)
-- Description: Calculates Mean Absolute Error (MAE) between predicted
--              and actual ICU length of stay values.
-- Author: Olga Karachyntseva
-- ============================================
SELECT
  AVG(absolute_error) AS real_mae,

  -- median replacement
  APPROX_QUANTILES(absolute_error, 2)[OFFSET(1)] AS median_absolute_error,

  MAX(absolute_error) AS max_absolute_error

FROM `mimic-analysis-491010.mimic_results.los_model_v4_log_predictions_v1`;
