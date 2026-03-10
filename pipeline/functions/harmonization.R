harmonization<-function(variable, raster_harm) {
  
  if (variable == "DEM"){
    clipping_rasters("DEM", raster_harm, 0, 1, 1)
  } else {
    DEM_pivot <- rast(file.path(terrain_path, "DEM.tif"))
    if (variable %in% c("Hydrological_Soil", "Land_Cover")) {
      if (res(DEM_pivot)[1] != 200) {
        raster_disc <- crop(raster_harm, vect(file.path(GIS_path, "clip_base.shp")), mask=TRUE)
        raster_harm = resample(raster_disc, DEM_pivot, method = "near")
      } 
      clipping_rasters(variable, raster_harm, 0, 1, 1)
    } else {
      tif_files <- list.files(path = file.path(hydroclimate_path, paste0(variable, "_RAW")), pattern = "\\.tif$", full.names = TRUE)
      for (i in 1:length(tif_files)) {
        if (variable == "Evapotranspiration") {
          e <- ext(DEM_pivot)
          if ( (xmax(e) - xmin(e)) < 20000 || (ymax(e) - ymin(e)) < 20000 ) {
            eva_zonal <- zonal(rast(tif_files[i]), vect(file.path(GIS_path, "clip_base_84.shp")), fun = "mean", na.rm = TRUE)
            raster_clipped <- DEM_pivot
            if (is.na(mean(eva_zonal[[1]]))) {
              values(raster_clipped) <- 0
            } else {
              values(raster_clipped) <- mean(eva_zonal[[1]])  
            }
          } else {
            eva_84 <- crop(rast(tif_files[i]), vect(file.path(GIS_path, "clip_base_84.shp")), mask=TRUE)
            raster_clipped <- project(eva_84, "EPSG:2180")
          }
        } else {
          rast_preci= rast(tif_files[i])
          crs(rast_preci) <- crs("EPSG: 2180")
          raster_clipped <- mask(rast_preci, vect(file.path(GIS_path, "clip_base.shp")))
        }
        raster_sampled <- resample(raster_clipped, DEM_pivot, method = "cubic")
        raster_sampled[raster_sampled < 0] <- 0
        clipping_rasters(variable, raster_sampled, format(dates[i], "%Y%m%d"), length(tif_files), i)
      }
    }
  }

}