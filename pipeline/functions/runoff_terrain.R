runoff_terrain<- function() {
  
  Q_scsnc <- rast(list.files(file.path(outputs[["Runoff"]], "Runoff_RAW"), pattern = "\\.tif$", full.names = TRUE)) 
  prec_layers <- rast(list.files(file.path(outputs[["Precipitation"]]), pattern = "\\.tif$", full.names = TRUE))[[(n_days + 1):length(dates)]] 
  amoic_stack <- rast(list.files(file.path(outputs[["Antecedent_Moisture"]]), pattern = "\\.tif$", full.names = TRUE))
  TWI <- rast(file.path(terrain_path, "TopographicWet_Index.tif"))
  TWI_imane <- TWI^3
  TWI_dist <- TWI_imane / global(TWI_imane, "sum", na.rm=TRUE)[1,1]
  alpha_map <- c("1" = 0.3, "2" = 0.6, "3" = 0.9)
  for(i in 1:nlyr(Q_scsnc)){
    Q_local <- Q_scsnc[[i]]
    vol_total <- global(Q_local, "sum", na.rm=TRUE)[1,1]
    Q_sink_concentrated <- vol_total * TWI_dist
    f <- freq(amoic_stack[[i]])
    daily_amc_mode <- f$value[which.max(f$count)]
    current_alpha <- alpha_map[as.character(daily_amc_mode)]
    Q_final <- ((1 - current_alpha) * Q_local) + (current_alpha * Q_sink_concentrated)
    Q_final <- clamp(Q_final, lower=0, upper=prec_layers[[i]])
    pipeline_output(Q_final, "Runoff", format(dates_runoff[i], "%Y%m%d"), nlyr(Q_scsnc), i)
  }

}