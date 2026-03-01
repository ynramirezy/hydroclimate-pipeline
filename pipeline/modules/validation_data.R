validation_data<- function() {
  
  environment_settings("Validation")
  runoff_GEE()
  clipping("Validation")
  validation_runoff()
  cleanup()

}