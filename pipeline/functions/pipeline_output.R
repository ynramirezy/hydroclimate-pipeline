pipeline_output<- function(data, target, item, datalong, repetitions) {
  
  if(item == 0) {
    plot_reference = polygon_name
    file_reference= polygon_name
  } else {
    plot_reference= paste(polygon_name, item)
    file_reference= item
  }
  plot(data, main=paste(target, "of", plot_reference), font.main = 1) 
  plot(vect(file.path(outputs[["GIS_data_output"]], paste0("Powiat_", polygon_name, ".shp"))), add=TRUE)
  writeRaster(data, file.path(outputs[[paste0(target, "_output")]], paste0(target, "_", file_reference, ".tif")), overwrite = TRUE)
  if (datalong == repetitions) {
    cat(paste("\n\n\n\n✅ The hydroclimate pipeline for", target, "branch successfully ran!\nData is located in: ", outputs[[paste0(target, "_output")]]))
  }
  
}