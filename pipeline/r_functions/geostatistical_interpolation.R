geostatistical_interpolation<-function(start_date, end_date, variable) {
  
  if (variable == "precipitation") {
    extend_base = vect("pipeline/assets/Powiaty.shp")
    zeros = "pipeline/assets/zero_raster.tif"
  } else {
    extend_base = vect(file.path(runoff_output, "GIS_data", "clip_base.shp"))
    zeros = file.path(runoff_output, "GIS_data", "zero_raster.tif")
  }
  tabular_data= read.csv(file.path(get(paste0(variable, "_output")), paste0(variable, "_raw"), paste0(variable, "_raw.txt")), sep="\t")
  for (i in 1:length(dates)) {
    # Checking if there any daily data (experimental noise)
    if(all(na.omit(tabular_data[i+2]) == 0) || sd(na.omit(tabular_data[[i+2]])) < 1e-5) {
      file.copy(from = zeros, to = file.path(get(paste0(variable, "_output")), paste0(variable, "_raw"), paste0(variable, "_raw_", format(dates[i], "%Y%m%d"), ".tif")))
    } else {
      #Create spatial dataframe
      data <- na.omit(data.frame(
        x = tabular_data$LON,  
        y = tabular_data$LAT,  
        z = tabular_data[,2+i]  
      ))
      coordinates(data) <- ~x + y
      grd <- expand.grid(
        x = seq(from = xmin(ext(extend_base)), to = xmax(ext(extend_base)), by = 1000),
        y = seq(from = ymin(ext(extend_base)), to = ymax(ext(extend_base)), by = 1000)
      )
      coordinates(grd) <- ~x + y
      gridded(grd) <- TRUE
      nn <- get.knn(coordinates(data), k = 1)
      range <- mean(nn$nn.dist) 
      #Perform ordinary kriging
      variogram_model <- autofitVariogram(z ~ 1, data, fix.values = c(0,NA, range), model = c("Exp"))
      kriging_result <- gstat::krige(
        formula = z ~ 1,        
        locations = data,       
        newdata = grd,         
        model = variogram_model$var_model  
      )
      raster_krig <- rast(kriging_result["var1.pred"])
      writeRaster(raster_krig, file.path(get(paste0(variable, "_output")), paste0(variable, "_raw"), paste0(variable, "_raw_", format(dates[i], "%Y%m%d"), ".tif")), overwrite = TRUE)
    }
  }

}