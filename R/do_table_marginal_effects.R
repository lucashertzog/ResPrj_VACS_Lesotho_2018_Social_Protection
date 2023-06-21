#' Title
#'
#' @param marginal_effects_list
#'
#' @return
#' @export
#'
#' @examples

do_table_marginal_effects <- function(
    marginal_effects_list,
    marginal_effects_list_girls,
    marginal_effects_list_boys
) {
  # Create an empty data frame to store the combined results
  combined_results <- data.frame(
    df_name = character(),
    x = numeric(),
    predicted = numeric(),
    confidence_interval = character(),
    stringsAsFactors = FALSE
  )
  combined_results_girls <- data.frame(
    df_name = character(),
    x = numeric(),
    predicted = numeric(),
    confidence_interval = character(),
    stringsAsFactors = FALSE
  )
  
  combined_results_boys <- data.frame(
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
      conf_low_val = conf_low_val,
      conf_high_val = conf_high_val,
      confidence_interval = conf_interval,
      stringsAsFactors = FALSE
    )

    # Add the data frame as rows to the combined_results data frame
    combined_results <- rbind(combined_results, data)
  }
  
  # Loop through each data frame in the marginal_effects_list_girls
  for (i in seq_along(
    marginal_effects_list_girls
  )
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
  
  # Loop through each data frame in the marginal_effects_list_boys
  for (i in seq_along(
    marginal_effects_list_boys
  )
  ){
    df_name <- names(marginal_effects_list_boys)[i]  # Get the data frame name
    df <- marginal_effects_list_boys[[i]]
    
    # Extract the required columns from the data frame
    x_val <- df$x
    predicted_val <- round(df$predicted * 100, 1)
    conf_low_val <- round(df$conf.low * 100, 1)
    conf_high_val <- round(df$conf.high * 100, 1)
    
    # Create a combined cell for the confidence interval
    conf_interval <- paste(conf_low_val, "–", conf_high_val)
    
    # Create a data frame with the extracted values
    data_boys <- data.frame(
      df_name = df_name,
      x = x_val,
      predicted = predicted_val,
      conf_low_val = conf_low_val,
      conf_high_val = conf_high_val,
      confidence_interval = conf_interval,
      stringsAsFactors = FALSE
    )
    
    # Add the data frame as rows to the combined_results data frame
    combined_results_boys <- rbind(combined_results_girls, data_boys)
  }

  # Create a flextable object for the combined results
  table <- flextable::flextable(combined_results)
  table_girls <- flextable::flextable(combined_results_girls)
  table_boys <- flextable::flextable(combined_results_boys)
  
  # Format table appearance
  table <- flextable::theme_apa(table)
  table <- flextable::line_spacing(table, space = 1, part = "all")
  table <- flextable::set_table_properties(table, layout = "autofit")
  table <- flextable::fontsize(table, size = 10)
  
  table_girls <- flextable::theme_apa(table_girls)
  table_girls <- flextable::line_spacing(table_girls, space = 1, part = "all")
  table_girls <- flextable::set_table_properties(table_girls, layout = "autofit")
  table_girls <- flextable::fontsize(table_girls, size = 10)
  
  table_boys <- flextable::theme_apa(table_boys)
  table_boys <- flextable::line_spacing(table_boys, space = 1, part = "all")
  table_boys <- flextable::set_table_properties(table_boys, layout = "autofit")
  table_boys <- flextable::fontsize(table_boys, size = 10)

  # Create a Word document and add the tables
  doc <- officer::read_docx()
  doc <- flextable::body_add_flextable(doc, table)
  doc <- flextable::body_add_flextable(doc, table_girls)
  doc <- flextable::body_add_flextable(doc, table_boys)
  
  # Save the table to a Word file
  file_name <- file.path(config$outdir_lso, config$outdat_marg)
  print(doc, target = file_name)
}
