precipitation_data<- function(start_date, end_date, powiat_name) {
  
  environment_settings(start_date, end_date, powiat_name, "precipitation")
  precipitation_webscraping(start_date, end_date)
  geostatistical_interpolation(start_date, end_date, "precipitation")
  harmonization(start_date, end_date, "precipitation", powiat_name)
  
}