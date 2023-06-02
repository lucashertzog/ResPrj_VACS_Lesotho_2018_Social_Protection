do_svy_design <- function(
    survey_design
){
  design <- survey::svydesign(
    id = ~ psu,
    strata = ~ district,
    weights = ~ individual_weight,
    data = vacs_lso,
    single = "centered"
  )
  design
}
