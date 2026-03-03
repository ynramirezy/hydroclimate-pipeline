clipping<- function(target, data_raster, data_raster_dates, data_raster_len, data_raster_count) {
  
  if (target %in% c("DEM", "Validation")) {
    mask_source <- vect(file.path(GIS_path, paste0(polygon_name, ".shp")))
  } else {
    mask_source <- rast(file.path(terrain_path, paste0("DEM.tif")))
  }
  for (i in 1:nlyr(data_raster)) {
    raster_clipped <- crop(data_raster[[i]], mask_source, mask=TRUE, snap = "out") 
    if (target == "Validation") {
      writeRaster(raster_clipped, file.path(outputs[["Validation"]], paste0("Validation_", dates_runoff[i], ".tif")), overwrite = TRUE)
    } else {
    pipeline_output(raster_clipped, target, data_raster_dates, data_raster_len, data_raster_count)
    }
  }
    
}