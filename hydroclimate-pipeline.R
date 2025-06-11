#Welcome to the Hydroclimate Data Pipeline!
#This tool generates high-resolution daily rasters for precipitation, evapotranspiration, and runoff.

# Please set the following parameters before running:

start_date <- as.Date("2023-12-30")
end_date <- as.Date("2024-01-02")
powiat_name <- "Olsztyński"

#And load the pipeline modules and functions

source("pipeline/global.R")

#Then, run the desired function and wait while the results are generated!

evapotranspiration_data(start_date, end_date, powiat_name)
precipitation_data(start_date, end_date, powiat_name)
runoff_data(start_date, end_date, powiat_name)