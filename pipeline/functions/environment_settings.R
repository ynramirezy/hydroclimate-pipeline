environment_settings<- function(start_date, end_date, powiat_name, variable) {
  
  dir.create(get(paste0(variable, "_output")))
  dir.create(file.path(get(paste0(variable, "_output")), paste(variable, "RAW", sep="_")))
  dir.create(file.path(get(paste0(variable, "_output")), paste(variable, "GeoTIFF", sep="_")))
  if (!dir.exists(file.path(DEM_output, "GIS_data"))) {
    dir.create(file.path(DEM_output, "GIS_data"), recursive = TRUE)
  }
  powiaty <- vect("pipeline/assets/gis_meta/Powiaty.shp")
  powiat <- powiaty[powiaty$Name %in% powiat_name, ]  
  if (!file.exists(file.path(DEM_output, "GIS_data", paste(powiat_name, collapse = "_"), ".shp"))) {
    writeVector(powiat, file.path(DEM_output, "GIS_data", paste0("powiat_", paste(powiat_name, collapse = "_"), ".shp")), overwrite = TRUE)
  }
  if (!file.exists(file.path(DEM_output, "GIS_data", "clip_base.shp"))) {
    clip_base <- as.polygons(ext(powiat)*1.3)
    crs(clip_base) <- crs(powiat)
    writeVector(clip_base, file.path(DEM_output, "GIS_data", "clip_base.shp"), overwrite = TRUE)    
  }
  if (variable == 'runoff') {
    r <- rast(ext(powiat), resolution = 1000, crs = "EPSG:2180")
    values(r) <- 0
    writeRaster(crop(r, powiat, mask=TRUE), file.path(DEM_output, "GIS_data", "zero_raster.tif"), overwrite = TRUE)
  }
 
}

