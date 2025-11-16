evapotranspiration_data<- function(start_date, end_date, pipeline_polygon) {
  
  if (!file.exists(file.path(DEM_output, paste0("/DEM/DEM_", polygon_name, ".tif")))) {
    stop("❌ DEM file not found. Please run the DEM function before Evapotranspiration")
  }
  environment_settings(start_date, end_date, pipeline_polygon, "Evapotranspiration")
  evapotranspiration_webscraping(start_date, end_date)
  dimension_reduction(start_date, end_date)
  harmonization(start_date, end_date, "Evapotranspiration", pipeline_polygon) 
  
}