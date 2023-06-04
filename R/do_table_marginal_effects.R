#' Title
#'
#' @param marginal_effects_list
#'
#' @return
#' @export
#'
#' @examples

do_table_marginal_effects <- function(
    marginal_effects_list
) {
  # Create an empty data frame to store the combined results
  combined_results <- data.frame(
    df_name = character(),
    x = numeric(),
    predicted = numeric(),
    confidence_interval = character(),
    stringsAsFactors = FALSE
  )
  
  # Loop through each data frame in the marginal_effects_list
  for (i in seq_along(
    marginal_effects_list
    )
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
      confidence_interval = conf_interval,
      stringsAsFactors = FALSE
    )
    
    # Add the data frame as rows to the combined_results data frame
    combined_results <- rbind(combined_results, data)
  }
  
  # Create a Word document
  doc <- officer::read_docx()
  
  # Create a flextable object for the combined results
  table <- flextable::flextable(combined_results)
  
  # Format table appearance
  table <- flextable::theme_booktabs(table)  # Apply booktabs theme
  
  # Add borders to the table
  table <- flextable::border_remove(table)
  
  # Add the table to the Word document
  doc <- flextable::body_add_flextable(doc, table)
  
  # Save the table to a Word file
  file_name <- file.path(config$outdir_lso, "marginal_effects_table.docx")
  print(doc, target = file_name)
}
