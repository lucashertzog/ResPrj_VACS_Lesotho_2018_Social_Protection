#' Select outcome variables
#'
#' @param design 
#'
#' @return outcome_var
#' @export
#'
#' @examples
do_pick_outcome_var <- function(
  design
){
  # Create the outcome_var vector
  outcome_var <- c(
    "edu_enrol",
    "edu_attainment",
    "edu_ecostr_work",
    "srh_condom_use",
    "srh_multiple_partners",
    "srh_transactional",
    "srh_child_marriage"
  )
  return(outcome_var)
}