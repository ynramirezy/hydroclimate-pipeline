# Setting the pipeline environment
if (!requireNamespace("renv", quietly = TRUE)) install.packages("renv")

suppressMessages({
  library(renv)
  invisible(capture.output({
    if (!renv::status()$synchronized) {
      renv::restore(confirm = FALSE)
    }
  }))
})
invisible(capture.output(source("renv/activate.R")))

# Loading libraries
source("pipeline/config/packages.R")

# Loading project sources
source("pipeline/config/utils.R")

# Setting pipeline parameters
source("pipeline/config/parameters.R")

#Setting global variables
source("pipeline/config/settings.R")