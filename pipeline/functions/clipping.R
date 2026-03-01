clipping<- function(target) {
  
  poly_pipe = vect(file.path(outputs[["GIS_data_output"]], paste0("Powiat_", polygon_name, ".shp")))
  if (target == "Validation") {
    target_raster <- rast(list.files(path = file.path(outputs[["Validation_output"]], "Validation_RAW"), pattern = "\\.tif$", full.names = TRUE))
    for (i in 1:nlyr(target_raster)) {
      raster_clipped <- crop(target_raster[[i]], poly_pipe, mask=TRUE, snap = "out")
      pipeline_output(raster_clipped, "Validation", dates_runoff[i], nlyr(target_raster), i)    
    }   
  } else {
    target_raster <- rast(paste0("pipeline/assets/gis_meta/", target, ".tif"))
    raster_clipped <- crop(target_raster, poly_pipe, mask=TRUE, snap = "out")
    pipeline_output(raster_clipped, target, 0, 1, 1)    
  }

}