#' Select control variables for the non-stratified model
#'
#' @param design 
#'
#' @return control_var
#' @export
#'
#' @examples
do_pick_control_var <- function (
    design
){
  control_var <- c(
  "age",
  "sex",
  "hiv",
  "orphan"
)
  return(control_var)
}