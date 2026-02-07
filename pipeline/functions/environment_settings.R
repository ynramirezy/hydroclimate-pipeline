environment_settings<- function(variable) {
  
  if(variable == "DEM") {
    lapply(file.path(c(outputs[["DEM_output"]], outputs[["GIS_data_output"]])), dir.create, recursive = TRUE, showWarnings = FALSE)
    if (polygon_mode == "powiat") {
      powiat <- powiaty[powiaty$Name %in% pipeline_polygon, ]    
    } else {
      envelop= vect("pipeline/assets/gis_meta/Envelop.shp")
      powiat <- vect(pipeline_polygon)
      crs(powiat) <- crs(envelop)
      if (!any(relate(powiat, envelop, "coveredby"))) {
        stop("❌ Invalid input geometry: the shapefile must be spatially contained within Poland.")
      }      
    }
    clip_base <- as.polygons(ext(powiat)*1.3)
    crs(clip_base) <- crs(powiat)
    writeVector(powiat, file.path(outputs[["GIS_data_output"]], paste0("Powiat_", polygon_name, ".shp")), overwrite = TRUE)
    writeVector(clip_base, file.path(outputs[["GIS_data_output"]], "clip_base.shp"), overwrite = TRUE)    
  } else {
    if (!file.exists(file.path(outputs[["DEM_output"]], paste0("/DEM_", polygon_name, ".tif")))) {
      stop("❌ DEM file not found. Please run the DEM function before Evapotranspiration")
    }    
    if (variable %in% c("Precipitation", "Evapotranspiration")){
      dir.create(file.path(outputs[[paste0(variable, "_output")]], paste0(variable, c("_RAW"))), recursive = TRUE, showWarnings = FALSE)
    } else {
      dir.create(file.path(outputs[[paste0(variable, "_output")]]), recursive = TRUE) 
    }
  }
 
}

