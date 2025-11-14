#Loading libraries
required_packages <- c(
  "raster", "httr", "terra", "lubridate", "climate",
  "automap", "gstat", "sp", "sf", "dplyr", "FNN"
)
install_if_missing <- function(pkg) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg, dependencies = TRUE)
  }
  library(pkg, character.only = TRUE)
}
invisible(lapply(required_packages, install_if_missing))

#Loading project sources
source("pipeline/modules/dem_data.R")
source("pipeline/modules/evapotranspiration_data.R")
source("pipeline/modules/precipitation_data.R")
source("pipeline/modules/runoff_data.R")
source("pipeline/functions/dem_settings.R")
source("pipeline/functions/dimension_reduction.R")
source("pipeline/functions/environment_settings.R")
source("pipeline/functions/evapotranspiration_webscraping.R")
source("pipeline/functions/geostatistical_interpolation.R")
source("pipeline/functions/harmonization.R")
source("pipeline/functions/precipitation_webscraping.R")
source("pipeline/functions/runoff_webscraping.R")

#Setting the output folder
existing <- list.dirs(path = getwd(), full.names = FALSE, recursive = FALSE)
existing <- existing[grepl("^hydroclimate-pipeline_OUTPUT_", existing)]
next_num <- if(length(existing) == 0) 1 else max(as.integer(sub(".*_(\\d+)$", "\\1", existing))) + 1
folder_pipeline <- paste0(getwd(), "/hydroclimate-pipeline_OUTPUT_", next_num)
dir.create(folder_pipeline)

#Setting global variables
dates <- seq(start_date, end_date, by = "day")
Evapotranspiration_output= file.path(folder_pipeline, paste("Evapotranspiration", format(start_date, "%Y%m%d"), format(end_date, "%Y%m%d"), sep="_"))
Precipitation_output= file.path(folder_pipeline, paste("Precipitation", format(start_date, "%Y%m%d"), format(end_date, "%Y%m%d"), sep="_"))
Runoff_output= file.path(folder_pipeline, paste("Runoff", format(start_date, "%Y%m%d"), format(end_date, "%Y%m%d"), sep="_"))
DEM_output= file.path(folder_pipeline, paste0("DEM_", paste(powiat_name, collapse = "_")))