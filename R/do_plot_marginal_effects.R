do_plot_marginal_effects <- function(
    marginal_effects_list
){
  


# Set up the plotting area with two subplots
# par(mfrow = c(1, 2))

# Retrieve values from the data frame
edu_enrol_sp_any <- marginal_effects_list$edu_enrol_sp_any
x <- edu_enrol_sp_any$x
y1 <- edu_enrol_sp_any$predicted * 100
ci1_low <- edu_enrol_sp_any$conf.low * 100
ci1_high <- edu_enrol_sp_any$conf.high * 100

edu_attainment_sp_any <- marginal_effects_list$edu_attainment_sp_any
y2 <- edu_attainment_sp_any$predicted * 100
ci2_low <- edu_attainment_sp_any$conf.low * 100
ci2_high <- edu_attainment_sp_any$conf.high * 100

srh_condom_use_sp_any <- marginal_effects_list$srh_condom_use_sp_any
y3 <- srh_condom_use_sp_any$predicted * 100
ci3_low <- srh_condom_use_sp_any$conf.low * 100
ci3_high <- srh_condom_use_sp_any$conf.high * 100

par(mar=c(5,4,3,1),mgp=c(3,1,0),las=1,cex.axis=0.9,cex.lab=1)

# Plotting
plot(x, y1, bty = "L", type = "n", xlab = "Social Protection", ylab = "Predicted Probability (%)", ylim = c(0, 100), xaxt = "n")
# Add labels in the middle of each section
axis(1, at = c(mean(x) - 0.3, mean(x) + 0.3), labels = c("No", "Yes"), padj = 0, tck = -0.03)

# Calculate adjusted x-axis coordinates for the second and third sets of error bars
x_adj1 <- ifelse(x == 0, x + 0.2, x - 0.2)
x_adj2 <- ifelse(x == 0, x + 0.4, x - 0.4)

arrows(x, ci1_low, x, ci1_high, angle = 90, code = 3, length = 0.1, col = "#00AFBB", lwd = 3)
arrows(x_adj1, ci2_low, x_adj1, ci2_high, angle = 90, code = 3, length = 0.1, col = "#E7B800", lwd = 3)
arrows(x_adj2, ci3_low, x_adj2, ci3_high, angle = 90, code = 3, length = 0.1, col = "red", lwd = 3)

points(x, y1, pch = 19, col = "#00AFBB")
points(x_adj1, y2, pch = 15, col = "#E7B800")
points(x_adj2, y3, pch = 17, col = "red")

lines(x, y1, col = "#00AFBB" ,lwd = 2)
lines(x_adj1, y2, col = "#E7B800", lty = 2, lwd = 2)
lines(x_adj2, y3, col = "red", lty = 3, lwd = 2)

# Add a vertical line in the middle
abline(v = 0.5, lty = 2)

# Add horizontal lines corresponding to each 20%
abline(h = seq(0, 100, by = 10), col = "grey", lty = 2, lwd = 1)

# Create legends for each variable
legend("bottomright", 
       title = "Outcome",
       legend = c("Enrolled in school", "Educational attainment", "Consistent condom use"),
       col = c("#00AFBB", "#E7B800", "red"), 
       lty = c(1, 2, 3),
       pch = c(19, 15, 17),
       cex = 0.5)
}