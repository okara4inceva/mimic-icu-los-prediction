-- ============================================
-- Query: Model Predictions
-- Description: Generates predicted ICU length of stay values using the
--              trained model on validation dataset.
-- Author: Olga Karachyntseva
-- ============================================
CREATE OR REPLACE TABLE `mimic-analysis-491010.mimic_results.los_model_v4_log_predictions_v1` AS
SELECT
  los_days,
  EXP(predicted_log_los) - 1 AS predicted_los,
  ABS(los_days - (EXP(predicted_log_los) - 1)) AS absolute_error
FROM ML.PREDICT(
  MODEL `mimic-analysis-491010.mimic_results.los_model_v4_log`,
  (
    SELECT *
    FROM `mimic-analysis-491010.mimic_results.icu_ml_dataset_features_v3_fixed`
    WHERE los_days BETWEEN 0 AND 30
  )
);
