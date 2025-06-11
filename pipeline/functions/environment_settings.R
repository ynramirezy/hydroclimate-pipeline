environment_settings<- function(start_date, end_date, powiat_name, variable) {
  
  dir.create(get(paste0(variable, "_output")))
  dir.create(file.path(get(paste0(variable, "_output")), paste(variable, "raw", sep="_")))
  dir.create(file.path(get(paste0(variable, "_output")), "GIS_data"))
  dir.create(file.path(get(paste0(variable, "_output")), paste(variable, "GeoTIFF", sep="_")))
  powiaty <- vect("pipeline/assets/Powiaty.shp")
  powiat <- powiaty[powiaty$Name == powiat_name, ][1]
  writeVector(powiat, file.path(get(paste0(variable, "_output")), "GIS_data", paste0("powiat_", powiat_name, ".shp")), overwrite = TRUE)
  clip_base <- as.polygons(ext(powiat)*1.3)
  crs(clip_base) <- crs(powiat)
  writeVector(clip_base, file.path(get(paste0(variable, "_output")), "GIS_data", "clip_base.shp"), overwrite = TRUE)
  if (variable == 'runoff') {
    r <- rast(ext(powiat), resolution = 1000, crs = "EPSG:2180")
    values(r) <- 0
    writeRaster(crop(r, powiat, mask=TRUE), file.path(get(paste0(variable, "_output")), "GIS_data", "zero_raster.tif"), overwrite = TRUE)
  }
 
}

