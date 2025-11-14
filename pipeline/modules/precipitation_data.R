precipitation_data<- function(start_date, end_date, powiat_name) {
  
  if (!file.exists(file.path(DEM_output, paste0("/DEM/DEM_", paste(powiat_name, collapse = "_"), ".tif")))) {
    stop("❌ DEM file not found. Please run the DEM function before Precipitation")
  }
  environment_settings(start_date, end_date, powiat_name, "Precipitation")
  precipitation_webscraping(start_date, end_date)
  geostatistical_interpolation(start_date, end_date, "Precipitation")
  harmonization(start_date, end_date, "Precipitation", powiat_name)
  
}