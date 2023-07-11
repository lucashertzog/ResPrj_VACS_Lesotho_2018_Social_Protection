do_marginal_effects_combine_boys <- function(
    marginal_effects_list_boys
){
  combined_results_boys <- data.frame(
    df_name = character(),
    x = numeric(),
    predicted = numeric(),
    confidence_interval = character(),
    rel_dif = character(),
    stringsAsFactors = FALSE
  )
  # Loop through each data frame in the marginal_effects_list_boys
  for (i in seq_along(
    marginal_effects_list_boys)
  ){
    df_name <- names(marginal_effects_list_boys)[i]  # Get the data frame name
    df <- marginal_effects_list_boys[[i]]
    
    # Extract the required columns from the data frame
    x_val <- df$x
    predicted_val <- round(df$predicted * 100, 1)
    conf_low_val <- round(df$conf.low * 100, 1)
    conf_high_val <- round(df$conf.high * 100, 1)
    
    # Calculate the difference in predicted values and the confidence interval
    # Absolute change
    dif_pred <- predicted_val[x_val == 1] - predicted_val[x_val == 0]
    
    # Relative change
    rel_dif <- predicted_val[x_val == 1] * 100 / predicted_val[x_val == 0] - 100
    
    # # Calculate the lower and upper bounds of the confidence interval
    # dif_conf_low_val <- dif_pred - (df$std.error * 1.96)
    # dif_conf_high_val <- dif_pred + (df$std.error * 1.96)
    
    # Create a combined cell for the confidence interval
    conf_interval <- paste(conf_low_val, "–", conf_high_val)
    
    # Create a data frame with the extracted values
    data_boys <- data.frame(
      Boys = df_name,
      Unprotected = ifelse(
        x_val == 0, 
        paste(predicted_val, " (", conf_interval, ")", sep = ""), 
        NA),
      SocialProtection = ifelse(
        x_val == 1, 
        paste(predicted_val, " (", conf_interval, ")", sep = ""), 
        NA),
      Diff.Prob. =dif_pred,
      Rel.Diff. = round(rel_dif, 1),
      stringsAsFactors = FALSE
    )
    
    data_boys$SocialProtection <- lead(
      ifelse(
        x_val == 1, 
        paste(predicted_val, " (", conf_interval, ")", sep = ""), NA)
    )
    data_boys <- na.omit(data_boys)
    
    # Add the data frame as rows to the combined_results data frame
    combined_results_boys <- rbind(combined_results_boys, data_boys)
  }
  return(combined_results_boys)
}