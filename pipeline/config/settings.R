# Setting global variables

n_days= 5
dates_runoff = dates[(n_days+1):length(dates)]
options(scipen = 999)
powiaty <- vect("pipeline/assets/gis_meta/Powiaty.shp")

# Setting pipeline paths
terrain_path <- file.path(folder_pipeline, paste0("SCSCN_Inputs_", polygon_name), "Terrain_features")
soil_path <- file.path(folder_pipeline, paste0("SCSCN_Inputs_", polygon_name), "Soil_constants")
hydroclimate_path <- file.path(folder_pipeline, paste0("SCSCN_Inputs_", polygon_name), "Hydroclimate_variables")
GIS_path <- file.path(folder_pipeline, paste0("SCSCN_Inputs_", polygon_name), "GIS_data")

outputs <- list(
  DEM= terrain_path,
  Roughness= terrain_path,
  TopographicWet_Index= terrain_path,
  Land_Cover= soil_path,
  Hydrological_Soil= soil_path,
  Evapotranspiration= file.path(hydroclimate_path, paste("Evapotranspiration", format(start_date, "%Y%m%d"), format(end_date, "%Y%m%d"), sep="_")),
  Precipitation= file.path(hydroclimate_path, paste("Precipitation", format(start_date, "%Y%m%d"), format(end_date, "%Y%m%d"), sep="_")),
  Antecedent_Moisture= file.path(hydroclimate_path, paste("Antecedent_Moisture", format(dates_runoff[1], "%Y%m%d"), format(end_date, "%Y%m%d"), sep="_")),
  Runoff= file.path(folder_pipeline, paste("Terrain_based_Runoff", format(dates_runoff[1], "%Y%m%d"), format(end_date, "%Y%m%d"), sep="_")),
  Validation= file.path(folder_pipeline, "ERA5_Land_Runoff_Validation")   
)

# Setting plotting options
palettes <- list(
  Land_Cover = read.csv("pipeline/assets/gis_meta/CLC_palette.txt", sep="\t"),
  Hydrological_Soil = read.csv("pipeline/assets/gis_meta/HSG_palette.txt", sep="\t"),
  Antecedent_Moisture = read.csv("pipeline/assets/gis_meta/AMC_palette.txt", sep="\t")
)
plot_options <- list(
  DEM = list( palette = terrain.colors(50), legend_title = "Elevation (m)"),
  Roughness = list( palette = rev(paletteer_c("grDevices::Greens 3", 50)), legend_title = "Dimensionless" ),
  TopographicWet_Index = list( palette = rev(paletteer_c("grDevices::Purples 3", 50)), legend_title = "Dimensionless" ),
  Land_Cover = list( palette = "", legend_title = "Corine Land Cover classes" ),
  Hydrological_Soil = list( palette = "", legend_title = "HSG groups" ), 
  Evapotranspiration = list( palette = rev(paletteer_c("grDevices::YlGnBu", 50)), legend_title = "mm/day" ),
  Precipitation = list( palette = rev(paletteer_c("pals::kovesi.linear_bmw_5_95_c86", 50)), legend_title = "mm/day" ),
  Antecedent_Moisture = list( palette = "", legend_title = "AMC classes"  ),
  Runoff = list( palette = paletteer_c("grDevices::Oslo", 50), legend_title = "mm/day" )
)

dir.create(file.path(outputs[["Validation"]]))
pdf(file.path(outputs[["Validation"]], "Pipeline_Rplots.pdf"), width=12, height=9)