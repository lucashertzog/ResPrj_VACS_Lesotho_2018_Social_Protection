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
  
  # Create a combined cell for the confidence interval
  conf_interval <- paste(conf_low_val, "–", conf_high_val)
  
  # Create a data frame with the extracted values
  data_girls <- data.frame(
    df_name = df_name,
    x = x_val,
    predicted = predicted_val,
    conf_low_val = conf_low_val,
    conf_high_val = conf_high_val,
    confidence_interval = conf_interval,
    stringsAsFactors = FALSE
  )
  
  # Add the data frame as rows to the combined_results data frame
  combined_results_girls <- rbind(combined_results_girls, data_girls)
  }
  return(combined_results_girls)
}