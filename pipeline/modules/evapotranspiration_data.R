evapotranspiration_data<- function() {
  
  environment_settings("Evapotranspiration")
  evapotranspiration_webscraping()
  dimension_reduction()
  harmonization("Evapotranspiration") 
  
}
