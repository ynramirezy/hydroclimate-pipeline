validation_runoff<- function() {
  
  run_stack <- rast(list.files(path = file.path(outputs[["Runoff_output"]]), pattern = "\\.tif$", full.names = TRUE))
  runoff_gee_stack <- rast(list.files(path = file.path(outputs[["Validation_output"]]), pattern = "\\.tif$", full.names = TRUE))
  datesr= dates[(n_days+1):length(dates)]
  results <- data.frame()
  col_to_use <- function(runoff_col, item) {
    if(item==1){
      u <- unique(runoff_col)
      if(all(u == 1)) {
        "darkgreen"
      } else if (all(u == 0)){
        "lightgray"
      } else {
        c("lightgray", "darkgreen")
      }
    } else {
      u <- unique(runoff_col)[, 1]
      if(all(u == 1)) {
        "green"
      } else if (all(u == 0)){
        "red"
      } else {
      c("red", "green")
      }    
    }
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
    results <- rbind(results, validation_statistics(runoff_ratio[,1], runoff_ratio[,2] / runoff_ratio[,3], format(datesr[i], "%Y%m%d")))
    # Ploting
    old_mar <- par()$mar
    par(mar = c(3, 2, 2, 2)) 
    plot(gee_bin, col = col_to_use(runoff_ratio[,1], 1), legend = FALSE,  main= paste("Runoff Presence Comparison ERA5 vs Pipeline", datesr[i]), mar = par("mar"))
    plot(gee_poly, add = TRUE, border = "grey70", col = "transparent")
    plot(ral_bin, col = adjustcolor(col_to_use(ral_bin, 2), alpha.f = 0.6), add = TRUE, legend = FALSE)
    plot(vect(file.path(outputs[["GIS_data_output"]], paste0("Powiat_", polygon_name, ".shp"))), add = TRUE)
    legend("bottom", inset = c(0, -0.1), legend = c("ERA-5 present", "ERA-5 absent", "Pipeline present", "Pipeline absent"), fill = c("darkgreen", "lightgray", "green", "red"), border = "black", bty = "n", xpd = TRUE, ncol = 4, cex = 0.7)
    par(mar = old_mar)
    dev.copy(png, filename = file.path(outputs[["Validation_output"]], paste0("Validation_Runoff_", format(datesr[i], "%Y%m%d"), ".png")), width = 3400, height = 2000, res = 300 )
    dev.off()   
  }
  print(results)
  write.csv(results, file.path(outputs[["Validation_output"]], "Validacion_runoff_statistics.csv"), row.names = FALSE)
  cat(paste0("\n\n\n\n🎯 The overall accuracy of the Pipeline Runoff presence is: ", + mean(results$Accuracy)*100, "%"))  
  cat(paste("\n\n\n\n✅ The hydroclimate pipeline for Validation Runoff branch successfully ran!\nData is located in: ", outputs[["Validation_output"]]))
  
}