#Loading libraries
required_packages <- c(
  "raster", "httr", "terra", "lubridate", "climate", "data.table", "whitebox",
  "automap", "gstat", "sp", "sf", "dplyr", "FNN", "paletteer"
)

install_if_missing <- function(pkg) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg, dependencies = TRUE)
  }
  library(pkg, character.only = TRUE)
}
invisible(lapply(required_packages, install_if_missing))wbt_install() 

#Loading project sources
source("pipeline/modules/antecedent_moisture_data.R")
source("pipeline/modules/dem_data.R")
source("pipeline/modules/evapotranspiration_data.R")
source("pipeline/modules/hydrological_soil_data.R")
source("pipeline/modules/land_cover_data.R")
source("pipeline/modules/precipitation_data.R")
source("pipeline/modules/runoff_data.R")
source("pipeline/modules/topographicWet_index_data.R")
source("pipeline/modules/vulnerabilty_runoff_data.R")
source("pipeline/functions/antecedent_moisture_condition.R")
source("pipeline/functions/cleanup.R")
source("pipeline/functions/clipping.R")
source("pipeline/functions/dimension_reduction.R")
source("pipeline/functions/environment_settings.R")
source("pipeline/functions/evapotranspiration_webscraping.R")
source("pipeline/functions/geostatistical_interpolation.R")
source("pipeline/functions/harmonization.R")
source("pipeline/functions/pipeline_output.R")
source("pipeline/functions/precipitation_webscraping.R")
source("pipeline/functions/runoff.R")
source("pipeline/functions/topo_wet_index.R")
source("pipeline/functions/vulnerability_runoff.R")

#Setting the output folder
existing <- list.dirs(path = getwd(), full.names = FALSE, recursive = FALSE)
existing <- existing[grepl("^hydroclimate-pipeline_OUTPUT_", existing)]
next_num <- if(length(existing) == 0) 1 else max(as.integer(sub(".*_(\\d+)$", "\\1", existing))) + 1
folder_pipeline <- paste0(getwd(), "/hydroclimate-pipeline_OUTPUT_", next_num)
dir.create(folder_pipeline)

#Adjusting pipeline_polygon name
powiay_list= read.csv("powiaty_library.csv", encoding = "UTF-8")
if (length(pipeline_polygon) == 1 && grepl("\\.shp$", pipeline_polygon, ignore.case = TRUE) && file.exists(pipeline_polygon)) {
  polygon_name <- "User_polygon"
  polygon_mode= "user"   
} else if (all(pipeline_polygon %in% powiay_list$Name)) {
  polygon_name <- paste(pipeline_polygon, collapse = "_")
  polygon_mode= "powiat"  
} else {
  stop("❌ Invalid input: please provide a valid vector of powiaty names or a .shp file path.")
}    

#Setting global variables
n_days= 5
options(scipen = 999)
dates <- seq(start_date, end_date, by = "day")
powiaty <- vect("pipeline/assets/gis_meta/Powiaty.shp")
outputs <- list(
  GIS_data_output= file.path(folder_pipeline, paste0("GIS_data_", polygon_name)), 
  DEM_output= file.path(folder_pipeline, paste0("DEM_", polygon_name)),
  TopographicWet_index_output= file.path(folder_pipeline, paste0("TopographicWet_index_", polygon_name)),
  Land_Cover_output= file.path(folder_pipeline, paste0("Land_Cover_", polygon_name)),
  Hydrological_Soil_output= file.path(folder_pipeline, paste0("Hydrological_Soil_", polygon_name)),
  Evapotranspiration_output= file.path(folder_pipeline, paste("Evapotranspiration", format(start_date, "%Y%m%d"), format(end_date, "%Y%m%d"), sep="_")),
  Precipitation_output= file.path(folder_pipeline, paste("Precipitation", format(start_date, "%Y%m%d"), format(end_date, "%Y%m%d"), sep="_")),
  Runoff_output= file.path(folder_pipeline, paste("Runoff", format(start_date, "%Y%m%d"), format(end_date, "%Y%m%d"), sep="_")),
  Antecedent_Moisture_output= file.path(folder_pipeline, paste("Antecedent_Moisture", format(start_date, "%Y%m%d"), format(end_date, "%Y%m%d"), sep="_")),
  Vulnerability_Runoff_output= file.path(folder_pipeline, paste("Vulnerability_Runof", format(start_date, "%Y%m%d"), format(end_date, "%Y%m%d"), sep="_"))
)
