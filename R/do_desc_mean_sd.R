# Calculate the mean and standard deviation for continuous variables
calculate_mean_sd <- function(
    x
){
  tab <- svytotal(as.formula(paste0("~", x)),
                  design = design,
                  total = TRUE)
  tab <- data.frame(tab)
  tab <- tab %>%
    mutate(Var = x,
           Mean = round(tab$total, 1),
           SD = round(sqrt(var(tab$total, na.rm = TRUE)), 1)) %>%
    select(Var, Mean, SD)
  tab
}