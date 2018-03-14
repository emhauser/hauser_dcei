
install.packages(maps)
library(maps)

#Chunk 1_Data Import
provided <- TRUE
if (provided = TRUE)
{
  precip <- readRDS("USAAnnualPcpn1950_2008.rds")
  temp <- readRDS("USAAnnualTemp1950_2008.rds")
}



#Chunk 2_Data Clean
#Input: Raw Data

DataRaw <- temp
MinYearsDat <- 39
RawVar <- data

CleanUpMat <- function(DataRaw, MinYearsDat, RawVar)
    {
     NaCount <- function(dat=DataRaw$RawVar)
      {
     return(sum(is.na(dat)))
       }
  AggregateGroups <- list(DataRaw$state, DataRaw$name, DataRaw$lat, DataRaw$lon)
  DatClean <- aggregate.data.frame(DataRaw, by = AggregateGroups, FUN = "NaCount")
  CleanDat <- DatClean[DatClean$data < MinYearsDat, "Group.2"]
  CDat <- DataRaw[DataRaw$name%in%CleanDat,]
  years <- as.vector(unique(CDat$year))
  yearnum <-length(years)
  sitenames <- unique(paste(CDat$state, CDat$name, CDat$lat, CDat$lon))
  ClimateData <- CDat$data
  m <- matrix(ClimateData, ncol = yearnum, byrow = T, dimnames = list(sitenames, years))
 }

 CleanUpDataFrame <- function(DataRaw, MinYearsDat, RawVar)
 {
     NaCount <- function(dat=DataRaw$RawVar)
     {
      return(sum(is.na(dat)))
      }
   AggregateGroups <- list(DataRaw$state, DataRaw$name, DataRaw$lat, DataRaw$lon)
   DatClean <- aggregate.data.frame(DataRaw, by = AggregateGroups, FUN = "NaCount")
   CleanDat <- DatClean[DatClean$data < MinYearsDat, "Group.2"]
   CDat <- DataRaw[DataRaw$name%in%CleanDat,]
 }


CTempMat <- CleanUpMat(DataRaw = temp, MinYearsDat = 39, RawVar = data)
CTempFrame <- CleanUpDataFrame(DataRaw = temp, MinYearsDat = 39, RawVar = data)
CPrecipMat <- CleanUpMat(DataRaw = precip, MinYearsDat = 39, RawVar = data)
CPrecipFrame <- CleanUpDataFrame(DataRaw = precip, MinYearsDat = 39, RawVar = data)


#Questions:
#Can we see climate warming
#In what parts of the country are temps getting warmer? Are there places it got colder?
# Can we say, based on these data, what change in precip has occurred?



#A function calculating regression slopes for sites in climate datasets
Datasets <- list(as.matrix(CTempMat),as.matrix(CPrecipMat))
years <- 1:ncol(CTempMat)
SummaryDat <- setNames(data.frame(matrix(ncol = 4, nrow = length(Datasets))), c("Climate Variable", "Minimum Change Rate", "Mean Change Rate", "Maximum Change Rate"))
  regressionRval <- function(x)
      {
          y <- !is.na(x)
          stat <- lm(y ~ years)
          rval <- summary(stat)$coefficients[2,1]
  }
numSets<-length(Datasets)
for(set in 1:numSets){
RVals <- apply(Datasets[set], 1, regressionRval)
SummaryDat[set,1] <- "Temperature (C)"
SummaryDat[set,2]<-summary(RVals)[1]
SummaryDat[set,3]<-summary(RVals)[4]
SummaryDat[set,4]<-summary(RVals)[6]
}
typeof(Datasets[1])
  for(set in seq_along(Datasets)){
    return(set[1,1])
  }
  typeof(Datasets[1])
  str(Datasets[1])
head(Datasets[1])
help("diff")




length(which(SlopeDat > 0))/length(SlopeDat)

#A function calculating the p-value of regression slopes for sites in climate datasets
regressionPval <- function(x)
{
  y <- !is.na(x)
  stat <- lm(y ~ years)
  rval <- summary(stat)$coefficients[2,4]
}

SlopeDatP <- apply(CTempMat, 1, regressionPval)
PVals <- as.vector(apply(CTempMat, 1, regressionPval))
summary(PVals)
length(which(SlopeDatP < 0.05))/length(SlopeDatP)

SlopeDatP <- apply(CPrecipMat, 1, regressionPval)
PVals <- as.vector(apply(CPrecipMat, 1, regressionPval))
summary(PVals)
length(which(SlopeDatP < 0.05))/length(SlopeDatP)

 
 #Chunk6_Amapofallthisdata#

