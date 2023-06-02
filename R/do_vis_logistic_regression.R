viz_logistic_regression <- function(
    calc_logistic_regression,
    name = "viz_logistic_regression"
){

# Print the results for each outcome
for (outcome in outcome_variables) {
  cat(paste("Outcome:", outcome), "\n")
  print(knitr::kable(results_list[[outcome]], align = "c"))

  cat("\n")
}
}