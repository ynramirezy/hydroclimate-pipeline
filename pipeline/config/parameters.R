#Setting the output folder
existing <- list.dirs(path = getwd(), full.names = FALSE, recursive = FALSE)
existing <- existing[grepl("^hydroclimate-pipeline_OUTPUT_", existing)]
next_num <- if(length(existing) == 0) 1 else max(as.integer(sub(".*_(\\d+)$", "\\1", existing))) + 1
folder_pipeline <- paste0(getwd(), "/hydroclimate-pipeline_OUTPUT_", next_num)
dir.create(folder_pipeline)

#Dates for runoff susceptibility index
dates <- seq(start_date, end_date, by = "day")
if (format(start_date, "%Y") < 1960 || start_date > Sys.Date()) {
  stop(paste0("❌ Invalid input: You provided dates out of the range analysis"))
}
if(length(dates)<6) {
  stop(paste0("❌ Invalid input: You provided ", length(dates), " days, but at least 6 days are required to estimate the Runoff Susceptibility Index"))
}

#Adjusting pipeline_polygon name
clean_names <- function(x) {
  x <- iconv(x, to = "ASCII//TRANSLIT")
  x <- gsub("[^[:alnum:]]", "_", x)    
  return(x)
}
powiay_list= read.csv("powiaty_library.csv", encoding = "UTF-8")
if (length(pipeline_polygon) == 1 && grepl("\\.shp$", pipeline_polygon, ignore.case = TRUE) && file.exists(pipeline_polygon)) {
  polygon_name <- "User_polygon"
  polygon_mode= "user"   
} else if (all(pipeline_polygon %in% powiay_list$Name)) {
  if(length(pipeline_polygon) == 1) {
    polygon_name <- clean_names(pipeline_polygon)
  } else if (length(pipeline_polygon) == 2) {
    polygon_name <- paste(clean_names(pipeline_polygon), collapse = "_")
  } else {
    polygon_name <- paste(clean_names(pipeline_polygon[1]), "and", length(pipeline_polygon) - 1, "powiats", "more", sep="_")
  } 
  polygon_mode= "powiat"  
} else {
  stop("❌ Invalid input: please provide a valid vector of powiaty names or a .shp file path.")
}    