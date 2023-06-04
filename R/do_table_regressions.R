#' Title
#'
#' @param results_list, pred_var
#'
#' @return 
#' @export table_odds.docx
#'
#' @examples
do_table_regressions <- function(
    results_list,
    pred_var,
    name = "odds ratio table"
){
  
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

# Create an empty data frame to store the combined results
combined_results <- data.frame(Rownames = character(),
                               Girls_Boys = character(), 
                               Odds_Ratios = numeric(), 
                               CI_Lower = numeric(), 
                               CI_Upper = numeric(), 
                               p_values = character(), 
                               stringsAsFactors = FALSE)

# Iterate through data frame names
for (i in seq_len(nrow(df_labels))) {
  df_name <- df_labels$df_name[i]
  label <- df_labels$label[i]
  
  df <- results_list[[df_name]]  # Get the data frame from the list
  
  # Add the first column (unnamed) to the selected_columns data frame
  selected_columns <- data.frame(
    Rownames = rownames(df),
    Girls_Boys = rep(label, nrow(df)),
    aOR_CI = paste(df$odds_ratios, "(", df$ci_lower, "to", df$ci_upper, ")"),
    p_values = df$p_values_formatted,
    stringsAsFactors = FALSE
  )

  # Add the data frame as rows to the combined_results data frame
  combined_results <- rbind(combined_results, selected_columns)
  
  # Keep only pred_vars (omit for full table with controls)
  combined_results <- combined_results[combined_results$Rownames %in% pred_var, ]
  
  # from long to wide format
  combined_results_wide <- combined_results %>%
    pivot_wider(names_from = Rownames, 
                values_from = c(aOR_CI, p_values))%>%
  # put them in order
    select(
      Girls_Boys,
      aOR_CI_sp_non_gov, 
      p_values_sp_non_gov, 
      aOR_CI_sp_gov, 
      p_values_sp_gov, 
      aOR_CI_sp_double, 
      p_values_sp_double, 
      aOR_CI_sp_any, 
      p_values_sp_any)
}

# Create a Word document
doc <- officer::read_docx()

# Create a flextable object for the combined results
ft_combined <- flextable::flextable(combined_results_wide)

# Format table appearance
ft_combined <- flextable::theme_booktabs(ft_combined)  # Apply booktabs theme

# Add borders to the table
ft_combined <- flextable::border_remove(ft_combined)

# Add the table to the Word document
doc <- flextable::body_add_flextable(doc, ft_combined)

# Save the table to a Word file
file_name <- file.path(config$outdir_lso, "table_odds.docx")
print(doc, target = file_name)
}