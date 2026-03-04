validation_runoff<- function() {
  
  run_stack <- rast(list.files(file.path(outputs[["Runoff"]]), pattern = "\\.tif$", full.names = TRUE))
  runoff_gee_stack <- rast(list.files(file.path(outputs[["Validation"]]), pattern = "\\.tif$", full.names = TRUE)) / 100
  results <- data.frame()
  colors_gee <- c("lightgray", "darkgreen")
  colors_ral <- c("red", "green")
  col_to_use <- function(runoff_ras, colors_map) {
    u <- unique(runoff_ras)[, 1]
    if(all(u == 0)) {
      colors_map[1]
    } else if (all(u == 1)){
      colors_map[2]
    } else {
      colors_map
    }
  }
  validation_plot <- function(gee_raster, ral_raster, gee_vect){
    old_mar <- par()$mar
    par(mar = c(3, 2, 2, 2)) 
    plot(gee_raster, col = col_to_use(gee_raster, colors_gee), legend = FALSE,  main= paste("Runoff Presence Comparison ERA5 vs Pipeline", dates_runoff[i]), mar = par("mar"))
    plot(gee_vect, add = TRUE, border = "grey70", col = "transparent", legend = FALSE)
    image(ral_raster, col = adjustcolor(col_to_use(ral_raster, colors_ral), alpha.f = 0.6), add = TRUE, legend = FALSE, useRaster = TRUE, border = NA, interpolate = FALSE)
    plot(vect(file.path(GIS_path, paste0(polygon_name, ".shp"))), add = TRUE, legend = FALSE)
    legend("bottom", inset = c(0, -0.105), legend = c("ERA-5 present", "ERA-5 absent", "Pipeline present", "Pipeline absent"), fill = c("darkgreen", "lightgray", "green", "red"), border = "black", bty = "n", xpd = TRUE, ncol = 4, cex = 0.7)
    par(mar = old_mar)
  }
  for (i in 1:nlyr(run_stack)) {
    # Binary runoff
    ral_bin <- run_stack[[i]] > 0.1
    gee_bin <- runoff_gee_stack[[i]] > 0.1
    ral_mask <- !is.na(ral_bin)
    # Zonal statistics for runoff presence
    gee_poly <- as.polygons(gee_bin, dissolve = FALSE)
    runoff_zonal <- zonal(ral_bin, gee_poly, fun = "sum", na.rm = TRUE)
    runoff_edges <- zonal(ral_mask, gee_poly, fun = "sum", na.rm = TRUE)
    runoff_ratio <- na.omit(cbind(values(gee_poly)[[1]], runoff_zonal[[1]], runoff_edges[[1]]))
    results <- rbind(results, validation_statistics(runoff_ratio[,1], runoff_ratio[,2] / runoff_ratio[,3], format(dates_runoff[i], "%Y%m%d")))
    # Ploting
    validation_plot(gee_bin, ral_bin, gee_poly)
    agg_png(filename = file.path(outputs[["Validation"]], paste0("Validation_Runoff_", format(dates_runoff[i], "%Y%m%d"), ".png")), width = 3400, height = 2000, res = 300)
      validation_plot(gee_bin, ral_bin, gee_poly)
    dev.off()   
  }
  pander(results)
  write.csv(results, file.path(outputs[["Validation"]], "Validacion_runoff_statistics.csv"), row.names = FALSE)
  cat(paste0("🎯 The overall accuracy of the Pipeline Runoff presence is: ", + round(mean(results$Accuracy)*100, 2), "%\n"))
  cat(paste("\n✅ Validation\n"))
  
}