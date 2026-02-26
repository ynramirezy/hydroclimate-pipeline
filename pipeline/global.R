#Setting the pipeline environment
source("renv/activate.R")
if (!requireNamespace("renv", quietly = TRUE)) install.packages("renv")
if (!renv::status()$synchronized) {
  message("Setting environmet for fisrt time, it can take some minutes...")
  renv::restore(confirm = FALSE)
}

#Loading libraries
required_packages <- c("automap", "climate", "data.table", "dplyr", "FNN", "gstat", "httr", "lubridate", "raster", "sp", "terra", "whitebox")
invisible(lapply(required_packages, library, character.only = TRUE))
if (!whitebox::wbt_init()) {
  message("Whitebox engine not found. Installing...")
  whitebox::wbt_install()
}

#Loading project sources
source("pipeline/modules/antecedent_moisture_data.R")
source("pipeline/modules/dem_data.R")
source("pipeline/modules/evapotranspiration_data.R")
source("pipeline/modules/hydrological_soil_data.R")
source("pipeline/modules/land_cover_data.R")
source("pipeline/modules/precipitation_data.R")
source("pipeline/modules/runoff_data.R")
source("pipeline/modules/topographicWet_index_data.R")
source("pipeline/modules/validation_data.R")
source("pipeline/functions/antecedent_moisture_condition.R")
source("pipeline/functions/cleanup.R")
source("pipeline/functions/clipping.R")
source("pipeline/functions/dimension_reduction.R")
source("pipeline/functions/environment_settings.R")
source("pipeline/functions/evapotranspiration_webscraping.R")
source("pipeline/functions/geostatistical_interpolation.R")
source("pipeline/functions/harmonization.R")
source("pipeline/functions/normalized_roughness.R")
source("pipeline/functions/pipeline_output.R")
source("pipeline/functions/precipitation_webscraping.R")
source("pipeline/functions/runoff_CNSCS.R")
source("pipeline/functions/topo_wet_index.R")
source("pipeline/functions/validation_runoff.R")
source("pipeline/functions/validation_statistics.R")

#Setting the output folder
existing <- list.dirs(path = getwd(), full.names = FALSE, recursive = FALSE)
existing <- existing[grepl("^hydroclimate-pipeline_OUTPUT_", existing)]
next_num <- if(length(existing) == 0) 1 else max(as.integer(sub(".*_(\\d+)$", "\\1", existing))) + 1
folder_pipeline <- paste0(getwd(), "/hydroclimate-pipeline_OUTPUT_", next_num)
dir.create(folder_pipeline)

#Dates for runoff susceptibility index
dates <- seq(start_date, end_date, by = "day")
if (format(start_date, "%Y") < 1960 || start_date > Sys.Date()) {
  stop(paste0("❌ Invalid input: You provided dates out of the range analysis"))
}
if(length(dates)<6) {
  stop(paste0("❌ Invalid input: You provided ", length(dates), " days, but at least 6 days are required to estimate the Runoff Susceptibility Index"))
}

#Adjusting pipeline_polygon name
clean_names <- function(x) {
  x <- iconv(x, to = "ASCII//TRANSLIT")
  x <- gsub("[^[:alnum:]]", "_", x)    
  return(x)
}
powiay_list= read.csv("powiaty_library.csv", encoding = "UTF-8")
if (length(pipeline_polygon) == 1 && grepl("\\.shp$", pipeline_polygon, ignore.case = TRUE) && file.exists(pipeline_polygon)) {
  polygon_name <- "User_polygon"
  polygon_mode= "user"   
} else if (all(pipeline_polygon %in% powiay_list$Name)) {
  if(length((pipeline_polygon))>2) {
    polygon_name <- paste(clean_names(pipeline_polygon[1]), clean_names(pipeline_polygon[2]), "etc", sep="_")
  } else {
    polygon_name <- paste(clean_names(pipeline_polygon), collapse = "_")
  }
  polygon_mode= "powiat"  
} else {
  stop("❌ Invalid input: please provide a valid vector of powiaty names or a .shp file path.")
}    

#Setting global variables
n_days= 5
options(scipen = 999)
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
  Validation_output= file.path(folder_pipeline, paste("Validation", format(start_date, "%Y%m%d"), format(end_date, "%Y%m%d"), sep="_"))   
)
