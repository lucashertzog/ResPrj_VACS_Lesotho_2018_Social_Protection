# ResPrj_VACS_Lesotho_2019_Social_Protection

## Pipeline Description

The pipeline includes loading and preprocessing the data, creating a survey design, performing logistic regression analysis, computing marginal effects, and generating tables and figures to summarise the results.

The project is designed to provide a reproducible and organized approach to analyzing the data, making it easier to track and reproduce the analysis process.

This pipeline performs a series of data analysis tasks using the {targets} package in R. It follows the steps outlined below:

1. **Load Data**: The data is loaded from the specified directory and file using the `load_dat_lso` function.

2. **Declare Survey Design**: The survey design is created using the loaded data with the `do_svy_design` function.

3. **Select Variables**: The variables of interest for the analysis are selected using the `do_pick_outcome_var`, `do_pick_pred_var`, and `do_pick_control_var` functions.

4. **Analysis**: Logistic regression is performed using the `do_logistic_regression` function, which uses the survey design and the selected variables.

5. **Compute Marginal Effects**: Marginal effects are computed using the `do_marginal_effects` function, which uses the logistic regression results and the selected variables.

6. **Tables**: The results are formatted into tables using the `do_table_regressions` and `do_table_marginal_effects` functions.

7. **Figures**: The results are visualized using the `do_plot_regressions` and `do_plot_marginal_effects` functions. -->

The pipeline is executed using the "targets" package, which manages the dependencies between the different steps and ensures efficient and reproducible computation.

To run the pipeline, ensure that the required packages are installed (listed in the `tar_option_set` function), and execute the pipeline using the `tar_make()` function.

For more details on each step, refer to the R scripts in the "R" directory and the configuration file "config.yaml".
