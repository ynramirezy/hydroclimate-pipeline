fetch_precipitation<- function() {
  
  # Data source: Climate R package
  # Czernecki, B., Głogowski, A., & Nowosad, J. (2020). Climate: An R package to access free in-situ meteorological and hydrological datasets for environmental assessment. Sustainability, 12(1), 394. https://doi.org/10.3390/su12010394.
  options(download.file.quiet = TRUE)
  suppressMessages({ meteo_data = meteo_imgw(interval = "daily", rank = "synop", year = year(start_date), coords = FALSE) })
  meteo_data$date <- as.Date(with(meteo_data, paste(ROK, MC, DZ, sep = "-")))
  ##Setting the records for the user dates and for the daily precipitation
  if (year(start_date) == year(end_date)) {
    meteo_query= meteo_data[meteo_data$date >= start_date & meteo_data$date <= end_date, ]
  } else {
    meteo_ini= meteo_data[meteo_data$date >= start_date, ]
    suppressMessages({ meteo_fin= meteo_imgw(interval = "daily", rank = "synop", year = year(end_date), coords = FALSE) })
    meteo_fin$date <- as.Date(with(meteo_fin, paste(ROK, MC, DZ, sep = "-")))
    meteo_final <- meteo_fin[meteo_fin$date <= end_date, ]
    meteo_query <- rbind(meteo_ini, meteo_final)
  }
  preci_query= meteo_query[, c("NSP", "POST", "date", "SMDB")]
  names(preci_query) <- c("id", "station", "date", "rr_daily")
  ##Getting stations and days values
  preci_query$station= trimws(preci_query$station)
  preci_poland <- dcast(preci_query, id + station ~ date, value.var = "rr_daily")
  setnames(preci_poland, old = names(preci_poland)[-(1:2)], new = paste0("Precipitation_", gsub("-", "", names(preci_poland)[-(1:2)])))
  ##Attaching the coordinates
  coords_preci= read.csv("pipeline/assets/gis_meta/Coords_new.txt", sep="\t")
  precixy_poland <- merge(preci_poland, coords_preci, by = "id")
  write.table(precixy_poland, file.path(hydroclimate_path, "Precipitation_RAW", paste0("Precipitation_RAW.txt")), sep="\t", row.names=FALSE, col.names=TRUE)

}
