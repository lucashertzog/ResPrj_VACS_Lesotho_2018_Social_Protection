#' Create a list of results with logistic regression results
#'
#' @param design
#'
#' @return results_list
#' @export
#'
#' @examples

do_logistic_regression <- function(
    outcome_var,
    pred_var,
    control_var,
    design
){ 
  
  # Create an empty list to store the results
  results_list <- list()
  # Iterate over the outcome variables
  for (outcome in outcome_var) {
    # Create an empty data frame to store the results for the current outcome
    outcome_results <- data.frame()
    # Iterate over the predictor variables
    for (predictor in pred_var) {
      # Fit the model
      model <- svyglm(
        formula = paste(
          outcome,
          "~",
          predictor,
          "+",
          paste(control_var, collapse = "+")),
        design = design,
        family = binomial(),
        data = vacs_lso
      )
      
      # Extract the variables used in the formula
      used_vars <- all.vars(formula(model))
      
      # Subset the data for only used variables
      sub_data <- design$variables[, used_vars, drop = FALSE]
      
      n <- sum(complete.cases(sub_data))
      
      
      # Extract adjusted odds ratios and round to 2 decimal places
      odds_ratios <- round(exp(coef(model)), 2)
      
      # Estimate the standard errors
      standard_error <- sqrt(diag(vcov(model)))
      
      # Extract 95% confidence intervals and round to 2 decimal places
      ci <- confint(model)
      ci <- round(ci, 2)
      
      # Calculate lower and upper bounds of confidence intervals based on odds ratio
      ci_lower <- exp(log(odds_ratios) - 1.96 * standard_error)
      ci_upper <- exp(log(odds_ratios) + 1.96 * standard_error)
      
      # Calculate z-scores and p-values
      z_scores <- coef(model) / standard_error
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
      predictor_results <- data.frame(odds_ratios,
                                      ci_lower,
                                      ci_upper,
                                      p_values_formatted,
                                      predictor = predictor,
                                      n = n)
      
      # Append the predictor results to the outcome results
      aOR <- paste0(odds_ratios, " (", ci_lower, " to ", ci_upper, ")")
      
      outcome_results <- rbind(outcome_results, predictor_results)
      
      # Store the results for the current outcome in the list
    }
    results_list[[outcome]] <- outcome_results
  }
  return(results_list)
}