library(shiny)
library(shinythemes)
library(shinyjs)
library(shinyWidgets)
library(leaflet)
library(paletteer)
library(terra)
library(zip)


powiaty_data <<- read.csv("powiaty_library.csv")
source("pipeline/app/ui.R")
source("pipeline/app/server.R")

shinyApp(ui = ui, server = server)