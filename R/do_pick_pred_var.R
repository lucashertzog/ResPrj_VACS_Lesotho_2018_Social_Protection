#' Title
#'
#' @param design 
#'
#' @return pred_var
#' @export
#'
#' @examples
do_pick_pred_var <- function(
    design
){
  pred_var <- c(
  "sp_non_gov",
  "sp_gov",
  "sp_double",
  "sp_any"
)
    return(pred_var)
}