#' Load packages for the pipeline
#'
#' @param do_it 
#'
#' @return
#' @export
#'
#' @examples

load_packages <- function(do_it = T){
  pkgs <- c("targets",
            "yaml",
            "data.table",
            "dplyr",
            "ggeffects",
            "survey",
            "surveybootstrap",
            "tidyr",
            "purrr",
            "ggplot2",
            "flextable",
            "officer",
            "gtsummary",
            "gt",
            "Hmisc",
            "haven",
            "apaTables",
            "sf",
            "RColorBrewer",
            "gridExtra",
            "ggspatial"
            )
  ipak <- function(pkg){
    new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
    if (length(new.pkg)) 
      install.packages(new.pkg, dependencies = TRUE)
    sapply(pkg, require, character.only = TRUE)
  }
  ipak(pkgs)
}