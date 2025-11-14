dem_settings<- function(powiat_name) {
  
  dir.create(file.path(DEM_output, "DEM"), recursive = TRUE)
  powiaty <- vect("pipeline/assets/gis_meta/Powiaty.shp")
  powiat <- powiaty[powiaty$Name %in% powiat_name, ]
  dem <- rast("pipeline/assets/gis_meta/DEM.tif")
  dem_clipped <- crop(dem, powiat, mask=TRUE)
  plot(dem_clipped, main= paste("DEM of", paste(powiat_name, collapse = ", ")), font.main = 1)
  plot(powiat, add=TRUE)
  writeRaster(dem_clipped, paste0(DEM_output, "/DEM/DEM_", paste(powiat_name, collapse = "_"), ".tif"), overwrite=TRUE, filetype="GTiff")
  cat(paste("\n\n\n\n✅ The hydroclimate pipeline for DEM branch successfully ran!\nData is located in: ", DEM_output))
  
}

