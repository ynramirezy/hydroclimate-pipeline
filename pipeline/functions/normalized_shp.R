normalized_shp<- function() {

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
  pipeline_vect <<- powiat
  writeVector(powiat, file.path(GIS_path, paste0(polygon_name, ".shp")), overwrite = TRUE)
  writeVector(clip_base, file.path(GIS_path, "clip_base.shp"), overwrite = TRUE)

}