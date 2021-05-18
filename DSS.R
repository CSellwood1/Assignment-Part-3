#Assignment part 3 -DSS

#plan is to make a map of sssi across cumbria

#start with making a map
options("rgdal_show_exportToProj4_warnings"="none") #suppresses certain warnings
library(sf)
library(raster)
library(mapview)
library(leaflet)
library(leafem)

#going to use a normal background map not an elevation
leaflet() %>% 
  addProviderTiles(providers$Stamen.TerrainBackground) #shows terrain with no cities!

#read in shape files
settlements<- st_read("Project Data/Export_Output.shp")
sssi<-st_read("Project Data/Export_Output_3.shp")
#retrieve coord reference system from the objects
st_crs(settlements)
st_crs(sssi)#both 27700

#transform to lat long
settlements.ll<-st_transform(settlements, 4326)
sssi.ll<-st_transform(sssi, 4326)
plot(sssi.ll)

#add to basemap
leaflet() %>% 
  addProviderTiles(providers$Stamen.TerrainBackground) %>%
  addFeatures(sssi.ll)

leaflet() %>% 
  addProviderTiles(providers$Stamen.TerrainBackground) %>%
  addFeatures(settlements.ll)

#trying adding as polygons instead
leaflet() %>% 
  addProviderTiles(providers$Stamen.TerrainBackground) %>%
  addPolygons(data = settlements.ll, color = "red", fillColor = "red", fillOpacity = 0.5) %>%
  addPolygons(data = sssi.ll, color = "blue", fillColor = "red", fillOpacity = 0.5)
