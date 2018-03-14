#DataCleanupCodes
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
}d
