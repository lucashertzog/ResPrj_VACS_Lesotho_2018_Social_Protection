#' Declare survey design for subset with boys
#'
#' @param boys
#'
#' @return design_boys
#' @export
#'
#' @examples

do_svy_design_boys <- function(
    boys
){
  design_boys <- survey::svydesign(
    id = ~ psu,
    strata = ~ district,
    weights = ~ individual_weight,
    data = boys,
    single = "centered"
  )
  return(design_boys)
}
