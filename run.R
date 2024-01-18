# Lucas Hertzog PhD, 2023
# Script to run and visualise the pipeline

# Load the library
library(targets)

# Source all functions
tar_source()

# Load packages
load_packages(T)

# Set configurations
config <- yaml::read_yaml("config.yaml")

# Make sure functions are sourced
lapply(list.files("R", full.names = TRUE), source)

# Visualise the pipeline
tar_visnetwork(targets_only = T,
               level_separation = 200)

# Run the pipeline
tar_make()

