# results_list_plot <- list()
# 
# # Iterate over the outcome variables
# for (outcome in outcome_var) {
#   # Create an empty data frame to store the results for the current outcome
#   outcome_results_plot <- data.frame()
#   
#   # Iterate over the predictor variables
#   for (predictor in pred_var) {
#     # Fit the model
#     fit_plot <- survey::svyglm(
#       formula = paste(
#         outcome,
#         "~",
#         predictor,
#         "+",
#         paste(control_var, collapse = " + ")),
#       design = design,
#       family = binomial(),
#       data = vacs_lso
#     )
#     outcome_results_plot <- rbind(outcome_results_plot, predictor_results)
#     
#   }
#   
#   # Store the results for the current outcome in the list
#   results_list_plot[[outcome]] <- outcome_results_plot
# }
# 
# 
# fit_plot <- svyglm(
#   formula = edu_enrol ~ sp_any + age + sex + hiv + orphan,
#   design = design,
#   family = binomial(),
#   data = vacs_lso)
# 
# plot(fit_plot, facet = TRUE)
