soil_constants <- function() {
  
  environment_settings("Soil_constants")
  harmonization("Land_Cover", rast("pipeline/assets/gis_meta/Land_Cover.tif"))
  harmonization("Hydrological_Soil", rast("pipeline/assets/gis_meta/Hydrological_Soil.tif"))
  cat(paste("\n❇️ Soil Constants module successfully ran!\n"))

}