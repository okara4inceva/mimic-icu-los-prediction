-- ============================================
-- Query: Model Evaluation (MAE, RMSE, R²)
-- Description: Evaluate regression model performance using standard metrics:
-- Mean Absolute Error (MAE), Root Mean Squared Error (RMSE),
-- and R-squared (R²).
-- Source: MIMIC-IV (PhysioNet)
-- Note: Dataset identifiers are anonymized for public sharing.
-- Note: Model trained on log-transformed LOS to handle skewness
-- MAE for interpretability in days, RMSE to capture larger errors, and R² to assess overall explanatory power of the model.
-- Replace `project.dataset` with your own BigQuery environment.
-- Author: Olga Karachyntseva
-- ============================================

SELECT
  mean_absolute_error AS mae,
  mean_squared_error AS mse,
  SQRT(mean_squared_error) AS rmse,
  r2_score

FROM ML.EVALUATE(
  MODEL `project.dataset.los_model_v4_log`,
  (
    SELECT *
    FROM `project.dataset.icu_ml_dataset_features_v3_fixed`
    WHERE los_days BETWEEN 0 AND 30
  )
);
