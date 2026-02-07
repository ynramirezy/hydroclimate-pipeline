geostatistical_interpolation<-function(variable) {
  
  extend_base = vect("pipeline/assets/gis_meta/Powiaty.shp")
  tabular_data= read.csv(file.path(outputs[[paste0(variable, "_output")]], paste0(variable, "_RAW"), paste0(variable, "_RAW.txt")), sep="\t")
  for (i in 1:length(dates)) {
    # Checking if there any daily data (experimental noise)
    if(count(na.omit(tabular_data[i+2])) <= 3 || (count(na.omit(tabular_data[i+2])) >= 3 && sd(na.omit(tabular_data[[i+2]])) < 1e-5)) {
      file.copy(from = "pipeline/assets/gis_meta/zero_raster.tif", to = file.path(outputs[[paste0(variable, "_output")]], paste0(variable, "_RAW"), paste0(variable, "_RAW_", format(dates[i], "%Y%m%d"), ".tif")))
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
      variogram_model <- autofitVariogram(z ~ 1, data, fix.values = c(0,NA, NA), model = c("Exp"))
      kriging_result <- gstat::krige(
        formula = z ~ 1,        
        locations = data,       
        newdata = grd,         
        model = variogram_model$var_model  
      )
      raster_krig <- rast(kriging_result["var1.pred"])
      writeRaster(raster_krig, file.path(outputs[[paste0(variable, "_output")]], paste0(variable, "_RAW"), paste0(variable, "_RAW_", format(dates[i], "%Y%m%d"), ".tif")), overwrite = TRUE)
    }
  }

}