pipeline_output<- function(data, target, item, datalong, repetitions) {
  
  is_base <- (item == 0)
  plot_ref <- ifelse(is_base, gsub("_", ", ", polygon_name), paste0(gsub("_", ", ", polygon_name), ", " , item))
  file_ref <- ifelse(is_base, polygon_name, item)
  if(target != "Validation") {
    plot(data, main=paste(gsub("_", " ", target), "of", plot_ref), font.main = 1) 
    plot(vect(file.path(outputs[["GIS_data_output"]], paste0("Powiat_", polygon_name, ".shp"))), add=TRUE)
  }
  writeRaster(data, file.path(outputs[[paste0(target, "_output")]], paste0(target, "_", file_ref, ".tif")), overwrite = TRUE)
  if (datalong == repetitions & target != "Validation") {
    cat(paste("\n\n\n\n✅ The hydroclimate pipeline for", target, "branch successfully ran!\nData is located in: ", outputs[[paste0(target, "_output")]]))
  }
  
}