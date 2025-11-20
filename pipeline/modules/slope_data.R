slope_data<- function(variable_slope) {
  
  if (!file.exists(file.path(DEM_output, paste0("/DEM/DEM_", polygon_name, ".tif")))) {
    stop("❌ DEM file not found. Please run the DEM function before Runoff")
  }
  slope_statistics(variable_slope)
  
}