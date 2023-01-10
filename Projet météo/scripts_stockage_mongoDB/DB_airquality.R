library(jsonlite)
library(mongolite)
library("lubridate")
library(maps)
library(httr)


# l'API fournit les données d'aujourdui et des 3 jours à venir 

startdate <- Sys.Date()
enddate <- Sys.Date()+3
start_date<- as.character(startdate)
end_date<- as.character(enddate)


#Les villes traitées

townList <-  c("Paris", "Nice","Strasbourg", "Bordeaux", "Le Havre", "Lille",
               "Angers","Brest","Marseille", "Toulouse", "Nantes", "Montpellier",
               "Rennes", "Dijon", "Amiens","Rouen")


# Pour récupérer la longitude et la latitude d'une ville à partir de son nom

z<-as.data.frame(world.cities)

#Connexion à la base de de données AKZN et à la collection AirQuality 

con <- mongo (collection = "AirQuality" , url="mongodb://127.0.0.1:27017/AKZN")


con$remove('{}')

#Stocker les données relatives à chaque ville 

for ( ville  in townList) {
  
  city <-z[ z$name== ville & z$country.etc=='France',]
  lat <- city$lat
  long <- city$long
  latt <- as.character(lat)
  longg <- as.character(long)
  
  #Construire l'url et faire appel à 'API OPEN METEO
  
  url <- paste0("https://air-quality-api.open-meteo.com/v1/air-quality?latitude=",latt,"&longitude=", longg, "&hourly=pm10,pm2_5,carbon_monoxide,nitrogen_dioxide,sulphur_dioxide,ozone,european_aqi&start_date=",start_date, "&end_date=", end_date)
  res = GET(url)
  
  #Ajouter le nom de la ville aux données récupérées
  
  data <- fromJSON(rawToChar(res$content))
  data <- append(data, c(ville), after =0)
  names(data)[[1]] <- "ville"
  
  
 
  #Stocker les données dans la base de données AKZN et dans la collection AirQuality
  
  con$insert(data)
}


