#Welcome to the Hydroclimate Data Pipeline for Runoff!
#This tool generates runoff rasters based on terrain features and SCS-CN methodology

# Please set the following parameters before running:
start_date <- as.Date("2020-06-15")
end_date <- as.Date("2020-06-25")

# Set the powiaty name or the shapefile path
pipeline_polygon <- c("Łęczyński", "Chełmski", "Włodawski")
#pipeline_polygon <- "../user_polygon.shp" 

#And load the pipeline modules and functions
setwd(dirname(rstudioapi::getSourceEditorContext()$path))
source("pipeline/global.R")

#Then, run the functions one by one and wait while the results are generated!
dem_data() 
topographicWet_index_data()
land_cover_data()
hydrological_soil_data()
evapotranspiration_data()
precipitation_data()
antecedent_moisture_data()
runoff_data()
validation_data()