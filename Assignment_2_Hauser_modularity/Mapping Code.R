#Making Maps
install.packages(c("maps", "mapdata"))
install.packages("tidyr")
library(maps)
library(mapdata)
library(tidyr)

par(mar=c(0,0,0,0), oma=c(0,0,0,0), mfrow=c(1,2))
coords <- as.data.frame(unique(paste(CTempFrame$lat, CTempFrame$lon)))
mapdat <- separate(data = coords, col = `unique(paste(CTempFrame$lat, CTempFrame$lon))`, into = c("lat", "long"), sep = " ") 
mapdat$slopes <- as.vector(RValsT)
sortedMapDat <-mapdat[rev(order(mapdat$slopes)),]
sortedMapDat <- cbind(sortedMapDat, groups=cut(sortedMapDat$slopes, breaks = c(-Inf,-0.025,-0.0225,-0.02,-0.0175,-.015,-0.0125,-0.01,-0.0075,-.005,-0.0025, 0, 0.0025, 0.005, 0.0075, 0.01, 0.0125, 0.015, 0.0175, 0.02, 0.025, Inf),labels = c(1:21)))

color_Pal_funct <- colorRampPalette(
  colors = c ("slateblue", "red")
)
num_cols <- nlevels(sortedMapDat$groups)
group_cols <- color_Pal_funct(num_cols)

map(regions = "usa", xlim = c(-177,-60), ylim = c(25,72))
points(sortedMapDat$long, sortedMapDat$lat, col = group_cols[sortedMapDat$groups], pch = 20, cex = 0.2)


coordsPr <- as.data.frame(unique(paste(CPrecipFrame$lat, CPrecipFrame$lon)))
mapdatPr <- separate(data = coordsPr, col = `unique(paste(CPrecipFrame$lat, CPrecipFrame$lon))`, into = c("lat", "long"), sep = " ") 
mapdatPr$slopes <- as.vector(RVals)
sortedMapDatPr <-mapdatPr[rev(order(mapdatPr$slopes)),]
sortedMapDatPr <- cbind(sortedMapDatPr, groups=cut(sortedMapDatPr$slopes, breaks = c(-Inf,-0.025,-0.0225,-0.02,-0.0175,-.015,-0.0125,-0.01,-0.0075,-.005,-0.0025, 0, 0.0025, 0.005, 0.0075, 0.01, 0.0125, 0.015, 0.0175, 0.02, 0.025, Inf),labels = c(1:21)))

color_Pal_funct <- colorRampPalette(
  colors = c ("blue", "orange")
)
num_colsPr <- nlevels(sortedMapDatPr$groups)
group_colsPr <- color_Pal_funct(num_colsPr)

map(regions = "usa", xlim = c(-177,-60), ylim = c(25,72))
points(sortedMapDatPr$long, sortedMapDatPr$lat, col = group_colsPr[sortedMapDatPr$groups], pch = 20, cex = 0.2)



#Make a color bar scale.
color.bar <- function(lut, min, max=-min, nticks=11, ticks=seq(min, max, len=nticks), title='') {
  scale = (length(lut)-1)/(max-min)
  
  dev.new(width=1.75, height=5)
  plot(c(0,10), c(min,max), type='n', bty='n', xaxt='n', xlab='', yaxt='n', ylab='', main=title)
  axis(2, ticks, las=1)
  for (i in 1:(length(lut)-1)) {
    y = (i-1)/scale + min
    rect(0,y,10,y+1/scale, col=lut[i], border=NA)
  }
}

