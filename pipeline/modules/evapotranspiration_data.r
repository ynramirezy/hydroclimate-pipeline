evapotranspiration_data<- function(start_date, end_date, powiat_name) {
  
  if (!file.exists(file.path(DEM_output, paste0("/DEM/DEM_", paste(powiat_name, collapse = "_"), ".tif")))) {
    stop("❌ DEM file not found. Please run the DEM function before Evapotranspiration")
  }
  environment_settings(start_date, end_date, powiat_name, "Evapotranspiration")
  evapotranspiration_webscraping(start_date, end_date)
  dimension_reduction(start_date, end_date)
  harmonization(start_date, end_date, "Evapotranspiration", powiat_name) 
  
}