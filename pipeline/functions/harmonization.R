harmonization<-function(start_date, end_date, variable, powiat_name) {
  
  tif_files <- list.files(path = file.path(get(paste0(variable, "_output")), paste0(variable, "_RAW")), pattern = "\\.tif$", full.names = TRUE)
  for (i in 1:length(tif_files)) {
    if (variable== "Evapotranspiration") {
      eva_84 <- crop(rast(tif_files[i]), vect(file.path(DEM_output, "GIS_data", paste0("clip_base_84.shp"))), mask=TRUE)
      raster_clipped <- project(eva_84, "EPSG:2180")
    } else {
      rast_p= rast(tif_files[i])
      crs(rast_p) <- crs("EPSG: 2180")
      raster_clipped <- mask(rast_p, vect(file.path(DEM_output, "GIS_data", "clip_base.shp")))
    }
    template <- rast(paste0(DEM_output, "/DEM/DEM_", paste(powiat_name, collapse = "_"), ".tif")) 
    resampled_r <- resample(raster_clipped, template, method = "cubic")
    raster_clipped <- crop(resampled_r, vect(file.path(DEM_output, "GIS_data", paste0("powiat_", paste(powiat_name, collapse = "_"), ".shp"))), mask=TRUE)
    raster_clipped[raster_clipped < 0] <- 0
    writeRaster(raster_clipped, file.path(get(paste0(variable, "_output")), paste0(variable, "_GeoTIFF"), paste0(variable, "_", format(dates[i], "%Y%m%d"), ".tif")), overwrite = TRUE)
    plot(raster_clipped, main=paste(variable, "of", paste(powiat_name, collapse = ", "), format(dates[i], "%Y%m%d")), font.main = 1)
    plot(vect(file.path(DEM_output, "GIS_data", paste0("powiat_", paste(powiat_name, collapse = "_"), ".shp"))), add=TRUE)
  }
  all_files <- list.files(file.path(DEM_output, "GIS_data"), full.names = TRUE)
  files_to_remove <- all_files[!grepl(paste0("^powiat_", paste(powiat_name, collapse = "_")), basename(all_files))]
  file.remove(files_to_remove)
  if (variable == "Evapotranspiration") {
    file.remove(tif_files)
  }
  cat(paste("\n\n\n\n✅ The hydroclimate pipeline for", variable, "branch successfully ran!\nData is located in: ", get(paste0(variable, "_output"))))
  
}
