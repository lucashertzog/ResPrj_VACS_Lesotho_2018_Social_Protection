do_plot_marginal_effects <- function(
    combined_results
){
  combined_results$predictor <- sub(".*_sp_(.*)", "\\1", combined_results$df_name)
  combined_results$predictor <- ifelse(combined_results$predictor == "gov", "Government", "Any")
  combined_results$df_name <- sub("_sp.*", "", combined_results$df_name)
  
  plot <- ggplot(combined_results, aes(x = factor(x), y = predicted, color = predictor, group = predictor)) +
    geom_point(position = position_dodge(width = 0.8), size=2) +
    geom_errorbar(aes(ymin = conf_low_val, ymax = conf_high_val), width = 0.2, position = position_dodge(width = 0.8), linewidth = 0.8) +
    geom_line(aes(linetype = predictor, group = predictor), position = position_dodge(width = 0.8)) +  # Add line connecting the points
    ylab("Predicted Probability (%)") +
    xlab("Social Protection") +
    scale_x_discrete(labels = c("0" = "No", "1" = "Yes")) +
    theme_minimal() +
    scale_color_manual(values = c("Any" = "blue", "Government" = "red")) +  # Change color palette
    scale_linetype_manual(values=c("twodash", "dotted"))+
    theme(legend.position = "bottom") +
    theme(legend.title = element_blank()) +
    facet_wrap(~sub(".*_", "", df_name), ncol = 3)  # Split into two columns based on df_name suffix

  ggsave(file.path(config$outdir_lso, config$outdat_plot_pp), plot, width = 10, height = 8, dpi = 600)
  return(plot)
}

