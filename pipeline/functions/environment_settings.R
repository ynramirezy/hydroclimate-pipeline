environment_settings<- function(variable) {
  
  if(variable == "Terrain_features") {
    lapply(file.path(c(terrain_path, GIS_path)), dir.create, recursive = TRUE, showWarnings = FALSE)
    normalized_shp()
  } else if (variable == "Soil_constants") {
    dir.create(file.path(soil_path), recursive = TRUE)
  } else if (variable == "Hydroclimate_variables") {
    lapply( file.path(hydroclimate_path, c("Evapotranspiration_RAW", "Precipitation_RAW")), dir.create, recursive = TRUE, showWarnings = FALSE )
    lapply( file.path(c(outputs[["Evapotranspiration"]], outputs[["Precipitation"]], outputs[["Antecedent_Moisture"]])), dir.create, recursive = TRUE, showWarnings = FALSE )
  } else if (variable == "Runoff") {
    lapply( file.path(c(outputs[["Runoff"]], paste0(outputs[["Runoff"]], "/Runoff_RAW"))), dir.create, recursive = TRUE, showWarnings = FALSE )
  } else {
    dir.create(file.path(outputs[[variable]], paste0(variable, "_RAW")))
  }

}