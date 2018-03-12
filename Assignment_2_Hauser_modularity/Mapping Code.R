#Making Maps
install.packages(c("ggplot2", "devtools", "dplyr", "stringr"))
install.packages(c("maps", "mapdata"))
install.packages("ggmap")
install.packages("tidyr")
library(ggplot2)
library(ggmap)
library(maps)
library(mapdata)
library(tidyr)
library(dplyr)

coords <- as.data.frame(unique(paste(CTempFrame$lat, CTempFrame$lon)))
mapdat <- separate(data = coords, col = `unique(paste(CTempFrame$lat, CTempFrame$lon))`, into = c("lat", "long"), sep = " ") 
mapdat$slopes <- RVals

usa <- map_data("usa")
ggplot() + geom_polygon(data = usa, aes(x=long, y = lat, group = group)) + 
  coord_fixed(1.3)
+
geom_point(data = coords, aes(x = lon, y = lat)) +
  coord_fixed(1.3)

TempMap <- inner_join(usa, coords)
head(usa)

#http://eriqande.github.io/rep-res-web/lectures/making-maps-with-R.html


