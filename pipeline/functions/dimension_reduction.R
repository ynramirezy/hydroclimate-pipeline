dimension_reduction<- function(start_date, end_date) {
  
  nc_files <- list.files(path = file.path(evapotranspiration_output, "evapotranspiration_raw"), pattern = "\\.nc$", full.names = TRUE)
  for (i in 1:length(nc_files)) {
    writeRaster(rast(nc_files[i])[[1]], file.path(evapotranspiration_output, "evapotranspiration_raw", paste0(tools::file_path_sans_ext(basename(nc_files[i])), ".tif")), overwrite = TRUE)
  }
  clip_base_84 <- project(vect(file.path(evapotranspiration_output, "GIS_data", "clip_base.shp")), "GEOGCRS[\"unknown\",\n    DATUM[\"unnamed\",\n        ELLIPSOID[\"Spheroid\",6378137,298.257223563,\n            LENGTHUNIT[\"metre\",1,\n                ID[\"EPSG\",9001]]]],\n    PRIMEM[\"Greenwich\",0,\n        ANGLEUNIT[\"degree\",0.0174532925199433,\n            ID[\"EPSG\",9122]]],\n    CS[ellipsoidal,2],\n        AXIS[\"latitude\",north,\n            ORDER[1],\n            ANGLEUNIT[\"degree\",0.0174532925199433,\n                ID[\"EPSG\",9122]]],\n        AXIS[\"longitude\",east,\n            ORDER[2],\n            ANGLEUNIT[\"degree\",0.0174532925199433,\n                ID[\"EPSG\",9122]]]]")
  writeVector(clip_base_84, file.path(evapotranspiration_output, "GIS_data", paste0("clip_base_84.shp")), overwrite = TRUE)
  
}