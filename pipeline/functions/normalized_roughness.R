normalized_roughness <- function () {
  
  DEM <- rast(file.path(terrain_path, "DEM.tif"))
  DEM_sd_local <- focal(DEM, w = 5, fun = sd, na.rm = TRUE, pad = TRUE)
  #c as the local variability mean
  c_param <- global(DEM_sd_local, "mean", na.rm=TRUE)[1]
  c_raster <- DEM_sd_local
  values(c_raster) <- c_param
  #Roughness
  alpha_map <- DEM_sd_local / (DEM_sd_local + c_raster)
  alpha_map <- clamp(alpha_map, 0, 1)
  pipeline_output(alpha_map, "Roughness", 0, 1, 1)
  writeRaster(alpha_map, file.path(terrain_path, "Roughness.tif"), overwrite = TRUE)

}