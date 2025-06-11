harmonization<-function(start_date, end_date, variable, powiat_name) {
  
  tif_files <- list.files(path = file.path(get(paste0(variable, "_output")), paste0(variable, "_raw")), pattern = "\\.tif$", full.names = TRUE)
  for (i in 1:length(tif_files)) {
    if (variable== "evapotranspiration") {
      eva_84 <- crop(rast(tif_files[i]), vect(file.path(evapotranspiration_output, "GIS_data", paste0("clip_base_84.shp"))), mask=TRUE)
      raster_clipped <- project(eva_84, "EPSG:2180")
    } else {
      rast_p= rast(tif_files[i])
      crs(rast_p) <- crs("EPSG: 2180")
      raster_clipped <- mask(rast_p, vect(file.path(get(paste0(variable, "_output")), "GIS_data", "clip_base.shp")))
    }
    template <- rast(ext(raster_clipped), res=30)
    resampled_r <- resample(raster_clipped, template, method = "cubic")
    raster_clipped <- crop(resampled_r, vect(file.path(get(paste0(variable, "_output")), "GIS_data", paste0("powiat_", powiat_name, ".shp"))), mask=TRUE)
    raster_clipped[raster_clipped < 0] <- 0
    writeRaster(raster_clipped, file.path(get(paste0(variable, "_output")), paste0(variable, "_GeoTIFF"), paste0(variable, "_", format(dates[i], "%Y%m%d"), ".tif")), overwrite = TRUE)
    plot(raster_clipped, main=paste(powiat_name, variable, format(dates[i], "%Y%m%d")), font.main = 1)
  }
  #Setting the final environment
  base_names <- c("clip_base", "clip_base_84", "zero_raster")
  extensions <- c(".shp", ".shx", ".dbf", ".prj", ".cpg", ".qpj", ".tif")
  for (i in 1:length(base_names)) {
    files <- file.path(get(paste0(variable, "_output")), "GIS_data", paste0(base_names[i], extensions))
    file.remove(files[file.exists(files)])
  }
  if (variable == 'runoff') {
    invisible(file.remove(tif_files))
  }
  cat(paste("\n\n\n\nThe hydroclimate pipeline successfully ran!\nData is located in: ", getwd()))
  
}
