# Setting the pipeline environment
invisible(capture.output(source("renv/activate.R"), type = "message"))
.libPaths(c("renv/library/windows/R-4.5/x86_64-w64-mingw32", .libPaths()))

library(terra)
library(shiny)
library(shinythemes)
library(shinyjs)
library(shinyWidgets)
library(leaflet)
library(zip)
library(paletteer)

powiaty_data <<- read.csv("powiaty_library.csv")
source("pipeline/app/ui.R")
source("pipeline/app/server.R")

shinyApp(ui = ui, server = server)