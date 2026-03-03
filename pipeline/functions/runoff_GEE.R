runoff_GEE <- function () {
  
  index_dates <- as.numeric(format(dates_runoff[format(dates_runoff, "%Y") == format(dates_runoff[1], "%Y")], "%j"))
  target_raster_start= rast(paste0("pipeline/assets/runoff_GEE/GEE_", format(dates_runoff[1], "%Y"), ".tif"))
  target_raster= target_raster_start[[index_dates]] 
  if (format(dates_runoff[1], "%Y") != format(end_date, "%Y")) {
    index_end <- as.numeric(format(dates_runoff[format(dates_label, "%Y") == format(end_date, "%Y")], "%j"))
    target_raster_end= rast(paste0("pipeline/assets/runoff_GEE/GEE_", format(end_date, "%Y"), ".tif"))
    target_raster= c(target_raster, target_raster_end[[index_end]])
  } 
  for (i in 1:nlyr(target_raster)) {
    writeRaster(target_raster[[i]], file.path(outputs[["Validation"]], "Validation_RAW", paste0("Runoff_GEE_", dates_runoff[i], ".tif")), overwrite = TRUE)
  }
  
}