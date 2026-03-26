fetch_evapotranspiration <- function() {
  
  # Data source: LSA SAF (EUMETSAT) - MDMET product
  # The European Organisation for Meteorological Satellites (EUMETSAT). (2025). Daily evapotranspiration MDMET. https://datalsasaf.lsasvcs.ipma.pt/PRODUCTS/MSG/MDMETv3/NETCDF/
  username <- "yyara"
  password <- "hydroclimate_pipeline"
  dates <- seq(start_date, end_date, by = "day")
  for(i in 1:(end_date-start_date+1)) {
    url <- paste0("https://datalsasaf.lsasvcs.ipma.pt/PRODUCTS/MSG/MDMETv3/NETCDF/", year(dates[i]), "/", sprintf("%02d", month(dates[i])), "/", sprintf("%02d", day(dates[i])), "/NETCDF4_LSASAF_MSG_DMETv3_MSG-Disk_", year(dates[i]), sprintf("%02d", month(dates[i])), sprintf("%02d", day(dates[i])), "0000.nc")
    output_file <- file.path(hydroclimate_path, "Evapotranspiration_RAW", paste0(strsplit(url, "/")[[1]][11]))
    response <- GET(url, authenticate(username, password), write_disk(output_file, overwrite = TRUE))
    if (status_code(response) != 200) {
      print(paste("Failed to download. Status code:", status_code(response)))
    }
  }
  
}
