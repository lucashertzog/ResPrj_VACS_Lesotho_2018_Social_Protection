#' Load and clean data
#'
#' @param dir 
#' @param dat 
#'
#' @return vacs_lso
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
  new_order <- c(
    "district", 
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
  
  # Reorder the columns
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
  
  # conversions
  vacs_lso$age <- as.numeric(vacs_lso$age)

  # Label variables
  var.labels <- c(
    district = "District",
    individual_weight = "Weight",
    psu = "PSU",
    age_group = "Age Groups",
    sex = "Sex",
    hiv = "Living with HIV",
    orphan = "Orphanhood",
    sp_gov = "Social protection (Govt.)",
    sp_non_gov = "Social protection (Non-Govt.)",
    sp_double = "Social protection (double)",
    sp_any = "Social protection (Any)",
    edu_enrol = "Enrolled in school",
    edu_attainment = "Educational attainment",
    edu_ecostr_work = "Engaged in any paid work",
    srh_condom_use = "Consistent condom use",
    srh_multiple_partners = "Multiple sexual partners",
    srh_transactional = "Transactional sex",
    srh_child_marriage = "Child marriage"
  )

  Hmisc::label(vacs_lso) = as.list(var.labels[
    match(names(vacs_lso),
          names(var.labels))
  ])

  # Return the modified data frame
  return(vacs_lso)
}


