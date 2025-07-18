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
source("pipeline/modules/precipitation_data.R")
source("pipeline/modules/runoff_data.R")
source("pipeline/modules/evapotranspiration_data.R")
source("pipeline/functions/dimension_reduction.R")
source("pipeline/functions/environment_settings.R")
source("pipeline/functions/evapotranspiration_webscraping.R")
source("pipeline/functions/geostatistical_interpolation.R")
source("pipeline/functions/harmonization.R")
source("pipeline/functions/precipitation_webscraping.R")
source("pipeline/functions/runoff_webscraping.R")

#Setting global variables
dates <- seq(start_date, end_date, by = "day")
evapotranspiration_output= file.path(getwd(), paste("evapotranspiration", format(start_date, "%Y%m%d"), format(end_date, "%Y%m%d"), sep="_"))
precipitation_output= file.path(getwd(), paste("precipitation", format(start_date, "%Y%m%d"), format(end_date, "%Y%m%d"), sep="_"))
runoff_output= file.path(getwd(), paste("runoff", format(start_date, "%Y%m%d"), format(end_date, "%Y%m%d"), sep="_"))