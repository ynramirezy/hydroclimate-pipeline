validation<- function() {
  
  environment_settings("Validation")
  era5_runoff()
  clipping_rasters("Validation", rast(list.files(file.path(outputs[["Validation"]], "Validation_RAW"), pattern = "\\.tif$", full.names = TRUE)), "", "", "")
  validation_runoff()
  cleanup_pipeline()

}