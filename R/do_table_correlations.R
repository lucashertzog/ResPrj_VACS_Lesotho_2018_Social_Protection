#' Create a table with spearman's correlations between outcomes
#'
#' @param outcome_var 
#' @param vacs_lso 
#'
#' @return
#' @export
#'
#' @examples
do_table_correlations <- function(
    outcome_var,
    vacs_lso
){
  outcome_var <- c(
    "edu_enrol",
    "edu_attainment",
    "edu_ecostr_work",
    "srh_condom_use",
    "srh_multiple_partners",
    "srh_transactional",
    "srh_child_marriage"
  )
  
  outcome_df <- data.frame(vacs_lso[outcome_var])
  
  apa.cor.table(outcome_df, filename = file.path(config$outdir_lso, config$outdat_correlation),
                show.sig.stars = TRUE)
}