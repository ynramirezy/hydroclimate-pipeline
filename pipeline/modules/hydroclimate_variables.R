hydroclimate_variables <- function() {
  
  environment_settings("Hydroclimate_variables")
  fetch_evapotranspiration()
  dimension_reduction()
  harmonization("Evapotranspiration", "") 
  fetch_precipitation()
  interpolate_surface()
  harmonization("Precipitation", "")
  antecedent_moisture()
  cat("\n❇️ Hydroclimate Variables module successfully ran!\n")

}