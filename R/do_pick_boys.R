do_pick_boys <- function(
    vacs_lso,
    stratified_control_var,
    outcome_var,
    pred_var
){
  boys <- vacs_lso[vacs_lso$sex == 0, ]
  return(boys)
}