-- ============================================
-- Query: Model Predictions
-- Description: Generate predicted ICU length of stay (LOS) using the trained
-- regression model and calculate prediction error.
-- Source: MIMIC-IV (PhysioNet)
-- Note: Dataset identifiers are anonymized for public sharing.
-- Evaluation metric: Mean Absolute Error (MAE)
-- Replace `project.dataset` with your own BigQuery environment.
-- Author: Olga Karachyntseva
-- ============================================

CREATE OR REPLACE TABLE `project.dataset.los_model_v4_log_predictions_v1` AS

SELECT
  los_days,

  -- Convert prediction back from log scale
  EXP(predicted_log_los) - 1 AS predicted_los,

  -- Absolute error
  ABS(los_days - (EXP(predicted_log_los) - 1)) AS absolute_error

FROM ML.PREDICT(
  MODEL `project.dataset.los_model_v4_log`,
  (
    SELECT *
    FROM `project.dataset.icu_ml_dataset_features_v3_fixed`
    WHERE los_days BETWEEN 0 AND 30
  )
);
