normalized_roughness <- function () {
  
  DEM <- rast(file.path(outputs[["DEM_output"]], paste0("DEM_", polygon_name, ".tif")))
  DEM_sd_local <- focal(DEM, w = 5, fun = sd, na.rm = TRUE, pad = TRUE)
  #c as the local variability mean
  c_param <- global(DEM_sd_local, "mean", na.rm=TRUE)[1]
  c_raster <- DEM_sd_local
  values(c_raster) <- c_param
  #Roughness
  alpha_map <- DEM_sd_local / (DEM_sd_local + c_raster)
  alpha_map <- clamp(alpha_map, 0, 1)
  writeRaster(alpha_map, file.path(outputs[["DEM_output"]], paste0("Roughness_", polygon_name, ".tif")), overwrite = TRUE)

}