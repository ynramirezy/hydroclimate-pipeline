cleanup<- function() {
  
  files_to_remove <- c(
    file.path(GIS_path, paste0("clip_base.", c("shp", "cpg", "dbf", "prj", "shx"))),
    file.path(GIS_path, paste0("clip_base_84.", c("shp", "cpg", "dbf", "prj", "shx"))),
    file.path(hydroclimate_path, "Evapotranspiration_RAW"),
    file.path(hydroclimate_path, "Precipitation_RAW"),
    file.path(outputs[["Validation"]], "Validation_RAW"),
    file.path(terrain_path, "DEM_acu.tif"),
    file.path(terrain_path, "DEM_filled.tif"),
    file.path(terrain_path, "dem_base.tif"),
    list.files(path = file.path(outputs[["Validation"]]), pattern = "\\.tif$", full.names = TRUE)
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
  cat(paste0("\n❇️❇️❇️ The terrain-based SCSCN Runoff pipeline for ", gsub("_", " ", polygon_name), " from ", start_date, " to ", end_date, " successfully ran!\n\n📂 Data is located in: ", folder_pipeline, "\n\n💌 Give me a feedback at yyara@agh.edu.pl\n\n"))
  
}