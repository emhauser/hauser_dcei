
#Chunk 1_Data Import
provided <- TRUE
if (provided = T)
{
  precip <- readRDS("USAAnnualPcpn1950_2008.rds")
  temp <- readRDS("USAAnnualTemp1950_2008.rds")
}

    #Check that this is extensible code. Really? 


#Chunk 2_Data Clean
 MinYearsDat <- 40
 DataRaw <- precip
 RawVar <- data
 AggregateGroups <- list(DataRaw$state, DataRaw$name, DataRaw$lat, DataRaw$lon)
 NaCount <- function(dat=DataRaw$RawVar)
  {
    return(sum(is.na(dat)))
  }
 DatClean <- aggregate.data.frame(DataRaw, by = AggregateGroups, FUN = "NaCount")

 CleanDat <- DatClean[DatClean$data >= MinYearsDat,]


 
 #Convert Data to matrix
 

#Questions:
  #Can we see climate warming
  #In what parts of the country are temps getting warmer? Are there places it got colder?
  # Can we say, based on these data, what change in precip has occurred?
 
 #Chunk4_Warming#
  #Code that shows temp change over time at each location that has 40 or more years of data

 
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

help(
