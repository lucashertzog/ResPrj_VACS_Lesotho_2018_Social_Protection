do_marginal_effects_combine_girls <- function(
    marginal_effects_list_girls
) {
combined_results_girls <- data.frame(
  df_name = character(),
  x = numeric(),
  predicted = numeric(),
  confidence_interval = character(),
  stringsAsFactors = FALSE
)

# Loop through each data frame in the marginal_effects_list_girls
for (i in seq_along(
  marginal_effects_list_girls)
){
  df_name <- names(marginal_effects_list_girls)[i]  # Get the data frame name
  df <- marginal_effects_list_girls[[i]]
  
  # Extract the required columns from the data frame
  x_val <- df$x
  predicted_val <- round(df$predicted * 100, 1)
  conf_low_val <- round(df$conf.low * 100, 1)
  conf_high_val <- round(df$conf.high * 100, 1)
  
  # Calculate the difference in predicted values and the confidence interval
  dif_pred <- predicted_val[x_val == 1] - predicted_val[x_val == 0]
  
  # Calculate the lower and upper bounds of the confidence interval
  dif_conf_low_val <- dif_pred - (df$std.error * 1.96)
  dif_conf_high_val <- dif_pred + (df$std.error * 1.96)
  
  # Create a combined cell for the confidence interval
  conf_interval <- paste(conf_low_val, "–", conf_high_val)
  
  # Create a data frame with the extracted values
  data_girls <- data.frame(
    Girls = df_name,
    Unprotected = ifelse(
      x_val == 0, 
      paste(predicted_val, " (", conf_interval, ")", sep = ""), 
      NA),
    SocialProtection = ifelse(
      x_val == 1, 
      paste(predicted_val, " (", conf_interval, ")", sep = ""), 
      NA),
    Diff.Prob. = paste(
      dif_pred,
      " (",
      round(dif_conf_low_val, 1),
      " – ",
      round(dif_conf_high_val, 1),
      ")",
      sep = ""
    ),
    stringsAsFactors = FALSE
  )
  
  data_girls$SocialProtection <- lead(
    ifelse(
      x_val == 1, 
      paste(predicted_val, " (", conf_interval, ")", sep = ""), NA)
  )
  data_girls <- na.omit(data_girls)
  
  # Add the data frame as rows to the combined_results data frame
  combined_results_girls <- rbind(combined_results_girls, data_girls)
  }
  return(combined_results_girls)
}