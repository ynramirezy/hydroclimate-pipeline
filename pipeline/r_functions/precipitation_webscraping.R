precipitation_webscraping<- function(start_date, end_date) {
  
  meteo_data = invisible(meteo_imgw(interval = "daily", rank = "synop", year = year(start_date), coords = FALSE))
  meteo_data$date <- as.Date(with(meteo_data, paste(yy, mm, day, sep = "-")))
  ##Setting the records for the user dates and for the daily precipitation
  if (year(start_date) == year(end_date)) {
    meteo_query= meteo_data[meteo_data$date >= start_date & meteo_data$date <= end_date, ]
  } else {
    meteo_ini= meteo_data[meteo_data$date >= start_date, ]
    meteo_fin= invisible(meteo_imgw(interval = "daily", rank = "synop", year = year(end_date), coords = FALSE))
    meteo_fin$date <- as.Date(with(meteo_fin, paste(yy, mm, day, sep = "-")))
    meteo_final <- meteo_fin[meteo_fin$date <= end_date, ]
    meteo_query <- rbind(meteo_ini, meteo_final)
  }
  preci_query= meteo_query[c("id", "station", "date", "rr_daily")]
  ##Getting stations and days values
  preci_query$station= trimws(preci_query$station)
  stations= length(unique(preci_query$station))
  ##Validation by station
  days_rr= dim(preci_query[preci_query$station == unique(preci_query$station)[1],])[1]
  ##Creating the raining day names
  names_rr= array()
  for(k in 1:days_rr) {
    names_rr[k]= paste0("Precipitation_", format(unique(preci_query$date)[k], "%Y%m%d"))
  }
  ##Creating the dataframe of the precipitation
  preci_poland <- data.frame(matrix(ncol = days_rr + 2, nrow = stations))
  colnames(preci_poland)  <- c(colnames(preci_query)[1:2], names_rr)
  ##Populating preci_poland
  preci_poland$station= unique(preci_query$station)
  preci_poland$id= unique(preci_query$id)
  for(i in 1:stations){
    for(j in 1:days_rr){
      preci_poland[i,j+2]= preci_query[preci_query$station == unique(preci_query$station)[i],]$rr[j]
    }
  }
  ##Attaching the coordinates
  coords_preci= read.csv("pipeline/assets/Coords_new.txt", sep="\t")
  precixy_poland <- merge(preci_poland, coords_preci, by = "id")
  write.table(precixy_poland, file.path(precipitation_output, "precipitation_raw", paste0("precipitation_raw.txt")), sep="\t", row.names=FALSE, col.names=TRUE)

}