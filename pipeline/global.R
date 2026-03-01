# Setting the pipeline environment
source("renv/activate.R")
if (!requireNamespace("renv", quietly = TRUE)) install.packages("renv")
if (!renv::status()$synchronized) {
  message("Setting the pipeline environmet, it can take some minutes...")
  renv::restore(confirm = FALSE)
}

# Loading libraries
source("pipeline/config/packages.R")

# Loading project sources
source("pipeline/config/utils.R")

# Setting pipeline parameters
source("pipeline/config/parameters.R")

#Setting global variables
source("pipeline/config/globals.R")