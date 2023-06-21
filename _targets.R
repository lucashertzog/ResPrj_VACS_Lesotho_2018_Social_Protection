library(targets)

lapply(list.files("R", full.names = TRUE), source)

config <- yaml::read_yaml("config.yaml")

tar_option_set(
  packages =
    c("targets",
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
      "haven"
    )
  )


list(
  ### LOAD DATA ####
  #### dat_lso ####
  tar_target(
    dat_lso, 
    load_dat_lso(
      dir,
      dat,
    )
  )
  ,
  ### CREATE SUBSETS GIRLS/BOYS ####
  #### stratified_girls_subset ####
  tar_target(
    stratified_girls_subset,
    do_pick_girls(
      dat_lso
    )
  )
  ,
  #### stratified_boys_subset ####
  tar_target(
    stratified_boys_subset,
    do_pick_boys(
      dat_lso
    )
  )
  ,
  ### DECLARE SURVEY DESIGN ####
  #### dat_svy_design ####
  tar_target(
    dat_svy_design,
    do_svy_design(
      dat_lso
    )
  )
  ,
  #### dat_svy_design_girls ####
  tar_target(
    dat_svy_design_girls,
    do_svy_design_girls(
      stratified_girls_subset
    )
  )
  ,
  #### dat_svy_design_boys ####
  tar_target(
    dat_svy_design_boys,
    do_svy_design_boys(
      stratified_boys_subset
    )
  )
  ,
  ### SELECT VARIABLES ####
  #### dat_outcome_var ####
  tar_target(
    dat_outcome_var,
    do_pick_outcome_var(
      dat_svy_design
    )
  )
  ,
  #### dat_pred_var ####
  tar_target(
    dat_pred_var,
    do_pick_pred_var(
      dat_svy_design
    )
  )
  ,
  #### dat_control_var ####
  tar_target(
    dat_control_var,
    do_pick_control_var(
      dat_svy_design
    )
  )
  ,
  #### dat_stratified_control_var ####
  tar_target(
    dat_stratified_control_var,
    do_pick_stratified_control_var(
      dat_svy_design
    )
  )
  ,
  
  ### ANALYSIS ####
  #### calc_logistic_regression ####
  tar_target(
    calc_logistic_regression,
    do_logistic_regression(
      dat_outcome_var,
      dat_pred_var,
      dat_control_var,
      dat_svy_design
    )
  )
  ,
  #### calc_logistic_regression_girls ####
  tar_target(
    calc_logistic_regression_girls,
    do_logistic_regression_girls(
      dat_outcome_var,
      dat_pred_var,
      dat_stratified_control_var,
      dat_svy_design_girls
    )
  )
  ,
  # #### calc_logistic_regression_boys ####
  tar_target(
    calc_logistic_regression_boys,
    do_logistic_regression_boys(
      dat_outcome_var,
      dat_pred_var,
      dat_stratified_control_var,
      dat_svy_design_boys
    )
  )
  ,
  #### calc_marginal_effects ####
  tar_target(
    calc_marginal_effects,
    do_marginal_effects(
      dat_outcome_var,
      dat_pred_var,
      dat_control_var,
      dat_svy_design
    )
  )
  ,
  #### calc_marginal_effects_girls ####
  tar_target(
    calc_marginal_effects_girls,
    do_marginal_effects_girls(
      dat_outcome_var,
      dat_pred_var,
      dat_stratified_control_var,
      dat_svy_design_girls
    )
  )
  ,
  #### calc_marginal_effects_boys ####
  tar_target(
    calc_marginal_effects_boys,
    do_marginal_effects_boys(
      dat_outcome_var,
      dat_pred_var,
      dat_stratified_control_var,
      dat_svy_design_boys
    )
  )
  ,
  ### TABLES ####
  ### table_summary_stats ####
  tar_target(
    table_summary_stats,
    do_table_summary_stats(
      dat_outcome_var,
      dat_pred_var,
      dat_control_var,
      dat_svy_design
    )
  )
  ,
  #### table_regressions ####
  tar_target(
    table_regressions,
    do_table_regressions(
      calc_logistic_regression,
      calc_logistic_regression_girls,
      calc_logistic_regression_boys,
      dat_pred_var
    )
  )
  ,
  #### table_marginal_effects ####
  tar_target(
    table_marginal_effects,
    do_table_marginal_effects(
      calc_marginal_effects,
      calc_marginal_effects_girls,
      calc_marginal_effects_boys
    )
  )
  # ,
  ### FIGURES ####
  # #### plot_regressions ####
  # tar_target(
  #   plot_regressions,
  #   do_plot_regressions(
  #       calc_logistic_regression
  #   )
  # )
  # ,
  #### plot_marginal_effects ####
  # tar_target(
  #   plot_marginal_effects,
  #   do_plot_marginal_effects(
  #     calc_marginal_effects
  #   )
  # )
)