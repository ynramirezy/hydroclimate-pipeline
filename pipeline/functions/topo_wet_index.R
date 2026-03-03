topo_wet_index<- function() {
  
  raster_clipped <- crop(rast(paste0("pipeline/assets/gis_meta/DEM.tif")), vect(file.path(GIS_path, "clip_base.shp")))
  writeRaster(raster_clipped, file.path(terrain_path, "dem_base.tif"), overwrite = TRUE)
  # Filling sinks using WhiteboxTools
  dem_filled_file <- file.path(terrain_path, "DEM_filled.tif")
  wbt_fill_depressions(rast(file.path(terrain_path, "dem_base.tif")), dem_filled_file)
  # Computing flow accumulation
  fa_file <- file.path(terrain_path, "DEM_acu.tif")
  wbt_d8_flow_accumulation(rast(dem_filled_file), fa_file, out_type = "cells")
  # Slope
  slope <- terrain(rast(dem_filled_file), v = "slope", unit = "radians")
  # Contribution area
  cell_size <- res(rast(dem_filled_file))[1]
  # Computing Topographic Water Index 
  twi <- log((rast(fa_file) * cell_size) / tan(slope))
  twi_clipped <- crop(twi, rast(file.path(terrain_path, "DEM.tif")), mask=TRUE)  
  vals <- values(twi_clipped, na.rm=TRUE)
  q_low  <- quantile(vals, 0.01)
  q_high <- quantile(vals, 0.99)
  T_clamped <- clamp(twi_clipped, q_low, q_high)
  T_norm <- (T_clamped - q_low) / (q_high - q_low)
  pipeline_output(T_norm, "TopographicWet_Index", 0, 1, 1)

}