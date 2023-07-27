#' Declare survey design
#'
#' @param vacs_lso 
#'
#' @return design
#' @export
#'
#' @examples

do_svy_design <- function(
    vacs_lso,
    name = "design"
){
  design <- survey::svydesign(
    id = ~ psu,
    strata = ~ district,
    weights = ~ individual_weight,
    data = vacs_lso,
    single = "centered"
  )
  return(design)
}
