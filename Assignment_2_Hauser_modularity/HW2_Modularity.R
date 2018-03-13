
install.packages(maps)
library(maps)

help(map)

#Chunk 1_Data Import
provided <- TRUE
if (provided = T)
{
  precip <- readRDS("USAAnnualPcpn1950_2008.rds")
  temp <- readRDS("USAAnnualTemp1950_2008.rds")
}



#Chunk 2_Data Clean
#Input: Raw Data
Datasets <- c(precip, temp)

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

#for(set in Datasets)
#{
 # cat("C", name(set), "Mat") <- CleanUpMat(DataRaw = temp, MinYearsDat = 39, RawVar = data)
#}
 
CTempMat <- CleanUpMat(DataRaw = temp, MinYearsDat = 39, RawVar = data)
CTempFrame <- CleanUpDataFrame(DataRaw = temp, MinYearsDat = 39, RawVar = data)
CPrecipMat <- CleanUpMat(DataRaw = precip, MinYearsDat = 39, RawVar = data)
CPrecipFrame <- CleanUpDataFrame(DataRaw = precip, MinYearsDat = 39, RawVar = data)


#Questions:
#Can we see climate warming
#In what parts of the country are temps getting warmer? Are there places it got colder?
# Can we say, based on these data, what change in precip has occurred?



#A function calculating regression slopes for sites in climate datasets
regressionRval <- function(x)
  {
        y <- !is.na(x)
        stat <- lm(y ~ years)
        rval <- summary(stat)$coefficients[2,1]
}
years <- unique(temp$year) 
SlopeDat <- apply(CTempMat, 1, regressionRval)
RVals <- as.vector(apply(CTempMat, 1, regressionRval))
summary(SlopeDat)
str(SlopeDat)
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
coords <- as.data.frame(unique(paste(CTempFrame$lat, CTempFrame$lon)))
mapdat <- separate(data = coords, col = `unique(paste(CTempFrame$lat, CTempFrame$lon))`, into = c("lat", "long"), sep = " ") 
mapdat$slopes <- RVals
sortedMapDat <-mapdat[rev(order(mapdat$slopes)),]

map(regions = "usa", xlim = c(-180,-45))
  points(sortedMapDat$long, sortedMapDat$lat, col = c("blue", "red")[sortedMapDat$Groups], pch = 20, cex = 0.2)
  range(mapdat$slopes)

  sortedMapDat["Groups"] <- NA  
 for(sites in 1:nrow(sortedMapDat)){
   sortedMapDat$Groups[sites] <- if(sortedMapDat$slopes[sites]>0){1}else{0}
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
