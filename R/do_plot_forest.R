#' Forest plot with results from regressions
#'
#' @param dir 
#' @param dat 
#'
#' @return
#' @export
#'
#' @examples
do_plot_forest <- function(
    dir,
    dat
){

png("data_derived/fig_forestplot_fmale.png", res = 250, height = 3000, width = 2500)
# Load data
data_path <- 'C:/Users/291828h/OneDrive - Curtin/projects/ResPrj_VACS_Lesotho_2018_Social_Protection/data_derived/f_plot.csv'
data <- read.csv(data_path)

# Define variables
variables_order_spaced <- rev(c(
  "Enrolled\nin school",
  "Educational\nattainment",
  "Engaged in\nany paid work",
  "Consistent\ncondom use",
  "Multiple\nsexual partners",
  "Transactional\nsex",
  "Child\nmarriage"))

# Rename groups
names(data)[names(data) == 'aOR_gov'] <- 'Government (Females & Males)'
names(data)[names(data) == 'girls_gov_aOR'] <- 'Government (Females)'
names(data)[names(data) == 'boys_gov_aOR'] <- 'Government (Males)'
names(data)[names(data) == 'aOR_nongov'] <- 'Non-Government (Females & Males)'
names(data)[names(data) == 'girls_nongov_aOR'] <- 'Non-Government (Females)'
names(data)[names(data) == 'boys_nongov_aOR'] <- 'Non-Government (Males)'

# Group names
groups <- names(data)[seq(2, length(data), by = 4)]

# Column names
aOR_columns <- names(data)[seq(2, length(data), by = 4)]
lb_columns <- names(data)[seq(3, length(data), by = 4)]
ub_columns <- names(data)[seq(4, length(data), by = 4)]
p_columns <- names(data)[seq(5, length(data), by = 4)]

# Positions
positions <- 1:length(variables_order_spaced)

# Colors and shape
# colors <- c('#0066CC', '#006666', '#FF3300', '#6666FF', '#00CC33', '#FF9900')
colors <- rep('#000000', length(groups))  # All lines black
shapes <- c(15, 17, 19, 0, 24, 21)

# Offsets
offsets <- seq(-0.3, 0.3, length.out = length(groups))

# Create data for ggplot
plot_data <- data.frame()
for(i in seq_along(groups)) {
  temp_data <- data.frame(
    group = groups[i],
    aOR = data[[aOR_columns[i]]],
    lb = data[[lb_columns[i]]],
    ub = data[[ub_columns[i]]],
    p = data[[p_columns[i]]],
    position = length(positions) - positions + 1 + offsets[i]  # Reverse the order here
  )
  plot_data <- rbind(plot_data, temp_data)
}

# Create linewidth variable based on p-value
plot_data$linewidth <- ifelse(plot_data$p < 0.05, 1.0, 0.5)

# Create asterisks variable and label for p-value
assign_asterisks <- function(p) {
  if (is.na(p)) return("")
  else if (p < 0.001) return("***")
  else if (p < 0.01) return("**")
  else if (p < 0.05) return("*")
  else return("")
}

# Assign asterisks
plot_data$asterisks <- sapply(plot_data$p, assign_asterisks)

# Format p-values
plot_data$p_label <- formatC(plot_data$p, format = "f", digits = 4, flag="#")

# Assign bold font face for significant p-values
plot_data$p_label_face <- ifelse(plot_data$p < 0.05 & !is.na(plot_data$p), "bold", "plain")


# Plot
ggplot(plot_data, 
       aes(x = aOR, 
           y = position, 
           color = group)) +
  geom_point(aes(shape = group), 
             size = 3) +
  geom_errorbarh(aes(xmin = lb, 
                     xmax = ub), 
                 height = 0.05, 
                 linewidth = plot_data$linewidth) + # Set the width of the error bars
  scale_shape_manual(values = shapes) +
  scale_color_manual(values = colors) +
  geom_vline(xintercept = c(1), 
             linetype = "dashed", 
             color = "red") +
  labs(x = 'Adjusted Odds Ratios (aOR)', 
       y = '') +
  scale_y_reverse(breaks = positions, 
                  labels = variables_order_spaced) +  # Update to use continuous y scale
  coord_cartesian(xlim = c(0, 10), 
                  ylim = c(min(positions) - 0.1, max(positions) + 0.1), 
                  clip = "off") + 
  scale_x_continuous(breaks = seq(0, 9, by = 1)) +
  theme_bw() +
  theme(legend.position = "bottom",
        legend.key.size = unit(1, "lines"),
        axis.text.y = element_text(size = 14)) +
  geom_text(aes(label = paste0('p=', p_label, asterisks), 
                x = 10, 
                fontface = p_label_face), 
            hjust = 1, size = 4, show.legend = FALSE) +
  guides(color = guide_legend(title = NULL), shape = guide_legend(title = NULL))

dev.off()
}