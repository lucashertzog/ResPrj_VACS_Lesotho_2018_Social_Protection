#' Plot histograms with summary statistics
#'
#' @param design 
#'
#' @return
#' @export
#'
#' @examples
do_plot_summary <- function(
    design
){
 
png("data_derived/manuscript/figures/fig_summary_hist.png", res = 250, height = 3000, width = 3000)

variables <- c("hiv", "orphan", "sp_non_gov", "sp_gov", "edu_enrol", "edu_attainment",
               "edu_ecostr_work", "srh_condom_use", "srh_multiple_partners", 
               "srh_transactional", "srh_child_marriage")

# Create an empty data frame to store the results
results <- data.frame()

# Loop over variables
for (var in variables) {
  for (sex in c(0, 1)) {
    # Calculate the weighted proportion and its confidence interval
    proportion <- svyby(formula = as.formula(paste0("~", var)), by = ~sex, design = design, svymean, na.rm = TRUE)
    
    # Check if any of the proportions is NA
    if (!any(is.na(proportion[, var]))) {
      ci <- confint(proportion)
      
      # Combine the results into a data frame
      df <- data.frame(
        Variable = var,
        Sex = ifelse(proportion$sex == 0, "Boys", "Girls"),
        Proportion = proportion[, var],
        LowerCI = ci[, 1],
        UpperCI = ci[, 2]
      )
      
      # Add the results to the main data frame
      results <- rbind(results, df)
    }
  }
}

# Map of variable names to labels
var_map <- c("hiv" = "Living with HIV", 
             "orphan" = "Orphanhood", 
             "sp_non_gov" = "Social protection (Non-Govt.)", 
             "sp_gov" = "Social protection (Govt.)", 
             "edu_enrol" = "Enrolled in school", 
             "edu_attainment" = "Educational attainment", 
             "edu_ecostr_work" = "Engaged in any paid work", 
             "srh_condom_use" = "Consistent condom use", 
             "srh_multiple_partners" = "Multiple sexual partners", 
             "srh_transactional" = "Transactional sex", 
             "srh_child_marriage" = "Child marriage")

# Replace variable names with labels
results$Variable <- var_map[results$Variable]

# Order the levels of the 'Variable' factor
results$Variable <- factor(results$Variable, levels = var_map[variables])

# Reverse the order of the 'Sex' factor levels
results$Sex <- factor(results$Sex, levels = c("Girls", "Boys"))

# Plot the proportions with error bars
ggplot(results, aes(x = Sex, y = Proportion, fill = Sex)) +
  geom_bar(stat = "identity", position = position_dodge(), color = "black") +
  geom_errorbar(aes(ymin = LowerCI, ymax = UpperCI), width = 0.2, position = position_dodge(0.9)) +
  facet_wrap(~Variable, scales = "free_y") +
  labs(y = "Proportion") +
  scale_y_continuous(labels = scales::percent) +
  theme_minimal() +
  theme(legend.position = "bottom", legend.title = element_blank())

dev.off()
}

