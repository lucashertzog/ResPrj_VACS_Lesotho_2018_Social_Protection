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
    )
  )

list(
  #### LOAD DATA ####
  #### dat_lso ####
  tar_target(
    dat_lso, 
    load_dat_lso(
      dir,
      dat
    )
  )
  ,
  #### DECLARE SURVEY DESIGN ####
  #### dat_svy_design ####
  tar_target(
    dat_svy_design,
    do_svy_design(
      dat_lso
    )
  )
  ,
  #### ANALYSIS ####
  #### dat_descriptives ####
  # define variables #
  tar_target(
    dat_descriptives,
    do_pick_vars(
      dat_svy_design
    )
  )
  ,
  #### calc_descr_weighted_ci ####
  tar_target(
    calc_descr_weighted_ci,
    do_descr_weighted_ci(
      dat_descriptives
    )
  )
  ,
  #### calc_descr_mean_sd ####
  tar_target(
    calc_descr_mean_sd,
    do_descr_mean_sd(
      dat_descriptives
    )
  )
  ,
  #### calc_descr_sex_diff ####
  tar_target(
    calc_descr_sex_diff,
    do_descr_sex_diff(
      dat_descriptives
    )
  )
  ,
  #### calc_logistic_regression ####
  tar_target(
    calc_logistic_regression,
    do_logistic_regression(
      dat_svy_design
    )
  )
  ,
  #### calc_marginal_effects ####
  tar_target(
    calc_marginal_effects,
    do_marginal_effects(
      calc_logistic_regression
    )
  )
  ,
  #### TABLES ####
  #### table_descriptive ####
  tar_target(
    table_descriptive,
    do_table_descriptive(
      calc_descr_weighted_ci,
      calc_descr_mean_sd,
      calc_descr_sex_diff
    )
  )
  ,
  #### table_regressions ####
  tar_target(
    table_regressions,
    do_table_regressions(
      calc_logistic_regression,
    )
  )
  ,
  #### table_marginal_effects ####
  tar_target(
    table_marginal_effects,
    do_table_marginal_effects(
      calc_marginal_effects,
    )
  )
  ,
  #### FIGURES ####
  #### plot_regressions ####
  tar_target(
    plot_regressions,
    do_plot_regressions(
        calc_logistic_regression
    )
  )
  ,
  #### plot_marginal_effects ####
  tar_target(
    plot_marginal_effects,
    do_plot_marginal_effects(
      calc_marginal_effects
    )
  )
)