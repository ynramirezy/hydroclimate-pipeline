harmonization<-function(variable) {
  
  tif_files <- list.files(path = file.path(outputs[[paste0(variable, "_output")]], paste0(variable, "_RAW")), pattern = "\\.tif$", full.names = TRUE)
  DEM_pivot <- rast(file.path(outputs["DEM_output"], paste0("DEM_", polygon_name, ".tif")))
  for (i in 1:length(tif_files)) {
    if (variable == "Evapotranspiration") {
      e <- ext(DEM_pivot)
      if ( (xmax(e) - xmin(e)) < 20000 || (ymax(e) - ymin(e)) < 20000 ) {
        eva_zonal <- zonal(rast(tif_files[i]), vect(file.path(outputs[["GIS_data_output"]], "clip_base_84.shp")), fun = "mean", na.rm = TRUE)
        raster_clipped <- DEM_pivot
        if (is.na(mean(eva_zonal[[1]]))) {
          values(raster_clipped) <- 0
        } else {
          values(raster_clipped) <- mean(eva_zonal[[1]])  
        }
      } else {
        eva_84 <- crop(rast(tif_files[i]), vect(file.path(outputs[["GIS_data_output"]], paste0("clip_base_84.shp"))), mask=TRUE)
        raster_clipped <- project(eva_84, "EPSG:2180")
      }
    } else {
      rast_p= rast(tif_files[i])
      crs(rast_p) <- crs("EPSG: 2180")
      raster_clipped <- mask(rast_p, vect(file.path(outputs[["GIS_data_output"]], "clip_base.shp")))
    }
    raster_sampled <- resample(raster_clipped, DEM_pivot, method = "cubic")
    raster_area <- crop(raster_sampled, DEM_pivot, mask=TRUE)
    raster_area[raster_area < 0] <- 0
    pipeline_output(raster_area, variable, format(dates[i], "%Y%m%d"), length(tif_files), i)
  }

}