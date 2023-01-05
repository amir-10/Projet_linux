library(jsonlite)
library(mongolite)
library("lubridate")  
library(maps)
library(httr)
startdate <- Sys.Date()
enddate <- Sys.Date()+4
townList <-  c("Paris", "Nice","Strasbourg", "Bordeaux", "Le Havre", "Lille", 
               "Angers","Brest","Marseille", "Toulouse", "Nantes", "Montpellier", 
               "Rennes", "Dijon", "Amiens","Rouen")

start_date<- as.character(startdate)
end_date<- as.character(enddate)

z<-as.data.frame(world.cities)
con <- mongo (collection = "AirQuality" , url="mongodb://127.0.0.1:27017/AKZN")
con$remove('{}')
for ( ville  in townList) {
  #print(ville) 
  city <-z[ z$name== ville & z$country.etc=='France',]
  lat <- city$lat
  long <- city$long
  latt <- as.character(lat)
  longg <- as.character(long)
  #res = GET(url)
  url <- paste0("https://air-quality-api.open-meteo.com/v1/air-quality?latitude=",latt,"&longitude=", longg, "&hourly=pm10,pm2_5,carbon_monoxide,nitrogen_dioxide,sulphur_dioxide,ozone,alder_pollen,birch_pollen,grass_pollen,european_aqi,european_aqi_pm2_5,european_aqi_pm10,european_aqi_no2,european_aqi_o3,european_aqi_so2&start_date=",start_date, "&end_date=", end_date)
  res = GET(url)
  
  data <- fromJSON(rawToChar(res$content))
  x<-rep(c(ville),times=120)
   
  a=data.frame(city=x)
  
  data$city=a
  
  #con <- mongo (collection = "AirQuality" , url="mongodb://127.0.0.1:27017/AKZN")
  #con$remove('{}')
  con$insert(data)
                      
  
}




