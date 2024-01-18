#' Create a table with regression outputs
#'
#' @param results_list, pred_var
#'
#' @return combined_results_wide
#' @export table_odds.docx
#'
#' @examples

do_table_regressions <- function(
    results_list,
    results_list_girls,
    results_list_boys,
    pred_var

){

  tar_load(calc_logistic_regression)
  tar_load(calc_logistic_regression_girls)
  tar_load(calc_logistic_regression_boys)
  tar_load(dat_pred_var)
  results_list = calc_logistic_regression
  results_list_girls = calc_logistic_regression_girls
  results_list_boys = calc_logistic_regression_boys
  pred_var = dat_pred_var
  
# List of data frame names and corresponding labels
  df_labels <- data.frame(
    df_name = c("edu_enrol",
                "edu_attainment",
                "edu_ecostr_work",
                "srh_condom_use",
                "srh_multiple_partners",
                "srh_transactional",
                "srh_child_marriage"),
    label = c("Education - Enrollment",
              "Education - Attainment",
              "Engaged in any paid work",
              "Consistent Condom Use",
              "Multiple Sexual Partners",
              "Transactional Sex",
              "Child Marriage")
  )
  
  # Create empty data frames to store the combined results
  combined_results <- data.frame(
    Rownames = character(),
    Girls_Boys = character(),
    Odds_Ratios = numeric(),
    CI_Lower = numeric(),
    CI_Upper = numeric(),
    p_values = character(),
    n = numeric(),
    stringsAsFactors = FALSE
  )
  
  combined_results_girls <- data.frame(
    Rownames = character(),
    Girls = character(),
    Odds_Ratios = numeric(),
    CI_Lower = numeric(),
    CI_Upper = numeric(),
    p_values = character(),
    n = numeric(),
    stringsAsFactors = FALSE
  )
  
  combined_results_boys <- data.frame(
    Rownames = character(),
    Boys = character(),
    Odds_Ratios = numeric(),
    CI_Lower = numeric(),
    CI_Upper = numeric(),
    p_values = character(),
    n = numeric(),
    stringsAsFactors = FALSE
  )
  
  # Iterate through data frame names
  for (i in seq_len(nrow(df_labels))) {
    df_name <- df_labels$df_name[i]
    label <- df_labels$label[i]
    
    df <- results_list[[df_name]]  # Get the data frame from results_list
    
    # Add the first column (unnamed) to the selected_columns data frame
    selected_columns <- data.frame(
      Rownames = rownames(df),
      Girls_Boys = rep(label, nrow(df)),
      aOR_CI = paste0(df$odds_ratios, " (",df$ci_lower, " to ", df$ci_upper,")"),
      p_values = df$p_values_formatted,
      n = df$n,
      stringsAsFactors = FALSE
    )
    
    # Add the data frame as rows to the combined_results data frame
    combined_results <- rbind(combined_results, selected_columns)
  }
  
  # Iterate through data frame names in results_list_girls
  for (i in seq_len(nrow(df_labels))) {
    df_name <- df_labels$df_name[i]
    label <- df_labels$label[i]
    
    df <- results_list_girls[[df_name]]  # Get the data frame from results_list_girls
    
    # Add the first column (unnamed) to the selected_columns data frame
    selected_columns <- data.frame(
      Rownames = rownames(df),
      Girls = rep(label, nrow(df)),
      aOR_CI = paste0(df$odds_ratios, " (",df$ci_lower, " to ", df$ci_upper,")"),
      p_values = df$p_values_formatted,
      n = df$n,
      stringsAsFactors = FALSE
    )
    
    # Add the data frame as rows to the combined_results_girls data frame
    combined_results_girls <- rbind(combined_results_girls, selected_columns)
  }
  
  # Iterate through data frame names in results_list_boys
  for (i in seq_len(nrow(df_labels))) {
    df_name <- df_labels$df_name[i]
    label <- df_labels$label[i]
    
    df <- results_list_boys[[df_name]]  # Get the data frame from results_list_boys
    
    # Add the first column (unnamed) to the selected_columns data frame
    selected_columns <- data.frame(
      Rownames = rownames(df),
      Boys = rep(label, nrow(df)),
      aOR_CI = paste0(df$odds_ratios, " (",df$ci_lower, " to ", df$ci_upper,")"),
      p_values = df$p_values_formatted,
      n = df$n,
      stringsAsFactors = FALSE
    )
    
    # Add the data frame as rows to the combined_results_boys data frame
    combined_results_boys <- rbind(combined_results_boys, selected_columns)
  }
  
  # Keep only pred_vars (omit for full table with controls)
  combined_results <- combined_results[combined_results$Rownames %in% pred_var, ]
  combined_results_girls <- combined_results_girls[combined_results_girls$Rownames %in% pred_var, ]
  combined_results_boys <- combined_results_boys[combined_results_boys$Rownames %in% pred_var, ]

  setDT(combined_results)
  setDT(combined_results_girls)
  setDT(combined_results_boys)
  
  # wide
  combined_results_wide <- dcast(combined_results, 
                     Girls_Boys ~ Rownames, 
                     value.var = c("aOR_CI", "p_values"),
                     sep = " ")
  
  combined_results_girls_wide <- dcast(combined_results_girls, 
                                      Girls ~ Rownames, 
                                      value.var = c("aOR_CI", "p_values"),
                                      sep = " ")
  
  combined_results_boys_wide <- dcast(combined_results_boys, 
                                       Boys ~ Rownames, 
                                       value.var = c("aOR_CI", "p_values"),
                                       sep = " ")
  

  setcolorder(combined_results_boys_wide, 
              c("Boys", 
                "aOR_CI gender_norms", "p_values gender_norms",
                "aOR_CI parenting", "p_values parenting",
                "aOR_CI safe_school", "p_values safe_school",
                "aOR_CI sp_gov", "p_values sp_gov",
                "aOR_CI sp_non_gov", "p_values sp_non_gov"))
  
  setcolorder(combined_results_wide, 
              c("Girls_Boys",
                "aOR_CI gender_norms", "p_values gender_norms",
                "aOR_CI parenting", "p_values parenting",
                "aOR_CI safe_school", "p_values safe_school",
                "aOR_CI sp_gov", "p_values sp_gov",
                "aOR_CI sp_non_gov", "p_values sp_non_gov"))
  
  setcolorder(combined_results_girls_wide, 
              c("Girls",
                "aOR_CI gender_norms", "p_values gender_norms",
                "aOR_CI parenting", "p_values parenting",
                "aOR_CI safe_school", "p_values safe_school",
                "aOR_CI sp_gov", "p_values sp_gov",
                "aOR_CI sp_non_gov", "p_values sp_non_gov"))
  
  
  # Create a flextable object for each combined results data frame
  ft_combined <- flextable::flextable(combined_results_wide)
  ft_combined_girls <- flextable::flextable(combined_results_girls_wide)
  ft_combined_boys <- flextable::flextable(combined_results_boys_wide)
  
  # Format table appearance
  ft_combined <- theme_apa(ft_combined)
  ft_combined <- line_spacing(ft_combined, space = 1, part = "all")
  ft_combined <- set_table_properties(ft_combined, layout = "autofit")
  ft_combined <- flextable::fontsize(ft_combined, size = 10)
  
  ft_combined_girls <- flextable::theme_apa(ft_combined_girls)
  ft_combined_girls <- flextable::line_spacing(ft_combined_girls, space = 1, part = "all")
  ft_combined_girls <- flextable::set_table_properties(ft_combined_girls, layout = "autofit")
  ft_combined_girls <- flextable::fontsize(ft_combined_girls, size = 10)
  
  ft_combined_boys <- flextable::theme_apa(ft_combined_boys)
  ft_combined_boys <- flextable::line_spacing(ft_combined_boys, space = 1, part = "all")
  ft_combined_boys <- flextable::set_table_properties(ft_combined_boys, layout = "autofit")
  ft_combined_boys <- flextable::fontsize(ft_combined_boys, size = 10)
  
  # Create a Word document and add the tables
  doc <- officer::read_docx()
  doc <- flextable::body_add_flextable(doc, ft_combined)
  doc <- flextable::body_add_flextable(doc, ft_combined_girls)
  doc <- flextable::body_add_flextable(doc, ft_combined_boys)
  
  # Save the document with tables to a Word file
  file_name <- file.path(config$outdir_lso, config$outdat_log)
  print(doc, target = file_name)
  
  return(combined_results_wide)
} 