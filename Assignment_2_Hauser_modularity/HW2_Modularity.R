
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

yearsTemp <- 1:ncol(CTempMat)
RValsT <- apply(CTempMat, 1, regressionRval)
SummaryDat[1,1] <- "Temperature (C)"
SummaryDat[1,2]<-summary(RValsT)[1]
SummaryDat[1,3]<-summary(RValsT)[4]
SummaryDat[1,4]<-summary(RValsT)[6]

years2 <- 1:ncol(CPrecipMat)
RVals <- apply(CPrecipMat, 1, regressionRval)
SummaryDat[2,1] <- "Precipitation (inches)"
SummaryDat[2,2]<-summary(RVals)[1]
SummaryDat[2,3]<-summary(RVals)[4]
SummaryDat[2,4]<-summary(RVals)[6]

SummaryDat




#numSets<-length(Datasets)
#for(set in 1:numSets){
#RVals <- apply(Datasets[set], 1, regressionRval)
#SummaryDat[1,1] <- "Temperature (C)"
#SummaryDat[1,2]<-summary(RVals)[1]
#SummaryDat[1,3]<-summary(RVals)[4]
#SummaryDat[1,4]<-summary(RVals)[6]
#}


#typeof(Datasets[1])
 # for(set in seq_along(Datasets)){
 #   return(set[1,1])
 # }
 # typeof(Datasets[1])
#  str(Datasets[1])
#head(Datasets[1])
#help("diff")

round(length(which(RValsT > 0))/length(RValsT)*100)


#A function calculating the p-value of regression slopes for sites in climate datasets
#regressionPval <- function(x)
#{
#  y <- !is.na(x)
#  stat <- lm(y ~ years)
#  rval <- summary(stat)$coefficients[2,4]
#}

#SlopeDatP <- apply(CTempMat, 1, regressionPval)
#PVals <- as.vector(apply(CTempMat, 1, regressionPval))
#summary(PVals)
#length(which(SlopeDatP < 0.05))/length(SlopeDatP)

#SlopeDatP <- apply(CPrecipMat, 1, regressionPval)
#PVals <- as.vector(apply(CPrecipMat, 1, regressionPval))
#summary(PVals)
#length(which(SlopeDatP < 0.05))/length(SlopeDatP)

 