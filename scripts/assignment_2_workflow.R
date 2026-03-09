#loading required packages
library(pROC)
library(ggplot2)
library(dplyr)
library(caret)

###TASK 1: 

#loading required dataset
install.packages('mlbench')
library(mlbench) 
data(PimaIndiansDiabetes)
df <- PimaIndiansDiabetes
str(df)
head(df)
summary(df) 
table(df$diabetes) 

#setting zero values to NA
df <- df %>%
  mutate(across(c(glucose, pressure, triceps, insulin, mass),
                ~ na_if(., 0)))
colSums(is.na(df))

#summary stats by diabetes 
summary_table <- df %>%
  group_by(diabetes) %>%
  summarise(
    pregnant = sprintf("%.1f (%.1f)", mean(pregnant, na.rm = TRUE), sd(pregnant, na.rm = TRUE)),
    glucose  = sprintf("%.1f (%.1f)", mean(glucose,  na.rm = TRUE), sd(glucose,  na.rm = TRUE)),
    pressure = sprintf("%.1f (%.1f)", mean(pressure, na.rm = TRUE), sd(pressure, na.rm = TRUE)),
    triceps  = sprintf("%.1f (%.1f)", mean(triceps,  na.rm = TRUE), sd(triceps,  na.rm = TRUE)),
    insulin  = sprintf("%.1f (%.1f)", mean(insulin,  na.rm = TRUE), sd(insulin,  na.rm = TRUE)),
    mass     = sprintf("%.1f (%.1f)", mean(mass,     na.rm = TRUE), sd(mass,     na.rm = TRUE)),
    pedigree = sprintf("%.1f (%.1f)", mean(pedigree, na.rm = TRUE), sd(pedigree, na.rm = TRUE)),
    age      = sprintf("%.1f (%.1f)", mean(age,      na.rm = TRUE), sd(age,      na.rm = TRUE)),
    n = n()
  )
summary_table 

#visualisations comapring distributions 
vars <- c("glucose", "mass", "age", "pressure", "insulin")

df_long <- df %>%
  select(diabetes, all_of(vars)) %>%
  pivot_longer(-diabetes, names_to = "Variable", values_to = "Value")

box_comparison <- ggplot(df_long, aes(x = diabetes, y = Value, fill = diabetes)) +
  geom_boxplot(na.rm = TRUE, outlier.alpha = 0.3) +
  facet_wrap(~ Variable, scales = "free_y") +
  labs(x = "", y = "Value") +
  theme_minimal(base_size = 12) +
  theme(legend.position = "none")
ggsave(file.path("C:/Users/amina/OneDrive/TAPM/semester 2/ADA/assignments/assignment 2",
            "boxplot_1.png"),box_comparison, width = 8, height = 5, dpi = 150)


###TASK 2: 

#fitting full logistic model  
df_clean <- na.omit(df)

model_f <- glm(diabetes ~ pregnant + glucose + pressure + triceps + insulin + mass + pedigree + age, data = df_clean, family = binomial)
summary(model_f)
OR_table <- exp(cbind(
  Estimate = coef(model_f),
  confint(model_f)
))
round(OR_table, 3)

#fitting reduced model 
model_r <- glm(diabetes ~ glucose + mass + pedigree, data = df_clean, family = binomial)
summary(model_r) 
OR_table <- exp(cbind(
  Estimate = coef(model_r),
  confint(model_r)
))
round(OR_table, 3)

#calculating AIC of models
AIC(model_f)
AIC(model_r) 
anova(model_f, model_r) 

###TASK3: 

#getting predicted values 
df_clean$pred_prob <- predict(model_f, type = "response")
head(df_clean$pred_prob) 

#creating binary predictions
threshold <- 0.5
df_clean$pred_class <- ifelse(df_clean$pred_prob >= threshold, "pos", "neg")
df_clean$pred_class <- factor(df_clean$pred_class,
                              levels = levels(df_clean$diabetes))

#creating confusion matrix
conf_table <- table(
  Predicted = df_clean$pred_class,
  Actual = df_clean$diabetes
)
print(conf_table)

#extracting counts
TN <- conf_table["neg", "neg"]
FP <- conf_table["pos", "neg"]
FN <- conf_table["neg", "pos"]
TP <- conf_table["pos", "pos"]

#calculating metrics
sensitivity <- TP / (TP + FN)
specificity <- TN / (TN + FP)
ppv <- TP / (TP + FP)
npv <- TN / (TN + FN)
accuracy <- (TP + TN) / sum(conf_table)

round(sensitivity, 3)
round(specificity, 3)
round(ppv, 3)
round(npv, 3)
round(accuracy, 3)

#TASK 4: 

#creating roc objects
roc_full <- roc(df_clean$diabetes,
                predict(model_f, type = "response"),
                levels = c("neg", "pos"),
                direction = "<")

roc_reduced <- roc(df_clean$diabetes,
                   predict(model_r, type = "response"),
                   levels = c("neg", "pos"),
                   direction = "<")

#extract coordinates for ggplot
roc_full_df <- data.frame(
  fpr = 1 - roc_full$specificities,
  tpr = roc_full$sensitivities,
  Model = "Full Model"
)

roc_reduced_df <- data.frame(
  fpr = 1 - roc_reduced$specificities,
  tpr = roc_reduced$sensitivities,
  Model = "Reduced Model"
)

roc_df <- rbind(roc_full_df, roc_reduced_df)

#plotting ROC
p_roc <- ggplot(roc_df, aes(x = fpr, y = tpr, colour = Model)) +
  geom_line(linewidth = 1.2) +
  geom_abline(intercept = 0, slope = 1, linetype = "dashed") +
  coord_equal() +
  labs(
    x = "False Positive Rate (1 - Specificity)",
    y = "True Positive Rate (Sensitivity)"
  ) +
  theme_minimal(base_size = 14)
print(p_roc)
ggsave(file.path("C:/Users/amina/OneDrive/TAPM/semester 2/ADA/assignments/assignment 2",
                 "p_roc.png"),p_roc, width = 8, height = 5, dpi = 150)

#calculating AUC and 95% CI
auc_full <- auc(roc_full)
ci_full  <- ci.auc(roc_full)
auc_full
ci_full

auc_reduced <- auc(roc_reduced)
ci_reduced  <- ci.auc(roc_reduced)
auc_reduced
ci_reduced

test_result <- roc.test(roc_full, roc_reduced, method = "delong")
test_result

#calculating youden's j
youden_full <- coords(roc_full,
                      x = "best",
                      best.method = "youden",
                      ret = c("threshold", "sensitivity", "specificity"),
                      transpose = FALSE)
youden_full

youden_reduced <- coords(roc_reduced,
                         x = "best",
                         best.method = "youden",
                         ret = c("threshold", "sensitivity", "specificity"),
                         transpose = FALSE)
youden_reduced