###Mapping###
library(maps)
library(tidyr)
install.packages("colorRamps")
library(colorRamps)
install.packages("RColorBrewer")
library(RColorBrewer)
coords <- as.data.frame(unique(paste(CTempFrame$lat, CTempFrame$lon)))
mapdat <- separate(data = coords, col = `unique(paste(CTempFrame$lat, CTempFrame$lon))`, into = c("lat", "long"), sep = " ") 
mapdat$slopes <- RVals
sortedMapDat <-mapdat[rev(order(mapdat$slopes)),]
sortedMapDat <- cbind(sortedMapDat, groups=cut(sortedMapDat$slopes, breaks = c(-Inf,-0.025,-0.0225,-0.02,-0.0175,-.015,-0.0125,-0.01,-0.0075,-.005,-0.0025, 0, 0.0025, 0.005, 0.0075, 0.01, 0.0125, 0.015, 0.0175, 0.02, 0.025, Inf),labels = c(1:21)))
head(sortedMapDat)

color_Pal_funct <- colorRampPalette(
  colors = c ("slateblue", "red")
)
num_cols <- nlevels(sortedMapDat$groups)
group_cols <- color_Pal_funct(num_cols)

map(regions = "usa", xlim = c(-177,-60), ylim = c(25,72))
  points(sortedMapDat$long, sortedMapDat$lat, col = group_cols[sortedMapDat$groups], pch = 20, cex = 0.2)
  par(mar=c(0,0,0,0), oma=c(0,0,0,0))

  range(sortedMapDat$lat)
sortedMapDat[sortedMapDat$groups==12,]






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
  


 unique(sortedMapDat$Groups)
  
  
help(map)
install.packages("mapproj")
library("mapproj")
install.packages("ggplot2")


if(require(mapproj)) {
  head(unemp) 
  
  
  # load data
  # unemp includes data for some counties not on the "lower 48 states" county
  # map, such as those in Alaska, Hawaii, Puerto Rico, and some tiny Virginia
  #  cities
  data(unemp)
  data(county.fips)
  
  # define color buckets
  colors = c("#F1EEF6", "#D4B9DA", "#C994C7", "#DF65B0", "#DD1C77", "#980043")
  unemp$colorBuckets <- as.numeric(cut(unemp$unemp, c(0, 2, 4, 6, 8, 10, 100)))
  leg.txt <- c("<2%", "2-4%", "4-6%", "6-8%", "8-10%", ">10%")
  
  # align data with map definitions by (partial) matching state,county
  # names, which include multiple polygons for some counties
  cnty.fips <- county.fips$fips[match(map("county", plot=FALSE)$names,
                                      county.fips$polyname)]
  colorsmatched <- unemp$colorBuckets [match(cnty.fips, unemp$fips)]
  
  # draw map
  map("county", col = colors[colorsmatched], fill = TRUE, resolution = 0,
      lty = 0, projection = "polyconic")
  map("state", col = "white", fill = FALSE, add = TRUE, lty = 1, lwd = 0.2,
      projection="polyconic")
  title("unemployment by county, 2009")
  legend("topright", leg.txt, horiz = TRUE, fill = colors)
  
}

data(county_df)
mid_range <- function(x) mean(range(x, na.rm = TRUE))
centres <- ddply(county_df, c("state", "county"), summarise, 
                 lat = mid_range(lat), 
                 long = mid_range(long)
)
help(ddply)

help("aes")
library(ggplot2)
TempSites <- unique(paste(CTempFrame$lat, CTempFrame$lon))

typeof(TempSites)
bubbles <- cbind(RVals, unique(CTempFrame$lat), unique(CTempFrame$lon))
ggplot(bubbles, aes(long, lat)) +
  geom_polygon(aes(group = group), data = state_df, 
               colour = "white", fill = NA) +
  geom_point(aes(size = rate), alpha = 1/2) +
  scale_area(to = c(0.5, 3), breaks = c(5, 10, 20, 30))

ggplot(bubbles, aes(long, lat)) +
  geom_polygon(aes(group = group), data = state_df, 
               colour = "white", fill = NA) +
  geom_point(aes(color = rate_d)) +
  scale_colour_brewer(pal = "PuRd")
data(ozone)
head(ozone)
help(map)

data(ozone) 
map()
map(database = "usa")
points(CTempFrame$lon~CTempFrame$lat)
head(CTempFrame)
text(CTempFrame$lon, CTempFrame$lat, RVals)
library(ggmap) #color palates, color maps

help("map")
map(CTempFrame$data)
