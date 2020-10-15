library(rgdal)
library(sf)
## read shape ==========================================
shape <- st_read("statistical-gis-boundaries-london/London_Borough_Excluding_MHW.shp")
summary(shape)

plot(shape)

shape %>% st_geometry() %>% plot()

## add csv and merge ===================================
library(tidyverse)
mycsv <-  read_csv("fly-tipping-borough_yearcode.csv") 
mycsv 

shape <- shape %>% merge(., mycsv, by.x="GSS_CODE", by.y="code")
shape %>% head(., n=10)

## plot ==================================
library(tmap)
tmap_mode("plot")

shape %>% qtm(., fill = "2011-12")

## export data to gpkg===========================================
### export shape
shape %>% st_write(.,"Rwk1.gpkg", "london_boroughs_fly_tipping", 
                   delete_layer=TRUE) # over write
### export excel
library(readr)
library(RSQLite)

con <- dbConnect(RSQLite::SQLite(), dbname="Rwk1.gpkg")
con %>% dbListTables() # examine contents

con %>% dbWriteTable(., "original_csv", mycsv, overwrite=TRUE)

con %>% dbListTables() # examine contents
con %>% dbDisconnect()
