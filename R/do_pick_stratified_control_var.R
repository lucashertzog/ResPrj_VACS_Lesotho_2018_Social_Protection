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