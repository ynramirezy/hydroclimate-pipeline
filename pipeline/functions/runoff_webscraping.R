runoff_webscraping<- function(start_date, end_date) {
  
  #Retrieving the runoff data from GEE
  months<- format(seq(from = as.Date(format(start_date, "%Y-%m-01")), to = as.Date(format(end_date, "%Y-%m-01")), by = "month"), "%Y%m")
  names_raw <- paste0(substr(months, 1, 4), "/runoff_raw_", months, ".csv")
  csv_files <- file.path("pipeline", "assets", "runoff_backup", names_raw)
  combined_df <- do.call(rbind, lapply(csv_files, read.csv, stringsAsFactors = FALSE))
  runoff_poland <- combined_df[combined_df$date >= start_date & combined_df$date <= end_date, ]
  #Formating the runoff data
  runoff_df <- runoff_poland %>%
    filter(date == dates[1]) %>%
    select(-surface_runoff_sum, -date)
  for (i in 1:length(dates)) {
    runoff_test <- runoff_poland %>% filter(date == dates[i])
    if (all(runoff_df$LON == runoff_test$LON) && all(runoff_df$LAT == runoff_test$LAT)) {
      colnames(runoff_test)[colnames(runoff_test) == "surface_runoff_sum"] <- paste0("runoff_", gsub("-", "", unique(runoff_test$date)))
      runoff_df <- cbind(runoff_df, runoff_test[3])
    }
  }
  #setting runoff data to the selected powiat
  clip_base <- invisible(st_read(file.path(runoff_output, "GIS_data", "clip_base.shp")))
  points_sf <- st_as_sf(runoff_df, coords = c("longitude", "latitude"), crs = 4326)
  ro_sf <- st_transform(points_sf, crs = 2180)
  ro_sf <- ro_sf %>%
    mutate(
      LON = st_coordinates(.)[,1],  
      LAT = st_coordinates(.)[,2]   
    )
  runoff_clipped <- as.data.frame(ro_sf[st_intersects(ro_sf, clip_base, sparse = FALSE), ])
  runoff <- st_drop_geometry(runoff_clipped)[, c("LON", "LAT", paste0("runoff_", format(dates, "%Y%m%d")))]
  write.table(runoff, file.path(runoff_output, "runoff_raw", paste0("runoff_raw.txt")), sep="\t", row.names=FALSE, col.names=TRUE)
  
}