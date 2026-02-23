clipping<- function(target) {
  
  if (target == "Validation") {
    factor_scale= 100
    dates_label= dates[(n_days+1):length(dates)]
    index_dates <- as.numeric(format(dates_label[format(dates_label, "%Y") == format(dates_label[1], "%Y")], "%j"))
    target_raster_start= rast(paste0("pipeline/assets/runoff_GEE/GEE_", format(dates_label[1], "%Y"), ".tif"))
    target_raster= target_raster_start[[index_dates]]
    if (format(dates_label[1], "%Y") != format(end_date, "%Y")) {
      index_end <- as.numeric(format(dates_label[format(dates_label, "%Y") == format(end_date, "%Y")], "%j"))
      target_raster_end= rast(paste0("pipeline/assets/runoff_GEE/GEE_", format(end_date, "%Y"), ".tif"))
      target_raster= c(target_raster, target_raster_end[[index_end]])
    } 
  } else {
    target_raster <- rast(paste0("pipeline/assets/gis_meta/", target, ".tif"))
    dates_label=c(0)
    factor_scale= 1
  }
  for (i in 1:nlyr(target_raster)) {
    raster_clipped <- crop(target_raster[[i]]/factor_scale, vect(file.path(outputs[["GIS_data_output"]], paste0("Powiat_", polygon_name, ".shp"))), mask=TRUE, snap = "out")
    pipeline_output(raster_clipped, target, dates_label[i], nlyr(target_raster), i)    
  }

}