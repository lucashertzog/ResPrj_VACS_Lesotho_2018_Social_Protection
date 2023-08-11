#' Generate Summary Statistics Table with Weighted % and 95% CIs for 
#' supplementary materials
#'
#' @param control_var   A vector of outcome variables.
#' @param outcome_var   A vector of outcome variables.
#' @param pred_var      A vector of predictor variables.
#' @param design        `svydesign` object representing the survey design.
#'
#' @return
#' @export sup_table_summary_stats_n_gov.docx
#'
#' @examples

do_table_summary_stats_supp <- function(
    outcome_var,
    pred_var,
    control_var,
    design
){
  design$variables$sp_gov_sex <- with(
    design, 
    interaction(
      design$variables$sp_non_gov, 
      design$variables$sex, 
      sep = " x "))
  
  t <- gtsummary::tbl_svysummary(
    data = design,
    by = sp_gov_sex,
    missing = "no",
    include = c(age, age_group, control_var, outcome_var),
    statistic = list(age ~ "{mean} ({sd})", all_categorical() ~ "{p}%"),
    type = age ~ "continuous",
    label = age ~ "Age"
  ) %>%
    gtsummary::add_p() %>%
    gtsummary::separate_p_footnotes() %>%
    gtsummary::add_significance_stars() %>%
    gtsummary::add_ci(include = all_categorical()) %>%
    # gtsummary::add_overall() %>%
    gtsummary::modify_header(
      label = "**Characteristic**",
      stat_4 = "**Girls sp (N=141)**", # 1x1 sp, girl
      stat_3 = "**Girls n-sp (N=2,641)**", # 0x1 n-sp, girl
      stat_2 = "**Boys sp (N=44)**", # 1x0 sp, boy
      stat_1 = "**Boys n-sp (N=569)**", # 0x0 n-sp, boy
      # stat_0 = "**Total (N=3,506)**",
      # p.value = "**p-value**"
    ) %>%
    gtsummary::modify_column_merge(
      pattern = "{stat_4} [{ci_stat_4}]",
      rows = NULL
    ) %>%
    gtsummary::modify_column_merge(
      pattern = "{stat_3} [{ci_stat_3}]",
      rows = NULL
    ) %>%
    gtsummary::modify_column_merge(
      pattern = "{stat_2} [{ci_stat_2}]",
      rows = NULL
    ) %>%
    gtsummary::modify_column_merge(
      pattern = "{stat_1} [{ci_stat_1}]",
      rows = NULL
    )
  
  # Save to a docx file
  t %>%
    as_flex_table()%>%
    save_as_docx(path = file.path(config$outdir_lso, "sup_table_summary_stats_n_gov.docx"))
  return(t)
}
