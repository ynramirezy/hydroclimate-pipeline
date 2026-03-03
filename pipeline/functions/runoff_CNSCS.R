runoff_CNSCS<- function() {
  
  # Reclassify CN_lookup using CLC y HSG
  CLC <- rast(file.path(soil_path, "Land_Cover.tif"))
  HSG <- rast(file.path(soil_path, "Hydrological_Soil.tif"))
  TWI <- rast(file.path(terrain_path, "TopographicWet_Index.tif"))
  alpha <- rast(file.path(terrain_path, "Roughness.tif"))
  lookup_CN <- as.matrix(read.csv("pipeline/assets/gis_meta/CN_lookup.txt", row.names = 1))
  CN_vals <- lookup_CN[cbind(values(CLC), values(HSG))]
  CN_base <- CLC
  values(CN_base) <- CN_vals
  CN_base[CLC %in% c(40, 41, 42, 44)] <- NA
  # Adjust CN_base in function of AMC
  amoic_stack <- rast(list.files(file.path(outputs[["Antecedent_Moisture"]]), pattern = "\\.tif$", full.names = TRUE))
  CN_stack <- rast(amoic_stack)
  for (i in 1:nlyr(amoic_stack)) {
    amc <- amoic_stack[[i]]
    CN_day <- CN_base
    CN_day[amc == 1] <- CN_base[amc == 1] / (2.281 - 0.01281 * CN_base[amc == 1])
    CN_day[amc == 2] <- CN_base[amc == 2]
    CN_day[amc == 3] <- CN_base[amc == 3] / (0.427 + 0.00573 * CN_base[amc == 3])
    CN_stack[[i]] <- CN_day
  }
  CN_stack <- clamp(CN_stack, lower=30, upper=85)
  # Computing max retention
  S_stack <- (25400 / CN_stack) - 254
  # Computing daily Runoff
  runoff_fun <- function(P, S){
    Ia <- 0.05 * S   
    ifelse(is.na(P) | is.na(S), NA,
           ifelse(P <= Ia, 0,
                  (P - Ia)^2 / (P - Ia + S)
           )
    )
  }
  prec_layers <- rast(list.files(file.path(outputs[["Precipitation"]]), pattern = "\\.tif$", full.names = TRUE))[[(n_days + 1):length(dates)]] 
  TWI_norm <- TWI / global(TWI, "sum", na.rm=TRUE)[1,1]
  for(i in 1:nlyr(S_stack)){
    # Runoff CNSCS
    Q_day <- lapp(c(prec_layers[[i]], S_stack[[i]]), runoff_fun)
    # Mass conservation
    Q_twi <- Q_day * TWI_norm
    sum_original <- global(Q_day, "sum", na.rm=TRUE)[1,1]
    sum_new      <- global(Q_twi, "sum", na.rm=TRUE)[1,1]
    if(sum_new > 0){
      Q_twi <- Q_twi * (sum_original / sum_new)
    }
    # Roughness hybrid model
    Q_final <- ((1 - alpha) * Q_day) + (alpha * Q_twi)
    Q_final <- clamp(Q_final, lower=0, upper=prec_layers[[i]])
    pipeline_output(Q_final, "Runoff", format(dates[n_days + i], "%Y%m%d"), nlyr(S_stack), i)
  }

}