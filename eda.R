config <- yaml::read_yaml("config.yaml")

vacs_lso <- read.csv(file = file.path(config$indir_lso, config$indat_lso))


outcome_results[rownames(outcome_results) %in% c('age2','age1'),]