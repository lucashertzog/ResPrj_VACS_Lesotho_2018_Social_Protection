do_marginal_effects_combine <- function(
    marginal_effects_list
) {
# Create an empty data frame to store the combined results
combined_results <- data.frame(
  df_name = character(),
  x = numeric(),
  predicted = numeric(),
  predicted_0 = numeric(),
  predicted_1 = numeric(),
  confidence_interval = character(),
  stringsAsFactors = FALSE
)

# Loop through each data frame in the marginal_effects_list
for (i in seq_along(
  marginal_effects_list)
){
  df_name <- names(marginal_effects_list)[i]  # Get the data frame name
  df <- marginal_effects_list[[i]]
  
  # Extract the required columns from the data frame
  x_val <- df$x
  predicted_val <- round(df$predicted * 100, 1)
  conf_low_val <- round(df$conf.low * 100, 1)
  conf_high_val <- round(df$conf.high * 100, 1)
  
  # Create a combined cell for the confidence interval
  conf_interval <- paste(conf_low_val, "–", conf_high_val)
  
  # Create a data frame with the extracted values
  data <- data.frame(
    df_name = df_name,
    x = x_val,
    predicted = predicted_val,
    predicted_0 = ifelse(x_val == 0, predicted_val, NA),
    predicted_1 = ifelse(x_val == 1, predicted_val, NA),
    conf_low_val = conf_low_val,
    conf_high_val = conf_high_val,
    confidence_interval = conf_interval,
    stringsAsFactors = FALSE
  )
  
  # Add the data frame as rows to the combined_results data frame
  combined_results <- rbind(combined_results, data)
}
return(combined_results)
}