dem_settings<- function(pipeline_polygon) {
  
  dir.create(file.path(DEM_output, "DEM"), recursive = TRUE)
  if (polygon_mode == "powiat") {
    powiaty <- vect("pipeline/assets/gis_meta/Powiaty.shp")
    powiat <- powiaty[powiaty$Name %in% pipeline_polygon, ]    
  } else {
    powiat <- vect(pipeline_polygon)
  }
  dem <- rast("pipeline/assets/gis_meta/DEM.tif")
  dem_clipped <- crop(dem, powiat, mask=TRUE)
  plot(dem_clipped, main= paste("DEM of", polygon_name), font.main = 1)
  plot(powiat, add=TRUE)
  writeRaster(dem_clipped, paste0(DEM_output, "/DEM/DEM_", polygon_name, ".tif"), overwrite=TRUE, filetype="GTiff")
  cat(paste("\n\n\n\n✅ The hydroclimate pipeline for DEM branch successfully ran!\nData is located in: ", DEM_output))
  
}