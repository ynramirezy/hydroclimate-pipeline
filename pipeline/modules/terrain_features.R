terrain_features <- function() {
  
  environment_settings("Terrain_features")
  harmonization("DEM", rast("pipeline/assets/gis_meta/DEM.tif"))
  normalized_roughness()
  topo_wet_index()
  cat(paste("\n❇️ Terrain Features module successfully ran!\n")) 

}