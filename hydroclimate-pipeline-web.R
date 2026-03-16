#Welcome to the Terrain-based SCSCN Runoff Pipeline for Poland!
#This tool generates runoff rasters based on terrain features and SCS-CN methodology

args <- commandArgs(trailingOnly = TRUE)

# Please set the following parameters before running:
start_date <- as.Date(args[1])
end_date <- as.Date(args[2])

# Set the powiaty name or the shapefile path
pipeline_polygon <- args[3]
print(pipeline_polygon )

#And load the pipeline modules and functions
source("pipeline/global.R")

#Then, run the functions and wait while the results are generated!
runoff()
validation()