runoff_webscraping<- function(start_date, end_date) {
  
  #Retrieving the runoff data from GEE
  months<- format(seq(from = as.Date(format(start_date, "%Y-%m-01")), to = as.Date(format(end_date, "%Y-%m-01")), by = "month"), "%Y%m")
  names_raw <- paste0(substr(months, 1, 4), "/Runoff_RAW_", months, ".csv")
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
  #setting runoff data extend
  points_sf <- st_as_sf(runoff_df, coords = c("longitude", "latitude"), crs = 4326)
  ro_sf <- st_transform(points_sf, crs = 2180)
  ro_sf <- ro_sf %>%
    mutate(
      LON = round(st_coordinates(.)[,1], 4),  
      LAT = round(st_coordinates(.)[,2], 4) 
    )
  set.seed(123)  
  km <- kmeans(st_coordinates(ro_sf), centers = 200)
  ro_sf$cluster <- km$cluster
  centers <- km$centers
  ro_sf <- ro_sf %>%
    mutate(dist_to_center = sqrt((st_coordinates(ro_sf)[,1] - centers[cluster,1])^2 +
                                   (st_coordinates(ro_sf)[,2] - centers[cluster,2])^2))
  subsample <- ro_sf %>%
    group_by(cluster) %>%
    slice_min(order_by = dist_to_center, n = 1) %>%
    ungroup()
  #exporting the csv to interpolate
  runoff <- st_drop_geometry(subsample)[, c("LON", "LAT", paste0("runoff_", format(dates, "%Y%m%d")))]
  runoff <- runoff %>%
    mutate(across(starts_with("runoff_"), ~ round(.x * 24, 6)))
  runoff_csv= as.data.frame(runoff)
  write.table(runoff_csv, file.path(Runoff_output, "Runoff_RAW", paste0("Runoff_RAW.txt")), sep="\t", row.names=FALSE, col.names=TRUE)
  
}