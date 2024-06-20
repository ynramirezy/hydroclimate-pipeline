#Libraries
library(climate)

##Downloading synoptic meteorogical data for 2023
m = meteo_imgw(interval = "daily", rank = "synop", year = 2023, coords = FALSE)
head(m)
dim(m)

##Setting the records for September and for the daily precipitation
m_sep= m[m$mm==9,]
head(m_sep)
colnames(m_sep)
preci_sep= m_sep[c("id", "station", "mm", "day", "rr_daily")]
head(preci_sep)

##Getting stations and days values
stations= length(unique(preci_sep$station))
days_rr= dim(preci_sep[preci_sep$station == unique(preci_sep$station)[1],])[1]

##Creating the raining day names
shp_names_rr= array()
for(k in 1:days_rr) {
  shp_names_rr[k]= paste("rr_SEP", preci_sep[preci_sep$station == unique(preci_sep$station)[1],]$day[k], sep="")
}

##Creating the dataframe of the precipitation
preci_poland <- data.frame(matrix(ncol = days_rr + 3, nrow = stations))
x <- c(colnames(preci_sep)[1], colnames(preci_sep)[2], colnames(preci_sep)[3], shp_names_rr)
colnames(preci_poland) <- x
dim(preci_poland)

##Populating preci_poland
preci_poland$station= unique(preci_sep$station)
preci_poland$id= unique(preci_sep$id)
preci_poland$mm= 9
for(i in 1:stations){
  for(j in 1:days_rr){
    preci_poland[i,j+3]= preci_sep[preci_sep$station == unique(preci_sep$station)[i],]$rr[j]
  }
}

##Attaching the coordinates
coords_preci= read.csv("C:/Users/usuario/OneDrive/Desktop/AGH/RunOff/DataCatalog/MeteorologicalData/coordinates_stations.txt", sep="\t")
precixy_poland <- merge(preci_poland, coords_preci, by = "id")

#Saving results
write.table(precixy_poland, "C:/Users/usuario/OneDrive/Desktop/AGH/RunOff/DataCatalog/MeteorologicalData/PreciSEP_R.txt", sep="\t", row.names=FALSE, col.names=TRUE)
