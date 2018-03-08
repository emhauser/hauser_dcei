
#Chunk 1_Data Import
provided <- TRUE
if (provided = T)
{
  precip <- readRDS("USAAnnualPcpn1950_2008.rds")
  temp <- readRDS("USAAnnualTemp1950_2008.rds")
}
str(dat)
    #Check that this is extensible code. Really? 


#Chunk 2_Data Clean
DataRaw <- temp
MinYearsDat <- 39
RawVar <- data
 CleanUp <- function(DataRaw, MinYearsDat, RawVar)
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
  m <- matrix(ClimateData, ncol = yearnum, byrow = T)
  row.names(m) <- sitenames
  colnames(m) <- years
 }
CleanUp() 
 
CTemp <- CleanUp(temp, MinYearsDat = 39, RawVar = data)
CPrecip <- CleanUp(precip, MinYearsDat = 39, RawVar = data)
head(CTemp)

#Questions:
  #Can we see climate warming
  #In what parts of the country are temps getting warmer? Are there places it got colder?
  # Can we say, based on these data, what change in precip has occurred?
 
 #Chunk4_Warming#
  #Code that shows temp change over time at each location that has 40 or more years of data

head(CTemp)
apply(CTemp, 1, lm())
correl <- cor.test(x=CTemp$data, y=CTemp$year, use = "pairwise.complete.obs" )
plot <- plot(x=CTemp$year, y=CTemp$data)
plot
plot(data~year, data = CTemp[CTemp$state == "ID",])

#matrix where each column is a weather station link between dataframe and matrix is that the nth row if weather station
#reshape2 gather() 

  # on the bottom of Terry's function
CTemp

TempCorrel <- function(dat = CTemp)
  {
  cor(x = dat$data, y = dat$year)
  }

TempCorrel()
help("cor")
aggregate(CTemp, by = list("CTemp$name"), FUN = "TempCorrel") 

help("split")
help(apply)

tempSites <- split(CTemp, CTemp$name)
length(tempSites)
tempSites[2]
head(CTemp)
help("matplot")

lapply(na.omit(tempSites), TempCorrel)
help(cor)
SitesObs <- tempSites[!is.na(tempSites)]
head(SitesObs)

help("matplot")

str(CTemp)
help("with") 
 #Chunk5_PPT#
  #code that shows precip by location, same as above
 
 #Chunk6_Amapofallthisdata#
 
 

 
             
 
 
 
 
help("aggregate")
str(precip)
head(precip)
head(temp)
tail(temp)
str(temp)

plot(data~year, data = temp[temp$state == "AK",])
temp$state
help(apply)
temp[precip$state == "OH",]
AK <- na.omit(temp[temp$state == "AK",])
AKdat <- tapply(AK$data, AK$year, mean)
str(AKdat)
plot(AKdat)
help("na.omit.data.frame")
temps <- na.omit(temp)
wholeTdat <- tapply(temps$data, temps$year, mean)
plot(wholeTdat)
locTemps <- split(temp, temp$state)
locTdat <- tapply (locTemps$data, locTemps$year, mean)
locTemps[30]



