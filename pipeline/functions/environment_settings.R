environment_settings<- function(variable) {
  
  if(variable == "Terrain_features") {
    lapply(file.path(c(terrain_path, GIS_path)), dir.create, recursive = TRUE, showWarnings = FALSE)
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
    writeVector(powiat, file.path(GIS_path, paste0(polygon_name, ".shp")), overwrite = TRUE)
    writeVector(clip_base, file.path(GIS_path, "clip_base.shp"), overwrite = TRUE)    
  } else if (variable == "Soil_constants") {
    dir.create(file.path(soil_path), recursive = TRUE)
  } else if (variable == "Hydroclimate_variables") {
    lapply( file.path(hydroclimate_path, c("Evapotranspiration_RAW", "Precipitation_RAW")), dir.create, recursive = TRUE, showWarnings = FALSE )
    lapply( file.path(c(outputs[["Evapotranspiration"]], outputs[["Precipitation"]], outputs[["Antecedent_Moisture"]])), dir.create, recursive = TRUE, showWarnings = FALSE )
  } else if (variable == "Runoff") {
    lapply( file.path(c(outputs[["Runoff"]], paste0(outputs[["Runoff"]], "/Runoff_RAW"))), dir.create, recursive = TRUE, showWarnings = FALSE )
  } else {
    dir.create(file.path(outputs[[variable]], paste0(variable, "_RAW")), recursive = TRUE)
  }

}