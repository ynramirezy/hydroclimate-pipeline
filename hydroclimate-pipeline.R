#Welcome to the Hydroclimate Data Pipeline!
#This tool generates high-resolution daily rasters for precipitation, evapotranspiration, and runoff.

# Please set the following parameters before running:
start_date <- as.Date("2024-08-20")
end_date <- as.Date("2024-08-21")

# Set the powiaty name or the shapefile path
pipeline_polygon <- c("Białostocki")
#pipeline_polygon <- c("Lubiński", "Polkowicki", "Głogowski")
#pipeline_polygon <- "../user/polygon.shp"

#And load the pipeline modules and functions
setwd(dirname(rstudioapi::getSourceEditorContext()$path))
source("pipeline/global.R")

#Then, run the desired function and wait while the results are generated!
dem_data(pipeline_polygon)
evapotranspiration_data(start_date, end_date, pipeline_polygon)
precipitation_data(start_date, end_date, pipeline_polygon)
runoff_data(start_date, end_date, pipeline_polygon)

#Hydroclimate variables statistics by slope
slope_data("Runoff")
slope_data("Precipitation")
slope_data("Evapotranspiration")
