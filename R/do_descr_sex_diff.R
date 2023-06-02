# do_descr_sex_diff <- function(
#     x
# ){
# # Perform the analysis stratified by sex
# result_list <- purrr::map(variables, ~ calculate_weighted_percentage(.x))
# result_list <- c(result_list, calculate_mean_sd("s"))
# 
# # Combine the results into a single dataframe
# result_df <- bind_rows(result_list)
# 
# # Pivot the dataframe to create the sociodemographic table
# table_df <- pivot_wider(result_df,
#                         names_from = Var,
#                         values_from = Estimate:Upper_CI)
# 
# # Calculate p-values for sex differences using chi-squared test for categorical variables and t-test for continuous variables
# p_values <- sapply(variables, function(
#     x
# ){
#   if (is.numeric(vacs_lso[[x]]))
#   {
#     t.test(vacs_lso[[x]] ~ vacs_lso$sex, weights = vacs_lso$individual_weight)$p.value
#   }
#   else
#   {
#     chisq.test(vacs_lso[[x]], vacs_lso$sex, w = vacs_lso$individual_weight)$p.value
#   }
# })
# p_values <- round(p_values, 3)
# }
