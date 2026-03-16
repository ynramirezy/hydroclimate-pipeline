server <- function(input, output, session) {

  # Loading powiats
  updateSelectizeInput(
    session,
    "powiat",
    choices = sort(unique(powiaty_data$Name)),
    server = TRUE
  )

  # Map
  output$map_results <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      setView(lng = 19.145, lat = 51.919, zoom = 6)
  })

  # Cross control powiat and zip
  observeEvent(input$powiat,
    {
      if (length(input$powiat) > 0) {
        disable("user_shape")
        shinyjs::hide("reset_file")
      } else {
        enable("user_shape")
        shinyjs::show("reset_file")
      }
    },
    ignoreNULL = FALSE
  )

  observeEvent(input$user_shape,
    {
      if (!is.null(input$user_shape)) {
        disable("powiat")
        shinyjs::show("reset_file")
      } else {
        enable("powiat")
        shinyjs::hide("reset_file")
      }
    },
    ignoreNULL = FALSE
  )

  # Reset files
  observeEvent(input$reset_file, {
    reset("user_shape")
    enable("powiat")
    shinyjs::hide("reset_file")
  })

  # Dates logic offset +5 days
  observeEvent(input$start_date,
    {
      date_offset <- input$start_date + 5
      updateDateInput(
        session,
        "end_date",
        value = date_offset,
        min = date_offset
      )
    },
    ignoreInit = TRUE
  )

  # Run observable logic
  observe({
    dates_ok <- as.numeric(input$end_date - input$start_date) >= 5
    polygon_ok <- length(input$powiat) > 0 || !is.null(input$user_shape)
    if (dates_ok && polygon_ok) {
      enable("run")
    } else {
      disable("run")
    }
  })

  console_logs <- reactiveVal("Awaiting execution...")
  download_path <- reactiveVal(NULL)

  observe({
      req(download_path())
      addResourcePath(prefix = "res_folder", directoryPath = download_path())
    })

  # Pipeline execution observable
  observeEvent(input$run, {
    # Spinner
    runjs('
      $("#pipeline_logs").html(
      "<div class=\'spinner-container\'>" + "<div class=\'loader\'></div>" +
      "<span> Running pipeline... please wait</span>" +
      "</div>"
      );
    ')

    shinyjs::disable("run")

    # Setting the zip file
    pipeline_files <- character(0)
    if (!is.null(input$user_shape)) {
      temp_dir <- file.path(tempdir(), "user_shp")
      if (dir.exists(temp_dir)) unlink(temp_dir, recursive = TRUE)
      dir.create(temp_dir)
      unzip(input$user_shape$datapath, exdir = temp_dir)
      files_raw <- list.files(temp_dir, pattern = "\\.shp$", full.names = TRUE, recursive = TRUE)
      pipeline_files <- normalizePath(files_raw[1], winslash = "/", mustWork = FALSE)
      if (length(pipeline_files) == 0) {
        showNotification("Error: No .shp file was found inside the ZIP", type = "error")
        return()
      }
    }

    # Clean map after running
    leafletProxy("map_results") %>%
      clearImages() %>%
      clearControls() %>%
      clearGroup("runoff_layers") %>%
      clearGroup("poly_layers") %>%
      setView(lng = 19.145, lat = 51.919, zoom = 6)

    shinyjs::delay(10, {
      # Running the pipeline
      args_pipeline <- c(
        "hydroclimate-pipeline-web.R",
        format(input$start_date, "%Y-%m-%d"),
        format(input$end_date, "%Y-%m-%d"),
        shQuote(paste(input$powiat, collapse = ",")),
        shQuote(pipeline_files)
      )
      pipeline_results <- system2(
        "Rscript",
        args = args_pipeline,
        stdout = TRUE,
        stderr = TRUE
      )

      # Setting logs
      line_path <- gsub(".*Data is located in: ", "", grep("Data is located in:", pipeline_results, value = TRUE))
      line_path <- trimws(line_path)
      download_path(line_path)
      # Setting path parameters
      line_name <- grep("The terrain-based SCSCN Runoff pipeline for", pipeline_results, value = TRUE)
      folder_path <- file.path(
        line_path,
        paste("Terrain_based_Runoff", format(input$start_date + 5, "%Y%m%d"),
          format(input$end_date, "%Y%m%d"),
          sep = "_"
        )
      )
      pipeline_results <- pipeline_results[!grepl("Data is located in:", pipeline_results)]
      name_poly <- gsub(" ", "_", gsub(" from .*", "", gsub(".*The terrain-based SCSCN Runoff pipeline for ", "", line_name)))
      # Terrain runoff rasters
      paths_rasters <- list.files(folder_path, pattern = "\\.tif$", full.names = TRUE)
      raster_files <- rast(paths_rasters)
      max_value <- max(global(raster_files, fun = c("max"), na.rm = TRUE)$max)
      global_range <- c(0, max_value)
      if (max_value < 1) {
        num_decimals <- 3
      } else if (max_value >= 1 || max_value < 10) {
        num_decimals <- 2
      } else {
        num_decimals <- 1
      }
      pal_raster <- colorNumeric(
        palette = as.character(paletteer_c("grDevices::Oslo", 50)),
        domain = global_range,
        na.color = "transparent"
      )
      # Loading map proxy
      proxy <- leafletProxy("map_results")

      # Adding raster to map
      for (f in as.list(raster_files)) {
        layer_name <- gsub(".tif", "", basename(sources(f)))
        r_web <- terra::project(f, "EPSG:4326")
        r_web[r_web == 0] <- NA
        vals <- as.numeric(terra::values(r_web, mat = FALSE))
        proxy <- proxy %>%
          addRasterImage(r_web,
            colors = pal_raster,
            opacity = 0.8,
            group = layer_name
          )
      }

      # Layer control toggle
      proxy %>%
        addLayersControl(
          overlayGroups = gsub(".tif", "", basename(paths_rasters)),
          options = layersControlOptions(collapsed = FALSE)
        )
      # Adding legend
      proxy %>%
        removeControl("runoff_legend") %>%
        addLegend(
          pal = pal_raster,
          values = global_range,
          title = "Runoff (mm)",
          position = "bottomleft",
          layerId = "runoff_legend",
          opacity = 1,
          labFormat = labelFormat(digits = num_decimals)
        )

      # Zoom runoff rasters
      ext_v <- as.vector(terra::ext(r_web))
      delay(500, {
        leafletProxy("map_results") %>%
          invokeMethod(NULL, "invalidateSize") %>%
          fitBounds(
            lng1 = as.numeric(ext_v["xmin"]),
            lat1 = as.numeric(ext_v["ymin"]),
            lng2 = as.numeric(ext_v["xmax"]),
            lat2 = as.numeric(ext_v["ymax"])
          )
      })

      # Adding pipeline polygon
      v_raw <- terra::vect(file.path(line_path, paste0("SCSCN_Inputs_", name_poly), "GIS_data", paste0(name_poly, ".shp")))
      v_web <- terra::project(v_raw, "EPSG:4326")
      leafletProxy("map_results") %>%
        clearGroup("poly_layers") %>%
        addPolygons(
          data = v_web,
          color = "black",
          weight = 2,
          fillOpacity = 0,
          group = "poly_layers"
        )
      showNotification("All layers loaded into layer control", type = "message")

      # Setting logs
      console_logs(paste(pipeline_results, collapse = "\n"))

      # Creating pipeline output files
      zip_file_path <- file.path(download_path(), "Terrain_Runoff_Pipeline_OUTPUT.zip")
      filesto_zip <- list.files(download_path(), full.names = TRUE)
      zip::zipr(zip_file_path, filesto_zip)

      # Downlading pipeline results
      runjs("
        Swal.fire({
          title: '¡Terrain Runoff Pipeline output data ready!!',
          text: 'Processing is complete. Click the button to download.',
          icon: 'success',
          confirmButtonText: '🡣  Download now',
          confirmButtonColor: '#89ec46'
        }).then((result) => {
          if (result.isConfirmed) {
            window.location.href = 'res_folder/Terrain_Runoff_Pipeline_OUTPUT.zip';
          }
        });
      ")
      shinyjs::enable("run")
    })
    
  })
  output$pipeline_logs <- renderPrint({
    cat(console_logs())
  })
  
}
