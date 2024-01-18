#' Select exposure variables
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
  "safe_school",
  "parenting",
  "gender_norms"
)
    return(pred_var)
}