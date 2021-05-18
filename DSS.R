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
