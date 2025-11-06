dem_settings<- function(powiat_name) {
  
  dir.create(paste0(file.path(getwd()), "/dem_", powiat_name))
  powiaty <- vect("pipeline/assets/gis_meta/Powiaty.shp")
  powiat <- powiaty[powiaty$Name == powiat_name, ][1]
  dem <- rast("pipeline/assets/gis_meta/DEM.tif")
  dem_clipped <- crop(dem, powiat, mask=TRUE)
  plot(dem_clipped, main= paste("DEM of", powiat_name), font.main = 1)
  plot(powiat, add=TRUE)
  writeRaster(dem_clipped, paste0(file.path(getwd()), "/dem_", powiat_name, "/DEM_", powiat_name, ".tif"), overwrite=TRUE, filetype="GTiff")
  cat(paste("\n\n\n\nThe hydroclimate pipeline for DEM branch successfully ran!\nData is located in: ", getwd()))
}

