validation_statistics <- function(runoff_gee, ratio_pipe, dates_runoff) {
  
  # Error
  errores <- ratio_pipe - runoff_gee
  # MAE 
  mae <- mean(abs(errores), na.rm = TRUE)
  accuracy_cont <- 1 - mae
  # RMSE
  rmse <- sqrt(mean(errores^2, na.rm = TRUE))
  # Bias
  bias <- mean(errores, na.rm = TRUE)
  return(data.frame(
    Date = dates_runoff,
    Accuracy = round(accuracy_cont, 3),
    MAE = round(mae, 3),
    RMSE = round(rmse, 3),
    Bias = round(bias, 3)
  ))
}