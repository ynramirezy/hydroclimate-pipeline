# Setting global variables

n_days= 5
dates_runoff = dates[(n_days+1):length(dates)]
options(scipen = 999)
powiaty <- vect("pipeline/assets/gis_meta/Powiaty.shp")
outputs <- list(
  GIS_data_output= file.path(folder_pipeline, paste0("GIS_data_", polygon_name)), 
  DEM_output= file.path(folder_pipeline, paste0("DEM_", polygon_name)),
  TopographicWet_Index_output= file.path(folder_pipeline, paste0("TopographicWet_Index_", polygon_name)),
  Land_Cover_output= file.path(folder_pipeline, paste0("Land_Cover_", polygon_name)),
  Hydrological_Soil_output= file.path(folder_pipeline, paste0("Hydrological_Soil_", polygon_name)),
  Evapotranspiration_output= file.path(folder_pipeline, paste("Evapotranspiration", format(start_date, "%Y%m%d"), format(end_date, "%Y%m%d"), sep="_")),
  Precipitation_output= file.path(folder_pipeline, paste("Precipitation", format(start_date, "%Y%m%d"), format(end_date, "%Y%m%d"), sep="_")),
  Runoff_output= file.path(folder_pipeline, paste("Runoff", format(start_date, "%Y%m%d"), format(end_date, "%Y%m%d"), sep="_")),
  Antecedent_Moisture_output= file.path(folder_pipeline, paste("Antecedent_Moisture", format(start_date, "%Y%m%d"), format(end_date, "%Y%m%d"), sep="_")),
  Validation_output= file.path(folder_pipeline, paste("Validation", format(start_date, "%Y%m%d"), format(end_date, "%Y%m%d"), sep="_"))   
)

# Setting plotting options
palettes <- list(
  Land_Cover = read.csv("pipeline/assets/gis_meta/CLC_palette.txt", sep="\t"),
  Hydrological_Soil = read.csv("pipeline/assets/gis_meta/HSG_palette.txt", sep="\t"),
  Antecedent_Moisture = read.csv("pipeline/assets/gis_meta/AMC_palette.txt", sep="\t")
)
plot_options <- list(
  DEM = list( palette = terrain.colors(50), legend_title = "Elevation (m)" ),
  TopographicWet_Index = list( palette = rev(paletteer_c("grDevices::Purples 3", 50)), legend_title = "Dimensionless" ),
  Land_Cover = list( palette = "", legend_title = "Corine Land Cover classes" ),
  Hydrological_Soil = list( palette = "", legend_title = "HSG groups" ), 
  Evapotranspiration = list( palette = rev(paletteer_c("grDevices::YlGnBu", 50)), legend_title = "mm/day" ),
  Precipitation = list( palette = rev(paletteer_c("pals::kovesi.linear_bmw_5_95_c86", 50)), legend_title = "mm/day" ),
  Antecedent_Moisture = list( palette = "", legend_title = "AMC classes"  ),
  Runoff = list( palette = paletteer_c("grDevices::Oslo", 50), legend_title = "mm/day" )
)