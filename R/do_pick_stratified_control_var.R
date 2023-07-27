#' Select control variables for the model stratified by sex
#'
#' @param design 
#'
#' @return stratified_control_var
#' @export
#'
#' @examples
do_pick_stratified_control_var <- function (
    design
){
  stratified_control_var <- c(
    "age",
    "hiv",
    "orphan"
  )
  return(stratified_control_var)
}