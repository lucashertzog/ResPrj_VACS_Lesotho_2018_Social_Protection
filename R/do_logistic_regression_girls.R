#' Create a list of results with logistic regression results (subset girls)
#'
#' @param outcome_var 
#' @param pred_var 
#' @param stratified_control_var 
#' @param design_girls 
#' @param girls 
#'
#' @return results_list_girls
#' @export
#'
#' @examples
do_logistic_regression_girls <- function(
    outcome_var,
    pred_var,
    stratified_control_var,
    design_girls,
    girls
){ 
  
  # Create an empty list to store the results
  results_list_girls <- list()

  # Iterate over the outcome variables
  for (outcome in outcome_var) {
    # Create an empty data frame to store the results for the current outcome
    outcome_results_girls <- data.frame()
    # Iterate over the predictor variables
    for (predictor in pred_var) {
      # Fit the model
      model_girls <- svyglm(
        formula = paste(
          outcome,
          "~",
          predictor,
          "+",
          paste(stratified_control_var, collapse = "+")),
        design = design_girls,
        family = binomial(),
        data = girls
      )
      
      # Extract adjusted odds ratios and round to 2 decimal places
      odds_ratios <- round(exp(coef(model_girls)), 2)
      
      # Estimate the standard errors
      standard_error <- sqrt(diag(vcov(model_girls)))
      
      # Extract 95% confidence intervals and round to 2 decimal places
      ci <- confint(model_girls)
      ci <- round(ci, 2)
      
      # Calculate lower and upper bounds of confidence intervals based on odds ratio
      ci_lower <- exp(log(odds_ratios) - 1.96 * standard_error)
      ci_upper <- exp(log(odds_ratios) + 1.96 * standard_error)
      
      # Calculate z-scores and p-values
      z_scores <- coef(model_girls) / standard_error
      p_values <- 2 * (1 - pnorm(abs(z_scores)))
      
      # Perform Benjamini-Hochberg adjustment
      adjusted_p_values <- p.adjust(p_values, method = "BH")
      
      # Print in a simplified format
      p_values <- sprintf("%.4f", p_values)
      adjusted_p_values <- sprintf("%.4f", adjusted_p_values)
      ci_lower <- sprintf("%.2f", ci_lower)
      ci_upper <- sprintf("%.2f", ci_upper)
      
      
      # Format p-values with asterisks
      p_values_formatted <- ifelse(
        adjusted_p_values <= 0.001, paste0(adjusted_p_values, "***"),
        ifelse(adjusted_p_values <= 0.01, paste0(adjusted_p_values, "**"),
               ifelse(adjusted_p_values <= 0.05, paste0(adjusted_p_values, "*"),
                      adjusted_p_values)))
      
      # Create a data frame for the current predictor variable
      predictor_results_girls <- data.frame(odds_ratios,
                                      ci_lower,
                                      ci_upper,
                                      p_values_formatted,
                                      predictor = predictor)
      
      # Append the predictor results to the outcome results
      aOR <- paste0(odds_ratios, " (", ci_lower, " to ", ci_upper, ")")
      
      outcome_results_girls <- rbind(outcome_results_girls, predictor_results_girls)
      
      # Store the results for the current outcome in the list
    }
    results_list_girls[[outcome]] <- outcome_results_girls
  }
  return(results_list_girls)
}