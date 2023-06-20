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
      "ggplot2"
    ),
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
  ### DECLARE SURVEY DESIGN ####
  #### dat_svy_design ####
  tar_target(
    dat_svy_design,
    do_svy_design(
      dat_lso
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
  #### stratified_girls_subset ####
  # tar_target(
  #   stratified_girls_subset,
  #   do_pick_girls(
  #     dat_svy_design,
  #     dat_stratified_control_var,
  #     dat_outcome_var,
  #     dat_pred_var
  #   )
  # )
  # ,
  # #### stratified_boys_subset ####
  # tar_target(
  #   stratified_boys_subset,
  #   do_pick_boys(
  #     dat_svy_design,
  #     dat_stratified_control_var,
  #     dat_outcome_var,
  #     dat_pred_var
  #   )
  # )
  # ,
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
      dat_svy_design
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
      dat_svy_design
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
  ### TABLES ####
  #### table_summary_stats ####
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
      dat_pred_var
    )
  )
  ,
  # #### table_marginal_effects ####
  tar_target(
    table_marginal_effects,
    do_table_marginal_effects(
      calc_marginal_effects
    )
  )
  # ,
  # ### FIGURES ####
  # #### plot_regressions ####
  # tar_target(
  #   plot_regressions,
  #   do_plot_regressions(
  #       calc_logistic_regression
  #   )
  # )
  # ,
  # #### plot_marginal_effects ####
  # tar_target(
  #   plot_marginal_effects,
  #   do_plot_marginal_effects(
  #     calc_marginal_effects
  #   )
  # )
)