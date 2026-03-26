-- ============================================
-- Query: Model Evaluation (MAE, RMSE, R²)
-- Description: Evaluates model performance using multiple regression metrics.
-- Note: Project and dataset names are anonymized for sharing.
-- Author: Olga Karachyntseva
-- ============================================
-- Example query (project name anonymized for sharing)
SELECT
  mean_absolute_error AS mae,
  mean_squared_error AS mse,
  SQRT(mean_squared_error) AS rmse,
  r2_score
FROM
  ML.EVALUATE(
    MODEL `your_project.your_dataset.model_name`,
    (
      SELECT * FROM `your_project.your_dataset.test_set`
    )
  );
