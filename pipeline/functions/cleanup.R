cleanup<- function() {
  
  files_to_remove <- c(
    file.path(outputs[["GIS_data_output"]], paste0("clip_base.", c("shp", "cpg", "dbf", "prj", "shx"))),
    file.path(outputs[["GIS_data_output"]], paste0("clip_base_84.", c("shp", "cpg", "dbf", "prj", "shx"))),
    file.path(outputs[["Evapotranspiration_output"]], "Evapotranspiration_RAW"),
    file.path(outputs[["Precipitation_output"]], "Precipitation_RAW"),
    file.path(outputs[["TopographicWet_index_output"]], "DEM_acu.tif"),
    file.path(outputs[["TopographicWet_index_output"]], "DEM_filled.tif"),
    file.path(outputs[["TopographicWet_index_output"]], "dem_base.tif")
  )
  for(f in files_to_remove) {
    if(file.exists(f)) {
      if(dir.exists(f)) {
        unlink(f, recursive = TRUE)
      } else {
        file.remove(f)
      }
    }
  }
  cat(paste0("\n\n✅ The hydroclimate pipeline of Runoff Vulnerability for ", polygon_name, " from ", start_date, " to ", end_date, " successfully ran!\nData is located in: ", folder_pipeline, "\n"))

}