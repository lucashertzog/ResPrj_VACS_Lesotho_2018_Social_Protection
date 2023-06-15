table <- combined_results_wide %>%
  kbl(caption = "Summary of multivariable associations between provision and outcomes.") %>%
  kable_classic(full_width = FALSE, html_font = "Times New Roman")

fit_test <- survey::svyglm(edu_enrol ~ sp_any + age + sex + hiv + orphan,
  design = design,
  family = binomial(),
  data = vacs_lso
)

ggpredict(fit_test, "sp_any")
ggemmeans(fit_test, terms = "sp_any")

marginaleffects::predictions(fit_test, by ="sp_any")




missing_values <- complete.cases(fit_test$model$edu_enrol, 
                                 fit_test$model$sp_any, 
                                 fit_test$model$age,
                                 fit_test$model$sex,
                                 fit_test$model$hiv,
                                 fit_test$model$orphan)

non_missing_edu_enrol <- complete.cases(fit_test$model$edu_enrol)
design_subset <- fit_test$survey.design[non_missing_edu_enrol, ]
edu_enrol_subset <- fit_test$model$edu_enrol[non_missing_edu_enrol]
data <- data.frame(edu_enrol = edu_enrol_subset, 
                   sp_any = fit_test$model$sp_any[non_missing_edu_enrol],
                   age = fit_test$model$age[non_missing_edu_enrol],
                   sex = fit_test$model$sex[non_missing_edu_enrol],
                   hiv = fit_test$model$hiv[non_missing_edu_enrol],
                   orphan = fit_test$model$orphan[non_missing_edu_enrol]
)

# Obtain average marginal effects
marginal_effects <- margins::margins(fit_test, subset = non_missing_edu_enrol, design = design_subset, data = data)

# Convert average marginal effects to percentage
marginal_effects_percent <- marginal_effects * 100

# Set the variable labels for 0 and 1
variable_labels <- c("Not SP", "SP")

# Subset the marginal effects for sp_any = 0 and sp_any = 1
marginal_effects_subset <- marginal_effects_percent[marginal_effects_percent$sp_any %in% c(0, 1), ]

# Print the subsetted marginal effects
print(marginal_effects_subset[, c("sp_any", "dydx_sp_any")], labels = variable_labels)



# Subset the data to non-missing observations
fit_test_subset <- data[missing_values, ]

missing_val_d <- complete.cases(fit_test$survey.design$cluster)

design_subset <- data[missing_val_d, ]

table(vacs_lso$sp_any, vacs_lso$age, useNA = "ifany")
### descriptives table

t_gt <- as_gt(t)

show_header_names(t)
vacs_lso <- as.numeric(vacs_lso)


  # modify_spanning_header(c("stat_1", "stat_2") ~ "**Social Protection**")

### logit table
tbl_regression(fit, exponentiate = TRUE)


# Create an empty list to store the results
results_list <- list()

# Iterate over the outcome variables
for (outcome in outcome_var) {
  # Create an empty data frame to store the results for the current outcome
  outcome_results <- data.frame()
  
  # Iterate over the predictor variables
  for (predictor in pred_var) {
    # Fit the model
    fit <- survey::svyglm(
      formula = paste(
        outcome,
        "~",
        predictor,
        "+",
        paste(control_var, collapse = " + ")),
      design = design,
      family = binomial(),
      data = vacs_lso
    )
  result <- broom::tidy(fit)
  outcome_results <- bind_rows(outcome_results, result)
  }
  # Store the results for the current outcome in the list
  results_list[[outcome]] <- outcome_results
}

tbl <- 
  c("cyl", "cyl + disp") %>%            # vector of covariates
  map(
    ~ paste("mpg", .x, sep = " ~ ") %>% # build character formula
      as.formula() %>%                  # convert to proper formula
      lm(data = mtcars) %>%             # build linear regression model
      tbl_regression()                  # display table with gtsummary
  ) %>%
  # merge tables into single table
  tbl_merge(
    tab_spanner = c("**Univariate**", "**Multivariable**")
  )




