# ICU Length of Stay Prediction (MIMIC-IV)

## 📌 Project Overview
This project develops a machine learning pipeline to predict **ICU Length of Stay (LOS)** using clinical and administrative features from the MIMIC-IV dataset.

The objective is to support **hospital resource optimization**, including:
- ICU bed management
- Staffing planning
- Cost and operational efficiency

---

## 🎯 Business Relevance
Accurate prediction of ICU LOS can help healthcare providers:
- Reduce overcrowding and delays in care
- Improve patient flow and discharge planning
- Optimize allocation of critical care resources

---

## 📊 Dataset
- Source: **MIMIC-IV (PhysioNet)**
- Population: ICU patients
- Target variable: Length of Stay (LOS) in days
- Transformation: Log transformation applied to handle right-skewed distribution

---

## ⚙️ Methodology

### 1. Data Processing
- Extraction of ICU stays
- Cleaning of missing and invalid values
- Filtering LOS between 0 and 30 days

### 2. Feature Engineering
Key features include:
- Demographics: age, gender
- Clinical context: admission type, care unit
- Clinical complexity: number of procedures
- Diagnosis grouping

### 3. Model Development
- Model: Linear Regression (BigQuery ML)
- Target: Log-transformed LOS
- Rationale: Improve stability and predictive performance

### 4. Evaluation
- Metric: Mean Absolute Error (MAE)
- Evaluation performed on predicted vs actual LOS

### 5. Model Interpretation
- Feature importance analysis to identify key drivers of ICU stay duration

---

## 🧠 Key Insight
Applying log transformation to LOS improves model performance by addressing skewness commonly observed in ICU stay distributions.

---

## 📁 Project Structure

```text
sql/
├── 01_extract_data.sql
├── 02_clean_data.sql
├── 03_build_dataset.sql
├── 04_engineer_features.sql
├── 05_finalize_features.sql
├── 06_train_model_log.sql
├── 07_generate_predictions.sql
├── 08_evaluate_model_mae.sql
├── 09_analyze_feature_importance.sql```

## 🛠️ Tools & Technologies
Google BigQuery ML
SQL
MIMIC-IV clinical dataset

## 🚀 Future Improvements
Compare with advanced models (e.g., XGBoost, Random Forest)
Include time-series clinical variables (vitals, labs)
External validation on other hospital datasets
Integration into hospital dashboards (e.g., Power BI)

## 👩‍💻 Author
Olga Karachyntseva
Health Economics & Data Analytics | Healthcare AI/ML
