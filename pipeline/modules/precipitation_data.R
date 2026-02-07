precipitation_data<- function() {
  
  environment_settings("Precipitation")
  precipitation_webscraping()
  geostatistical_interpolation("Precipitation")
  harmonization("Precipitation")
  
}