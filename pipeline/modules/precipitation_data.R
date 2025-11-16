precipitation_data<- function(start_date, end_date, pipeline_polygon) {
  
  if (!file.exists(file.path(DEM_output, paste0("/DEM/DEM_", polygon_name, ".tif")))) {
    stop("❌ DEM file not found. Please run the DEM function before Precipitation")
  }
  environment_settings(start_date, end_date, pipeline_polygon, "Precipitation")
  precipitation_webscraping(start_date, end_date)
  geostatistical_interpolation(start_date, end_date, "Precipitation")
  harmonization(start_date, end_date, "Precipitation", pipeline_polygon)
  
}