plot_legend <- function(data_rast, target, target_ref) {
  
  main_plot <- function(data_rast, colors_plot) {
    old_mar <- par(mar = c(2, 2, 3, 12))
    plot(data_rast, col = colors_plot, plg = list( cex = 0.8 ), mar = par("mar"))
    mtext(plot_options[[target]]$legend_title, line = 0.3, cex = 0.6, font = 1, adj = 0.5) 
  }
  raster_levels <- function(raster_discr, table_HEX) {
    levels_data <- table_HEX[table_HEX$ID %in% freq(raster_discr)[, "value"], ]
    levels(raster_discr) <- levels_data
    main_plot(raster_discr, levels_data$HEX)
  }
  if (length(plot_options[[target]]$palette) == 1) {
    if (target == "Land_Cover") {
      ClC_reclass <- classify(data_rast, as.matrix(palettes[[target]][, c("GRIDS", "ID")]))
      CLC_data_un <- palettes[[target]] %>% distinct(ID, Label, HEX) 
      raster_levels(ClC_reclass, CLC_data_un)
    } else {
      raster_levels(data_rast, palettes[[target]])
    }
  } else {
    if (all(unique(data_rast)[,1] == 0)){
      main_plot(data_rast, plot_options[[target]]$palette[1])
    } else {
      main_plot(data_rast, plot_options[[target]]$palette)  
    }  
  }
  mtext(paste(gsub("_", " ", target), "of", target_ref), line = 1, cex = 1, font = 1)
  
}