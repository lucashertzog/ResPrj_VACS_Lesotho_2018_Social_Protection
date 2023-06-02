# # Fit the models
# fit_any <- svyglm(
#   srh_condom_use ~ sp_any + age + sex + hiv + orphan, 
#   design = design,
#   family = binomial(),
#   data = vacs_lso)
# 
# fit_gov <- svyglm(
#   srh_condom_use ~ sp_gov + age + sex + hiv + orphan, 
#   design = design,
#   family = binomial(),
#   data = vacs_lso)
# 
# fit_non_gov <- svyglm(
#   srh_condom_use ~ sp_non_gov + age + sex + hiv + orphan, 
#   design = design,
#   family = binomial(),
#   data = vacs_lso)
# 
# fit_double <- svyglm(
#   srh_condom_use ~ sp_double + age + sex + hiv + orphan, 
#   design = design,
#   family = binomial(),
#   data = vacs_lso)
# 
# # Create ggpredict objects
# p_any <- ggpredict(fit_any, terms = c("sex", "sp_any"))
# p_gov <- ggpredict(fit_gov, terms = c("sex", "sp_gov"))
# p_non_gov <- ggpredict(fit_non_gov, terms = c("sex", "sp_non_gov"))
# p_double <- ggpredict(fit_double, terms = c("sex", "sp_double"))
# 
# # Combine the ggpredict objects
# combined_p <- rbind(p_non_gov, p_gov, p_double, p_any)
# 
# # Plot the graph
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# fit <- svyglm(
#   srh_condom_use ~ sp_any + age + sex + hiv + orphan, 
#   design = design,
#   family = binomial(),
#   data = vacs_lso)
# 
# 
# p <- ggpredict(fit, terms = c("sp_any", "sex"))
# 
# plot <- ggplot(p, aes(x = as.factor(x), y = predicted * 100, ymin = conf.low * 100, ymax = conf.high * 100, color = factor(group))) +
#   geom_errorbar(position = position_dodge(0.9), width = 0.2, size = 1.5) +
#   geom_point(position = position_dodge(0.9), size = 3, shape = 21, fill = "white") +
#   geom_text(aes(label = paste0(round(predicted * 100), "%")), vjust = -1.5) +
#   labs(x = "Social Protection", y = "Predicted Probability (%)", color = "Sex") +
#   scale_x_discrete(breaks = c(0, 1), labels = c("No", "Yes")) +
#   scale_color_manual(values = c("#00BFC4", "#F8766D"), labels = c("Male", "Female")) +
#   theme_minimal()
# 
# print(plot)
# 
# 
# 
# 
# plot(p,
#      ci = TRUE,
#      ci.style = c("errorbar")
#      )
