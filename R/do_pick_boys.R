do_pick_boys <- function(
    design,
    stratified_control_var,
    outcome_var,
    pred_var
){
  boys <- design[design$sex == 0, ]
  return(boys)
}