slope_statistics<-function(variable_slope) {
  
  # Setting environment
  dir.create(file.path(folder_pipeline, paste("Slope", variable_slope, polygon_name, sep="_"), paste0("Slope_", variable_slope, "_GeoTIFF")), recursive = TRUE)
  dir.create(file.path(folder_pipeline, paste("Slope", variable_slope, polygon_name, sep="_"), paste0("Slope_", variable_slope, "_TimeSeries")), recursive = TRUE)
  slope <- terrain(rast(file.path(DEM_output, paste0("/DEM/DEM_", polygon_name, ".tif"))), v = "slope", unit = "degrees")
  # Range for classification
  rcl_matrix <- matrix(c(
    0,  2.001077, 1,
    2.001077, 4.288022, 2,
    4.288022, 7.432572, 3,
    7.432572, 11.148858, 4,
    11.148858, 15.722748, 5,
    15.722748, 22.011847, 6,
    22.011847, 31.731364, 7,
    31.731364, 72.896378, 8
  ), ncol=3, byrow=TRUE)
  slope_classes <- classify(slope, rcl = rcl_matrix)
  zonal_stats <- data.frame(slope = rcl_matrix[,3], Slope_Range = paste0(round(rcl_matrix[,1],2), "° - ", round(rcl_matrix[,2],2), "°"))
  tif_files <- list.files(path = file.path(get(paste0(variable_slope, "_output")), paste0(variable_slope, "_GeoTIFF")), pattern = "\\.tif$", full.names = TRUE)
  for (i in 1:length(tif_files)) {
    # Zonal statistics
    mean_table <- zonal(rast(tif_files[i]), slope_classes, fun = "mean", na.rm = TRUE)
    sd_table <- zonal(rast(tif_files[i]), slope_classes, fun = "sd", na.rm = TRUE)
    stats <- Reduce(function(x, y) merge(x, y, by = "slope", all.x = TRUE), list(zonal_stats[, "slope", drop=FALSE], mean_table, sd_table))
    names(stats)[2:3] <- c(paste0("Mean_", format(dates[i], "%Y%m%d")), paste0("SD_", format(dates[i], "%Y%m%d")))  
    zonal_stats <- cbind(zonal_stats, stats[, 2:3])
    write.table(zonal_stats, file.path(folder_pipeline, paste("Slope", variable_slope, polygon_name, sep="_"), paste0("Slope_", variable_slope, "_TimeSeries"), paste0("Slope_", variable_slope, "_TimeSeries.txt")), sep="\t", row.names=FALSE, col.names=TRUE)
    # Mapping 
    runoff_media_raster <- slope_classes  
    values(runoff_media_raster) <- NA     
    for(j in 1:nrow(zonal_stats)){
      class <- zonal_stats[,1][j]
      mean <- zonal_stats[,(i*2)+1][j]
      runoff_media_raster[slope_classes == class] <- mean
    }
    plot(runoff_media_raster, col = rev(paletteer_c("grDevices::BuPu", 8)), main = paste0(variable_slope," mean by Slope, ", polygon_name, ", ", format(dates[i], "%Y%m%d")), font.main = 1)
    plot(vect(file.path(DEM_output, "GIS_data", paste0("Powiat_", polygon_name, ".shp"))), add=TRUE)
    writeRaster(runoff_media_raster, file.path(folder_pipeline, paste("Slope", variable_slope, polygon_name, sep="_"), paste0("Slope_", variable_slope, "_GeoTIFF"), paste0("Slope_", variable_slope, "_", format(dates[i], "%Y%m%d"), ".tif")), overwrite = TRUE)
  }
  cat(paste("\n\n\n\n✅ The hydroclimate pipeline for Slope -", variable_slope, "branch successfully ran!\nData is located in: ", file.path(folder_pipeline, paste("Slope", variable_slope, polygon_name, sep="_"))))
  
}