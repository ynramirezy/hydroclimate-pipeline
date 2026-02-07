topo_wet_index<- function() {
  
  raster_clipped <- crop(rast(paste0("pipeline/assets/gis_meta/DEM.tif")), vect(file.path(outputs[["GIS_data_output"]], "clip_base.shp")), mask=TRUE)
  writeRaster(raster_clipped, file.path(outputs[["TopographicWet_index_output"]], "dem_base.tif"), overwrite = TRUE)
  # Filling sinks using WhiteboxTools
  dem_filled_file <- file.path(outputs[["TopographicWet_index_output"]], "DEM_filled.tif")
  wbt_fill_depressions(rast(file.path(outputs[["TopographicWet_index_output"]], "dem_base.tif")), dem_filled_file)
  # Computing flow accumulation
  fa_file <- file.path(outputs[["TopographicWet_index_output"]], "DEM_acu.tif")
  wbt_d8_flow_accumulation(rast(dem_filled_file), fa_file, out_type = "cells")
  # Slope
  slope <- terrain(rast(dem_filled_file), v = "slope", unit = "radians")
  # Contribution area
  cell_size <- res(rast(dem_filled_file))[1]
  # Computing Topographic Water Index 
  twi <- log((rast(fa_file) * cell_size) / tan(slope))
  twi_clipped <- crop(twi, vect(file.path(outputs[["GIS_data_output"]], paste0("Powiat_", polygon_name, ".shp"))), mask=TRUE)
  pipeline_output(twi_clipped, "TopographicWet_index", 0, 1, 1)

}