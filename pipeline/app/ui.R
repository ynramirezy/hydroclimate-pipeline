ui <- fluidPage(

  # App iu settings
  useShinyjs(),
  useSweetAlert(),
  theme = shinytheme("flatly"),
  tags$head(
    tags$style(HTML(readLines("www/style.css", warn = FALSE))),
  ),
  
  # Main title
  div(class = "header-container",
    img(src = "logo.svg", class = "header-logo"), 
    div(class = "header-title", 
      h3("Terrain-based SCS-CN Runoff Pipeline for Poland"),
    )
  ),
  
  # Main app column
  fluidRow(class = "top-row",
    div(class = "col-sidebar",
      wellPanel(
        # Left column 20%
        h5(class="sub-title", "Setting parameters"),
        dateInput("start_date", "Start date", min = "1960-01-01", max = Sys.Date() - 12, value = as.Date(paste0(format(Sys.Date(), "%Y"), "-01-01"))),
        dateInput("end_date", "End date", min = as.Date(paste0(format(Sys.Date(), "%Y"), "-01-06")), max = Sys.Date() - 7, value = as.Date(paste0(format(Sys.Date(), "%Y"), "-01-06"))),
        selectizeInput("powiat", "Select counties", choices = NULL, multiple = TRUE, options = list(placeholder = 'Type to search...', allowEmptyOption = TRUE)),
        p("or upload a custom polygon"),
        fileInput("user_shape", "Shapefile (.zip)", accept = ".zip"),
        hidden(
          actionButton("reset_file", "Clean file", class = "btn-xs")
        ),
        br(),
        br(), 
        disabled(
          actionButton("run", "▷ Run pipeline", class = "btn-primary")
        ),
      )
    ),
    # Right column 80%
    div(class = "col-map",
      leafletOutput("map_results")
    )
  ),
  
  # Low app side
  div(class = "bottom-row",
    div(class = "col-console",
      verbatimTextOutput("pipeline_logs")
    )
  ),

tags$a(id = "download_results_hidden", 
       href = "", 
       download = "Terrain_Runoff_Pipeline_OUTPUT.zip", 
       style = "display: none;")
)
