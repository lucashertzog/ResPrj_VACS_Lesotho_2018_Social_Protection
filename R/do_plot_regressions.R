# # Install required packages (if not already installed)
# install.packages("forestplot")
# 
# # Load required packages
# library(forestplot)
# 
# # List of data frame names
# df_names <- c("edu_enrol"
#               # , "edu_attainment", "edu_ecostr_work",
#               # "srh_condom_use", "srh_multiple_partners",
#               # "srh_transactional", "srh_child_marriage"
#               )
# 
# # Rows to select
# rows_to_select <- c("sp_non_gov", "sp_gov", "sp_double", "sp_any")
# 
# # Create a data frame to store the forest plot data
# forestplot_data <- data.frame(
#   Study = character(),
#   Estimate = numeric(),
#   CI.Lower = numeric(),
#   CI.Upper = numeric(),
#   stringsAsFactors = FALSE
# )
# 
# # Iterate through data frames
# for (df_name in df_names) {
#   df <- results_list[[df_name]]  # Get the data frame from the list
#   
#   selected_rows <- df[rownames(df) %in% rows_to_select, ]  # Select rows based on row names
#   
#   # Extract relevant information for the forest plot
#   study_names <- rownames(selected_rows)
#   estimates <- selected_rows$odds_ratios
#   ci_lower <- selected_rows$ci_lower
#   ci_upper <- selected_rows$ci_upper
#   
#   # Append the data to the forestplot_data data frame
#   forestplot_data <- rbind(forestplot_data, data.frame(Study = study_names,
#                                                        Estimate = estimates,
#                                                        CI.Lower = ci_lower,
#                                                        CI.Upper = ci_upper))
# }
# 
# # Convert Estimate, CI.Lower, and CI.Upper columns to numeric
# forestplot_data$mean <- as.numeric(forestplot_data$Estimate)
# forestplot_data$lower <- as.numeric(forestplot_data$CI.Lower)
# forestplot_data$upper <- as.numeric(forestplot_data$CI.Upper)
# 
# # Create the forest plot
# forestplot(forestplot_data, 
#            mean = forestplot_data$Estimate,
#            lower = forestplot_data$lower, 
#            upper = forestplot_data$upper,
#            labels = forestplot_data$Study,
#            is.summary = c(FALSE, rep(TRUE, length(df_names))),
#            xlab = "Odds Ratio",
#            zero = 1,
#            xlim = c(0.5, 2),  # Adjust the x-axis limits as needed
#            col = fpColors(box = "blue", line = "black", summary = "red"))
# 
# # Customize other aspects of the forest plot as needed
