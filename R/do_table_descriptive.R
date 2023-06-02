# # Add the p-values to the table
# table_df$p_value <- NA
# table_df$p_value[match(names(p_values), colnames(table_df))] <- p_values
# 
# # Add the total row
# total_row <- table_df %>%
#   summarise(across(where(is.numeric), sum, na.rm = TRUE), p_value = NA) %>%
#   mutate(Category = "Total")
# table_df <- bind_rows(total_row, table_df)
# 
# # Rename the columns
# column_names <- c("Category", "Mean (SD)", "Weighted %", "95% CI", "p-value")
# names(table_df) <- column_names
# 
# # Print the sociodemographic table
# print(table_df)
