#' Declare survey design for subset with girls
#'
#' @param girls
#'
#' @return design_girls
#' @export
#'
#' @examples

do_svy_design_girls <- function(
    girls,
    vacs_lso
){
  design_girls <- survey::svydesign(
    id = ~ psu,
    strata = ~ district,
    weights = ~ individual_weight,
    data = girls,
    single = "centered"
  )
  return(design_girls)
}
