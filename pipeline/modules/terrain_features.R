terrain_features <- function() {

  environment_settings("Terrain_features")
  harmonization("DEM", rast("pipeline/assets/gis_meta/DEM.tif"))
  topo_wet_index()
  cat("\n❇️ Terrain Features module successfully ran!\n")

}