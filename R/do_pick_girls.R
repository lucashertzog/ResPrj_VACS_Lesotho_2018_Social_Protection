do_pick_girls <- function(
    design,
    stratified_control_var,
    outcome_var,
    pred_var
    ){
  girls <- design[design$sex == 1, ]
  return(girls)
}