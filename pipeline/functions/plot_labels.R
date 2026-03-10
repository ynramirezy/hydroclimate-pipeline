plot_labels <- function() {
  
  # Adding the pipeline vect
  plot(pipeline_vect, add= TRUE)
  if (polygon_mode== "powiat" && length(pipeline_polygon) > 1) {
    text(pipeline_vect, labels = "Name", cex = 0.6, col = "black", font = 1)
  }
  
}