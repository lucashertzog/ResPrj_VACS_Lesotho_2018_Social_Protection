# Violence Against Children and Youth Surveys: Data Analysis Pipeline

This is a data analysis pipeline was created by Lucas Hertzog, Ph.D., 2023. It utilizes the `targets` package in R for defining and managing data processing and analysis tasks. 

## Overview

The pipeline is divided into several steps:
1. Load the required data.
2. Create subsets of data for girls and boys.
3. Declare survey design.
4. Select variables for the analysis.
5. Perform logistic regression and calculate marginal effects.
6. Combine the results.
7. Generate tables for correlations, summary statistics, regressions, and marginal effects.
8. Create relevant plots.

## Dependencies

This pipeline requires the following R packages:
- targets
- yaml
- data.table
- dplyr
- ggeffects
- survey
- surveybootstrap
- tidyr
- purrr
- ggplot2
- flextable
- officer
- gtsummary
- gt
- Hmisc
- haven
- apaTables

## Usage

First, ensure all the required R packages mentioned above are installed.

Then, source the required functions by running:

```
lapply(list.files("R", full.names = TRUE), source)
```

Load the configurations for the pipeline:

```
config <- yaml::read_yaml("config.yaml")
```

Finally, run the pipeline:

```
tar_make()
```

## Outputs

The outputs of the pipeline include:
- Logistic regression results and marginal effects for overall data, girls, and boys.
- Combined results of the marginal effects.
- Tables summarizing correlations, summary statistics, regressions, and marginal effects.
- Plots such as forest plot and summary plot.

The outputs are generated as `targets` in the pipeline and can be accessed using the `tar_read()` function.
