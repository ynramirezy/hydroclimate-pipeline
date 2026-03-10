antecedent_moisture<- function() {
  
  preci_stack <- rast(list.files(path = file.path(outputs[["Precipitation"]]), pattern = "\\.tif$", full.names = TRUE))
  evapo_stack <- rast(list.files(path = file.path(outputs[["Evapotranspiration"]]), pattern = "\\.tif$", full.names = TRUE))
  # Computing the antecedent moisture condition
  for(i in (n_days+1):(as.numeric(end_date - start_date) +1 )){
    preci_sum <- app(preci_stack[[ (i - n_days + 1):i ]], sum)
    evapo_sum <- app(evapo_stack[[ (i - n_days + 1):i ]], sum)
    smi <- preci_sum - evapo_sum  # SMI proxy
    amc <- classify(smi, rbind(c(-Inf, 35, 1), c(35, 53, 2), c(53, Inf, 3)))
    pipeline_output(amc, "Antecedent_Moisture", format(dates[i], "%Y%m%d"), nlyr(amc) + n_days + 1, i)
  }

}