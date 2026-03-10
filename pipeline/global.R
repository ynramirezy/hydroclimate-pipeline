# Pipeline starts
cat("\n❇️ Welcome to the Terrain-based SCSCN Runoff Pipeline for Poland!\n")
cat("\n❇️ Pipeline starts\n")
cat("\n❇️ Loading Pipeline sources\n")

# Setting the pipeline environment
if (!requireNamespace("renv", quietly = TRUE)) install.packages("renv")

suppressPackageStartupMessages({
  library(renv)
  if (!renv::status()$synchronized) {
    renv::restore(confirm = FALSE)
  }
  # Loading libraries
  source("pipeline/config/packages.R")
})

invisible(capture.output(source("renv/activate.R"), type = "message"))

# Loading project sources
source("pipeline/config/utils.R")

# Setting pipeline parameters
source("pipeline/config/parameters.R")

#Setting global variables
source("pipeline/config/settings.R")