validation<- function() {
  
  environment_settings("Validation")
  runoff_GEE()
  clipping("Validation", rast(list.files(file.path(outputs[["Validation"]], "Validation_RAW"), pattern = "\\.tif$", full.names = TRUE)), "", "", "")
  validation_runoff()
  cleanup()

}