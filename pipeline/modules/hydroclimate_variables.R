hydroclimate_variables <- function() {
  
  environment_settings("Hydroclimate_variables")
  evapotranspiration_webscraping()
  dimension_reduction()
  harmonization("Evapotranspiration", "") 
  precipitation_webscraping()
  geostatistical_interpolation()
  harmonization("Precipitation", "")
  antecedent_moisture_condition()
  cat(paste("\n✅ Hydroclimate Variables branch successfully ran!\n📂 Data is located in:", hydroclimate_path, "\n"))

}