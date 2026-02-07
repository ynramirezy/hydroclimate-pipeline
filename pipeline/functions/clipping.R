clipping<- function(target) {
  
  target_raster <- rast(paste0("pipeline/assets/gis_meta/", target, ".tif"))
  raster_clipped <- crop(target_raster, vect(file.path(outputs[["GIS_data_output"]], paste0("Powiat_", polygon_name, ".shp"))), mask=TRUE)
  pipeline_output(raster_clipped, target, 0, 1, 1)

}