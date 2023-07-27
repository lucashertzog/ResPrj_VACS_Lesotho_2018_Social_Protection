#' Compute the marginal effects and store them in a list
#'
#' @param outcome_var, pred_var, control_var, design 
#'
#' @return marginal_effects_list
#' @export
#'
#' @examples
do_marginal_effects <- function(
    outcome_var,
    pred_var,
    control_var,
    design
){
# Create an empty list to store the marginal effects data frames
marginal_effects_list <- list()

# Iterate over each outcome variable
for (outcome in outcome_var) {
  # Iterate over each predictor variable
  for (predictor in pred_var) {
    # Fit your model using the svyglm function (modify this code based on your specific modeling approach)
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
    
    # Compute p-values for the predictor variable
    coef_summary <- coef(summary(fit))
    p_values <- coef_summary[, "Pr(>|t|)"]
    
    # Perform Benjamini-Hochberg adjustment
    adjusted_p_values <- p.adjust(p_values, method = "BH")
    
    # Check if the predictor is significant (adjusted p-value <= 0.05)
    if (adjusted_p_values[predictor] <= 0.05) {
    
    # Use ggpredict to compute the marginal effects and store them in a data frame
    marginal_effects <- ggpredict(fit, terms = predictor, data = vacs_lso)
    
    # Add the data frame to the list
    marginal_effects_list[[paste(outcome, predictor, sep = "_")]] <- marginal_effects
    }
  }
}
return(marginal_effects_list)
}