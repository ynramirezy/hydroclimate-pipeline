pipeline_output<- function(data, target, item, datalong, repetitions) {
  
  is_base <- (item == 0)
  plot_ref <- ifelse(is_base, gsub("_", " ", polygon_name), paste0(gsub("_", " ", polygon_name), ", " , item))
  file_ref <- ifelse(is_base, ".tif", paste0("_", item, ".tif"))
  plot_legend(data, target, plot_ref)
  plot_labels()
  writeRaster(data, file.path(outputs[[target]], paste0(target, file_ref)), overwrite = TRUE)
  if (datalong == repetitions & target != "Validation") {
    cat(paste("\n✅", gsub("_", " ", target), "\n"))
  }

}