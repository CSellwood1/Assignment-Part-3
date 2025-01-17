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
settlements<- st_read("Export_Output.shp")
sssi<-st_read("Export_Output_3.shp")
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

#create map with layers control
leaflet() %>% 
  addProviderTiles(providers$Stamen.TerrainBackground, group = "Terrain (default)") %>% 
  addProviderTiles(providers$Esri.WorldImagery, group = "Satellite") %>% 
  addPolygons(data = settlements.ll, color = "red", fillColor = "red", fillOpacity = 0.5, group = "Settlements") %>%
  addPolygons(data = sssi.ll, color = "blue", fillColor = "blue", fillOpacity = 0.5, group = "SSSIs") %>%
  addLayersControl(
    baseGroups = c("Terrain (default)", "Satellite"), 
    overlayGroups = c("SSSIs", "Settlements"),
    options = layersControlOptions(collapsed = TRUE)) %>%
  setView(lat = 54.5471, lng=-3.1687, zoom=10)

#add a legend
leaflet() %>% 
  addProviderTiles(providers$Stamen.TerrainBackground, group = "Terrain (default)") %>% 
  addProviderTiles(providers$Esri.WorldImagery, group = "Satellite") %>% 
  addTiles(group = "Towns and villages")%>%
  addPolygons(data = settlements.ll, color = "red", fillColor = "red", fillOpacity = 0.5, group = "Settlements",  highlightOptions = highlightOptions(color = "yellow", weight = 5, bringToFront = TRUE)) %>%
  addPolygons(data = sssi.ll, color = "blue", fillColor = "blue", fillOpacity = 0.5, group = "SSSIs") %>%
  addLayersControl(
    baseGroups = c("Terrain (default)", "Satellite", "Towns and villages"), 
    overlayGroups = c("SSSIs", "Settlements"),
    options = layersControlOptions(collapsed = TRUE)) %>%
  setView(lat = 54.5471, lng=-3.1687, zoom=10) %>%
addLegend("bottomright",
          colors = c("red", "blue"),
          labels = c("Settlements", "SSSIs"),
          title = "Features",
          opacity = 1)
#create a variable of the settlement info
settlement_info <- paste("Settlement: ", settlements.ll$NAME)
#add info to map

leaflet() %>% 
  addProviderTiles(providers$Stamen.TerrainBackground, group = "Terrain (default)") %>% 
  addProviderTiles(providers$Esri.WorldImagery, group = "Satellite") %>% 
  addTiles(group = "Towns and villages")%>%
  addPolygons(data = settlements.ll, color = "red", fillColor = "red", fillOpacity = 0.5, group = "Settlements", highlightOptions = highlightOptions(color = "yellow", weight = 5, bringToFront = TRUE)) %>%
  addPolygons(data = sssi.ll, color = "blue", fillColor = "blue", fillOpacity = 0.5, group = "SSSIs") %>%
  addLayersControl(
    baseGroups = c("Terrain (default)", "Satellite", "Towns and villages"), 
    overlayGroups = c("SSSIs", "Settlements"),
    options = layersControlOptions(collapsed = TRUE)) %>%
  setView(lat = 54.5471, lng=-3.1687, zoom=10) %>%
  addLegend("bottomright",
            colors = c("red", "blue"),
            labels = c("Settlements", "SSSIs"),
            title = "Features",
            opacity = 1)
  

#connecting app to shiny apps website
install.packages('rsconnect')

#use Cumbria pop data
library(ggplot2)

popdata<-read.csv("Cumbria pop data.csv")

ggplot(data=popdata, aes(x=Area, y=Pop.density)) + geom_bar(stat="identity") +theme_classic() + ylab(expression("Population density per km"^2))

#display app on shiny website

rsconnect::deployApp('assignment shiny.R')
