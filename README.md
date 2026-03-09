# Logistic-Regression-Analysis-of-the-Pima-Indians-Diabetes-Dataset

This repository contains an analysis of the Pima Indians Diabetes dataset using logistic regression modelling in R. The project was completed as part of the Advanced Data Analytics module in the MSc Technologies and Analytics in Precision Medicine.

The analysis investigates clinical predictors of diabetes and evaluates classification performance using statistical modelling and ROC analysis.

---
## Project Overview

The dataset originates from a study conducted by the National Institute of Diabetes and Digestive and Kidney Diseases and contains diagnostic measurements from 768 Pima Indian women aged 21 years or older living near Phoenix, Arizona.

The aim of the analysis was to:

- Identify clinical variables associated with diabetes

- Build logistic regression models to predict diabetes status

- Evaluate model performance using classification metrics and ROC curves

- Logistic regression was selected because the outcome variable (diabetes status) is binary. 

Research Question: 

Which clinical factors are associated with diabetes in the Pima Indian population, and how accurately can diabetes status be predicted using logistic regression models? 

---
## Dataset

The dataset contains 768 observations with 8 predictor variables and a binary outcome variable.

| Variable | Description |
|---------|-------------|
| pregnant | Number of pregnancies |
| glucose | Plasma glucose concentration |
| pressure | Diastolic blood pressure |
| triceps | Triceps skinfold thickness |
| insulin | Serum insulin |
| mass | Body mass index (BMI) |
| pedigree | Diabetes pedigree function |
| age | Age of individual |
| diabetes | Diabetes status (pos/neg) |

Key characteristics:

- 768 individuals
- 268 diabetes-positive
- 500 diabetes-negative
- Moderately imbalanced classification problem
---

## Methods

The analysis was conducted in R using the following packages:

- mlbench
- pROC
- dplyr
- caret

The workflow consisted of four main stages:

### 1. Exploratory Data Analysis

Initial exploratory analysis examined differences in predictor distributions between individuals with and without diabetes.

Steps included:

- Converting physiologically impossible zero values to missing values
- Removing incomplete observations
- Calculating summary statistics by diabetes status
- Visualising distributions using boxplots

Key predictors visualised:

- glucose
- BMI (mass)
- age
- pressure
- insulin

These plots help assess whether predictors show separation between diabetes groups.

### 2. Logistic Regression Model Building

Two logistic regression models were fitted:

Full Model:
diabetes ~ pregnant + glucose + pressure + triceps + insulin + mass + pedigree + age

Reduced Model:
diabetes ~ glucose + mass + pedigree

Models were compared using:

- Akaike Information Criterion (AIC)
- Likelihood ratio test

The full model provided better overall model fit and was therefore selected as the final model. 

Odds Ratio Interpretation of Key Predictors Identified:

| Predictor | Interpretation |
|-----------|---------------|
| Glucose | Each unit increase increases diabetes odds by ~4% |
| BMI (mass) | Each unit increase increases diabetes odds by ~7% |
| Pedigree | Strong association with diabetes risk |

The diabetes pedigree function showed the largest effect, reflecting genetic predisposition.

### 3. Classification Performance

Predicted probabilities from the final model were converted into binary predictions using a 0.5 classification threshold.

A confusion matrix was generated to evaluate model performance.

| Metric | Value |
|------|------:|
| Sensitivity | 56.9% |
| Specificity | 88.9% |
| Accuracy | 78.3% |
| Positive Predictive Value (PPV) | 71.8% |
| Negative Predictive Value (NPV) | 80.6% |

The model demonstrates higher specificity than sensitivity, meaning it performs better at identifying non-diabetic individuals. 

### 4. ROC Curve and AUC Analysis

Receiver Operating Characteristic (ROC) curves were used to evaluate model discrimination.

Two models were compared:

| Model | AUC |
|------|----:|
| Full Model | 0.86 |
| Reduced Model | 0.84 |

An AUC of ~0.86 indicates good discrimination, meaning the model can distinguish between diabetes-positive and diabetes-negative individuals with high probability. 

Youden’s J statistic was used to identify optimal classification thresholds balancing sensitivity and specificity.

## Key Results

The analysis demonstrated that:

- Glucose, BMI, and pedigree function are strong predictors of diabetes
- Logistic regression models can achieve good discrimination (AUC ≈ 0.86)
- The model shows strong specificity but moderate sensitivity
- Lower classification thresholds may improve detection of diabetes cases
- These findings highlight the importance of metabolic and genetic factors in diabetes risk. 

## Running the Analysis

Clone the repository:
git clone https://github.com/aminat13/<repository-name>

Open the R script:
scripts/assignment_2_workflow.R

Run the script to reproduce:

- exploratory analysis
- logistic regression modelling
- classification metrics
- ROC curve analysis

## Skills Demonstrated

This project demonstrates practical skills in:

- Logistic regression modelling
- Binary classification
- Model comparison using AIC and likelihood ratio tests
- ROC curve analysis and AUC interpretation
- Confusion matrix evaluation
- Data visualisation using ggplot2
- Reproducible statistical analysis in R

---
# References

Chandrasekaran, P., & Weiskirchen, R. (2024).
The Role of Obesity in Type 2 Diabetes Mellitus—An Overview.
International Journal of Molecular Sciences, 25(3), 1882.
https://doi.org/10.3390/ijms25031882

Knowler, W. C., Bennett, P. H., Hamman, R. F., & Miller, M. (1978).
Diabetes Mellitus in the Pima Indians: Genetic and Evolutionary Considerations.
American Journal of Physical Anthropology.

---
Pima Indians Diabetes Dataset – National Institute of Diabetes and Digestive and Kidney Diseases (NIDDK).
Available via the mlbench package in R.
