library(targets)
tar_source()

load_packages(T)
config <- yaml::read_yaml("config.yaml")
# sink("data_provided_report/DatSci_AIHW_report.Rmd");generate_report(data_frames);sink()
tar_visnetwork(targets_only = T,
               level_separation = 200)
tar_make()
