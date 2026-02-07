harmonization<-function(variable) {
  
  tif_files <- list.files(path = file.path(outputs[[paste0(variable, "_output")]], paste0(variable, "_RAW")), pattern = "\\.tif$", full.names = TRUE)
  for (i in 1:length(tif_files)) {
    if (variable == "Evapotranspiration") {
      eva_84 <- crop(rast(tif_files[i]), vect(file.path(outputs[["GIS_data_output"]], paste0("clip_base_84.shp"))), mask=TRUE)
      raster_clipped <- project(eva_84, "EPSG:2180")
    } else {
      rast_p= rast(tif_files[i])
      crs(rast_p) <- crs("EPSG: 2180")
      raster_clipped <- mask(rast_p, vect(file.path(outputs[["GIS_data_output"]], "clip_base.shp")))
    }
    template <- rast(paste0(outputs[["DEM_output"]], "/DEM_", polygon_name, ".tif")) 
    resampled_r <- resample(raster_clipped, template, method = "cubic")
    raster_clipped <- crop(resampled_r, template, mask=TRUE)
    raster_clipped[raster_clipped < 0] <- 0
    pipeline_output(raster_clipped, variable, format(dates[i], "%Y%m%d"), length(tif_files), i)
  }

}
