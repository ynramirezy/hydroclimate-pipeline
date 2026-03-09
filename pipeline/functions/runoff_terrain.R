runoff_terrain<- function() {
  
  Q_scsnc <- rast(list.files(file.path(outputs[["Runoff"]], "Runoff_RAW"), pattern = "\\.tif$", full.names = TRUE)) 
  prec_layers <- rast(list.files(file.path(outputs[["Precipitation"]]), pattern = "\\.tif$", full.names = TRUE))[[(n_days + 1):length(dates)]] 
  TWI <- rast(file.path(terrain_path, "TopographicWet_Index.tif"))
  alpha <- rast(file.path(terrain_path, "Roughness.tif"))
  TWI_norm <- TWI / global(TWI, "sum", na.rm=TRUE)[1,1]
  for(i in 1:nlyr(Q_scsnc)){
    # Mass conservation
    Q_twi <- Q_scsnc[[i]] * TWI_norm
    sum_original <- global(Q_scsnc[[i]], "sum", na.rm=TRUE)[1,1]
    sum_new      <- global(Q_twi, "sum", na.rm=TRUE)[1,1]
    if(sum_new > 0){
      Q_twi <- Q_twi * (sum_original / sum_new)
    }
    # Roughness hybrid model
    Q_final <- ((1 - alpha) * Q_scsnc[[i]]) + (alpha * Q_twi)
    Q_final <- clamp(Q_final, lower=0, upper=prec_layers[[i]])
    pipeline_output(Q_final, "Runoff", format(dates_runoff[i], "%Y%m%d"), nlyr(Q_scsnc), i)
  }

}