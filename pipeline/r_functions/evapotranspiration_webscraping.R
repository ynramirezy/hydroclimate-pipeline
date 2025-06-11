evapotranspiration_webscraping <- function(start_date, end_date) {
  
  username <- "yyara"
  password <- "hydroclimate_pipeline"
  dates <- seq(start_date, end_date, by = "day")
  evapotranspiration_output= file.path(getwd(), paste("evapotranspiration", format(start_date, "%Y%m%d"), format(end_date, "%Y%m%d"), sep="_"))
  for(i in 1:(end_date-start_date+1)) {
    url <- paste0("https://datalsasaf.lsasvcs.ipma.pt/PRODUCTS/MSG/MDMET/NETCDF/", year(dates[i]), "/", sprintf("%02d", month(dates[i])), "/", sprintf("%02d", day(dates[i])), "/NETCDF4_LSASAF_MSG_DMET_MSG-Disk_", year(dates[i]), sprintf("%02d", month(dates[i])), sprintf("%02d", day(dates[i])), "0000.nc")
    output_file <- file.path(evapotranspiration_output, "evapotranspiration_raw", paste0(strsplit(url, "/")[[1]][11]))
    response <- GET(url, authenticate(username, password), write_disk(output_file, overwrite = TRUE))
    if (status_code(response) != 200) {
      print(paste("Failed to download. Status code:", status_code(response)))
    }
  }
  
}
