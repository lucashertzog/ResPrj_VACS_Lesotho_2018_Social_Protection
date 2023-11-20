do_plot_map <- function(
    design,
    design_girls,
    design_boys
    
){
png("data_derived/fig_map_fmale.png", res = 250, height = 6000, width = 2000)

# Read the map data
lso_map <- st_read("G:/My Drive/Projects/vacs-lesotho/GIS/interactive/LSO1.geojson")
# Convert lso_map to data.table before joining
lso_map_dt <- setDT(lso_map)

# Calculate the proportion of 'sp_gov' by district for boys and girls separately
district_sp_gov_girls <- svyby(~sp_gov, ~district, design_girls, svymean, na.rm=TRUE)
district_sp_gov_boys <- svyby(~sp_gov, ~district, design_boys, svymean, na.rm=TRUE)
# Calculate the proportion of 'sp_gov' and 'sp_non_gov' by district
district_sp_gov <- svyby(~sp_gov+sp_non_gov, ~district, design, svymean, na.rm=TRUE)

# Create a data.table from the svyby object
district_sp_gov_girls_dt <- as.data.table(district_sp_gov_girls)
district_sp_gov_boys_dt <- as.data.table(district_sp_gov_boys)
# Create a data.table from the svyby object
district_sp_gov_dt <- as.data.table(district_sp_gov)

# Ensure that the district variable is a factor
district_sp_gov_girls_dt$district <- as.factor(district_sp_gov_girls_dt$district)
district_sp_gov_boys_dt$district <- as.factor(district_sp_gov_boys_dt$district)
# Ensure that the district variable is a factor
district_sp_gov_dt$district <- as.factor(district_sp_gov_dt$district)

# Correct district names in district_sp_gov_dt
district_sp_gov_girls_dt[district == "Botha-Botha", district := "Butha-Buthe"]
district_sp_gov_boys_dt[district == "Botha-Botha", district := "Butha-Buthe"]
# Correct district names in district_sp_gov_dt
district_sp_gov_dt[district == "Botha-Botha", district := "Butha-Buthe"]

# Join the summary statistics to the map data
lso_map_dt_girls <- lso_map_dt[district_sp_gov_girls_dt, on = c("ADM1_EN" = "district")]
lso_map_dt_boys <- lso_map_dt[district_sp_gov_boys_dt, on = c("ADM1_EN" = "district")]
# Join the summary statistics to the map data
lso_map_dt <- lso_map_dt[district_sp_gov_dt, on = c("ADM1_EN" = "district")]

# Convert back to sf object
lso_map_girls <- st_as_sf(lso_map_dt_girls)
lso_map_boys <- st_as_sf(lso_map_dt_boys)
# Convert back to sf object
lso_map <- st_as_sf(lso_map_dt)

# In case we want, save to shp
# st_write(lso_map_girls, file.path(config$outdir_lso, "lso_girls.shp"))
# st_write(lso_map_boys, file.path(config$outdir_lso, "lso_boys.shp"))
# st_write(lso_map , file.path(config$outdir_lso, "lso.shp"))

# Calculate the centroid of each district
lso_map_centroid <- st_centroid(lso_map)

# Add district names to the centroids object
lso_map_centroid$ADM1_EN <- lso_map$ADM1_EN

# Create a common theme
common_theme <- theme_minimal() +
  theme(legend.position = "bottom",
        legend.title = element_text(face = "bold", size = 14),
        legend.text = element_text(size = 12))

# After reading and transforming the map data, remove the transformation to UTM. 

# Create the first plot
plot1 <- ggplot() +
  geom_sf(data = lso_map, aes(fill = sp_gov), color = "black") +
  scale_fill_gradientn(name = "Social Protection (Government)",
                       colours = brewer.pal(9, "YlOrRd"),
                       labels = function(x) paste0(x*100)) +
  scale_x_continuous(labels = function(x) paste0(x, "°E")) +
  scale_y_continuous(labels = function(y) paste0(y, "°S")) +
  labs(x = "Longitude", y = "Latitude") +
  geom_sf_text(data = lso_map_centroid, aes(label = ADM1_EN), size = 5) +
  common_theme +
  annotation_scale(location = "bl", width_hint = 0.3) +  # Add scale bar
  annotation_north_arrow(location = "tr", which_north = "true", 
                         pad_x = unit(0.2, "in"), pad_y = unit(0.2, "in"),  # Add north arrow
                         style = north_arrow_fancy_orienteering)  

# Create the girls plot
plot3 <- ggplot() +
  geom_sf(data = lso_map_girls, aes(fill = sp_gov), color = "black") +
  scale_fill_gradientn(name = "Females",
                       colours = brewer.pal(5, "YlGn"),
                       labels = function(x) paste0(x*100)) +
  scale_x_continuous(labels = function(x) paste0(x, "°E")) +
  scale_y_continuous(labels = function(y) paste0(y, "°S")) +
  labs(x = "Longitude", y = "Latitude") +
  geom_sf_text(data = lso_map_centroid, aes(label = ADM1_EN), size = 5) +
  common_theme +
  annotation_scale(location = "bl", width_hint = 0.3) +  # Reduce size of scale bar
  annotation_north_arrow(location = "tr", which_north = "true", 
                         pad_x = unit(0.2, "in"), pad_y = unit(0.2, "in"),  # Add north arrow
                         style = north_arrow_fancy_orienteering) 

# Create the boys plot
plot4 <- ggplot() +
  geom_sf(data = lso_map_boys, aes(fill = sp_gov), color = "black") +
  scale_fill_gradientn(name = "Males",
                       colours = brewer.pal(5, "Blues"),
                       labels = function(x) paste0(x*100)) +
  scale_x_continuous(labels = function(x) paste0(x, "°E")) +
  scale_y_continuous(labels = function(y) paste0(y, "°S")) +
  labs(x = "Longitude", y = "Latitude") +
  geom_sf_text(data = lso_map_centroid, aes(label = ADM1_EN), size = 5) +
  common_theme +
  annotation_scale(location = "bl", width_hint = 0.3) +  # Reduce size of scale bar
  annotation_north_arrow(location = "tr", which_north = "true", 
                         pad_x = unit(0.2, "in"), pad_y = unit(0.2, "in"),  # Add north arrow
                         style = north_arrow_fancy_orienteering)

grid.arrange(plot1, plot3, plot4, ncol = 1)
dev.off()
}