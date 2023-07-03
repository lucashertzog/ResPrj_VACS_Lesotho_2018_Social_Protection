#' Generate Summary Statistics Table with Weighted % and 95% CIs
#'
#' @param control_var   A vector of outcome variables.
#' @param outcome_var   A vector of outcome variables.
#' @param pred_var      A vector of predictor variables.
#' @param design        `svydesign` object representing the survey design.
#'
#' @return
#' @export table_1.docx
#'
#' @examples

do_table_summary_stats <- function(
    outcome_var,
    pred_var,
    control_var,
    design
){

t <- gtsummary::tbl_svysummary(
  data = design,
  by = sex,
  missing = "no",
  include = c(age, age_group, control_var, pred_var, outcome_var),
  statistic = list(age ~ "{mean} ({sd})", all_categorical() ~ "{p}%"),
  type = age ~ "continuous",
  label = age ~ "Age"
) %>%
  gtsummary::add_p() %>%
  gtsummary::separate_p_footnotes() %>%
  gtsummary::add_significance_stars() %>%
  gtsummary::add_ci(include = all_categorical()) %>%
  gtsummary::add_overall() %>%
  gtsummary::modify_header(
    label = "**Characteristic**",
    stat_2 = "**Girls** (N=2,967)",
    stat_1 = "**Boys** (N=627)",
    stat_0 = "**Total** (N=3,594)",
    p.value = "**p-value**"
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
  save_as_docx(path = file.path(config$outdir_lso, config$outdat_summary))
return(t)
}

