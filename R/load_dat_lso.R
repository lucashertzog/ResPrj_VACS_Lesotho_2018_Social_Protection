#' Title
#'
#' @param dir 
#' @param dat 
#'
#' @return
#' @export
#'
#' @examples

load_dat_lso <- function(
    dir,
    dat,
    name = "vacs_lso"
){
  vacs_lso <- read.csv(file = file.path(config$indir_lso, config$indat_lso))
  
  new_names <- c(
    "PSU" = "psu",
    "Q2" = "age",
    "District" = "district",
    "individual_weight1" = "individual_weight",
    "sex" = "sex",
    "hivpos" = "hiv",
    "AgeGroup" = "age_group",
    "EducationEver" = "edu_attainment",
    "school_enrol" = "edu_enrol",
    "any_orph" = "orphan",
    "NEET_Q13" = "edu_ecostr_work",
    "govt_supp" = "sp_gov",
    "NPO_supp" = "sp_non_gov",
    "cash_any" = "sp_any",
    "double_cash" = "sp_double",
    "child_marr" = "srh_child_marriage",
    "Mult_part" = "srh_multiple_partners",
    "Trans_sex" = "srh_transactional",
    "py_condom" = "srh_condom_use"
  )
  
  vacs_lso <- rename_with(
    vacs_lso, ~ new_names, .cols = everything()
    )
  
  # reorganise
  new_order <- c("district", 
                 "individual_weight",
                 "psu",
                 "age", 
                 "age_group", 
                 "sex", 
                 "hiv", 
                 "orphan", 
                 "sp_gov", 
                 "sp_non_gov",
                 "sp_double", 
                 "sp_any", 
                 "edu_enrol", 
                 "edu_attainment", 
                 "edu_ecostr_work", 
                 "srh_condom_use",
                 "srh_multiple_partners", 
                 "srh_transactional", 
                 "srh_child_marriage")
  
  # Reorder the columns and drop 'srh_older_partner'
  vacs_lso <- select(vacs_lso, all_of(new_order))
  
  # Loop through the variables and convert if they are strings
  for (variable in new_order) {
    if (is.character(vacs_lso[[variable]]) && !(variable %in% c("district", 
                                                 "individual_weight", 
                                                 "psu", 
                                                 "age_group", 
                                                 "age"))
      ){
      vacs_lso[[variable]] <- ifelse(vacs_lso[[variable]] == "Yes", 1, ifelse(vacs_lso[[variable]] == "No", 0, NA))
      # vacs_lso[[variable]] <- factor(vacs_lso[[variable]], levels = c(0, 1), exclude = NULL)
    }
  }
  # Return the modified data frame
  return(vacs_lso)
}


