#Loading libraries

library(automap)
library(climate)
library(data.table)
library(dplyr)
library(FNN)
library(gstat)
library(httr)
library(lubridate)
library(paletteer)
library(pals)
library(pander)
library(ragg)
library(raster)
library(sp)
library(terra)
library(whitebox)

if (!whitebox::wbt_init()) {
  message("Whitebox engine not found. Installing...")
  whitebox::wbt_install()
}