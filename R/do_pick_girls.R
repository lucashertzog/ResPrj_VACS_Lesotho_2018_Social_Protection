#' Select subset with only girls
#'
#' @param vacs_lso 
#' @param stratified_control_var 
#' @param outcome_var 
#' @param pred_var 
#'
#' @return girls
#' @export
#'
#' @examples
do_pick_girls <- function(
    vacs_lso,
    stratified_control_var,
    outcome_var,
    pred_var
    ){
  girls <- vacs_lso[vacs_lso$sex == 1, ]
  return(girls)
}