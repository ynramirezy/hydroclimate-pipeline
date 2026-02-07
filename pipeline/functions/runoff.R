runoff<- function() {
  
  # Reclassify CN_lookup using CLC y HSG
  CLC <- rast(file.path(outputs[["Land_Cover_output"]], paste0("Land_Cover_", polygon_name, ".tif")))        
  HSG <- rast(file.path(outputs[["Hydrological_Soil_output"]],  paste0("Hydrological_Soil_", polygon_name, ".tif")))
  lookup_CN <- as.matrix(read.csv("pipeline/assets/gis_meta/CN_lookup.txt", row.names = 1))
  CN_vals <- lookup_CN[cbind(values(CLC), values(HSG))]
  CN_base <- CLC
  values(CN_base) <- CN_vals
  # Adjust CN_base in function of AMC
  amoic_stack <- rast(list.files(path = file.path(outputs[["Antecedent_Moisture_output"]]), pattern = "\\.tif$", full.names = TRUE))
  CN_stack <- rast(amoic_stack)
  for (i in 1:nlyr(amoic_stack)) {
    amc <- amoic_stack[[i]]
    CN_day <- CN_base
    CN_day[amc == 1] <- CN_base[amc == 1] / (2.281 - 0.01281 * CN_base[amc == 1])
    CN_day[amc == 2] <- CN_base[amc == 2]
    CN_day[amc == 3] <- CN_base[amc == 3] / (0.427 + 0.00573 * CN_base[amc == 3])
    CN_stack[[i]] <- CN_day
  }
  # Computing max retention
  S_stack <- (25400 / CN_stack) - 254
  # Computing daily Runoff
  preci_stack <- rast(list.files(path = file.path(outputs[["Precipitation_output"]]), pattern = "\\.tif$", full.names = TRUE))
  runoff_fun <- function(P, S){
    ifelse(is.na(P) | is.na(S), NA,
      ifelse(P <= 0.2*S, 0,
        (P - 0.2*S)^2 / (P + 0.8*S)
      )
    )
  }
  prec_layers <- preci_stack[[(n_days + 1):nlyr(preci_stack)]] 
  for(i in 1:nlyr(S_stack)){
    Q_day <- lapp(c(prec_layers[[i]], S_stack[[i]]), runoff_fun)
    pipeline_output(Q_day, "Runoff", format(dates[n_days + i], "%Y%m%d"), nlyr(S_stack), i)
  }

}