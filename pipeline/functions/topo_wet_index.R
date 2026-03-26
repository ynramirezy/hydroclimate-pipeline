topo_wet_index<- function() {
  
  dem_path <- file.path(terrain_path, "DEM.tif") 
  dem_filled <- file.path(terrain_path, "DEM_filled.tif")
  invisible(capture.output(
    wbt_fill_depressions(dem_path, dem_filled, verbose = FALSE)
  ))
  depth_rast <- rast(dem_filled) - rast(dem_path)
  depth_rast[depth_rast < 0.1] <- 0
  weight <- log1p(depth_rast)
  T_norm <- (weight - global(weight, "min", na.rm=T)[1,1]) / 
    (global(weight, "max", na.rm=T)[1,1] - global(weight, "min", na.rm=T)[1,1])
  pipeline_output(T_norm, "TopographicWet_Index", 0, 1, 1)

}