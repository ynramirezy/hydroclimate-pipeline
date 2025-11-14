#Welcome to the Hydroclimate Data Pipeline!
#This tool generates high-resolution daily rasters for precipitation, evapotranspiration, and runoff.

# Please set the following parameters before running:

start_date <- as.Date("2024-08-01")
end_date <- as.Date("2024-08-31")
powiat_name <- c("Lubiński", "Polkowicki", "Głogowski")

#And load the pipeline modules and functions

setwd(dirname(rstudioapi::getSourceEditorContext()$path))
source("pipeline/global.R")

#Then, run the desired function and wait while the results are generated!

dem_data(powiat_name)
evapotranspiration_data(start_date, end_date, powiat_name)
precipitation_data(start_date, end_date, powiat_name)
runoff_data(start_date, end_date, powiat_name)