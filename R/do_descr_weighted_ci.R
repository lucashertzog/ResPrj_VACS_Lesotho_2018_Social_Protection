# calculate the weighted percentages and CIs
calculate_weighted_percentage <- function(x) {
  tab <- svytotal(as.formula(paste0("~ factor(", x, ")")), design = design, total = TRUE, ci = TRUE)
  tab <- data.frame(tab)
  
  if (!is.null(tab) && !is.null(tab[[x]]) && any(!is.na(tab[[x]]))) {
    tab <- tab %>%
      mutate(Var = x,
             Category = levels(tab[[x]]),
             Lower_CI = ifelse(sum(!is.na(tab$ci$lower)) > 0, round(tab$ci$lower * 100, 1), NA),
             Upper_CI = ifelse(sum(!is.na(tab$ci$upper)) > 0, round(tab$ci$upper * 100, 1), NA),
             Estimate = ifelse(is.na(tab$total), NA, round(tab$total * 100, 1)))
    tab <- tab %>%
      select(Var, Category, Estimate, Lower_CI, Upper_CI)
  } else {
    tab <- data.frame(Var = x, Category = NA, Estimate = NA, Lower_CI = NA, Upper_CI = NA)
  }
  
  tab
}