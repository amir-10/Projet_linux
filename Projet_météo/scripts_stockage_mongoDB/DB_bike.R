library(shiny)
library(shinydashboard)
library(mongolite)
require(highcharter)
library(dplyr)
library(httr)
library(jsonlite)

date <- Sys.Date()

IDF <- mongo(collection = "IDF", db = "AKZN")

IDF$remove('{}')

res = GET(paste0("https://opendata.paris.fr/api/records/1.0/search/?dataset=velib-disponibilite-en-temps-reel&q=&rows=1000&facet=nom_arrondissement_communes"))
data = fromJSON(rawToChar(res$content))
dfp <- data.frame(data)
df <- dfp$records.fields

df <- df[,-c(1,2,5,6,8,10,11,13)]

grp_nom_arrondissement_communes <- df %>% group_by(nom_arrondissement_communes) %>% 
  summarise(ebike_available = sum(ebike),
            mbike_available = sum(mechanical),
            numbikes_available = sum(numbikesavailable),
            capacity = sum(capacity),
            city = "IDF",
            .groups = 'drop'
  )
IDF$insert(grp_nom_arrondissement_communes)


Lyon <- mongo(collection = "Lyon", db = "AKZN")

Lyon$remove('{}')

res = GET(paste0("https://download.data.grandlyon.com/ws/rdata/jcd_jcdecaux.jcdvelov/all.json?maxfeatures=-1&start=1"))
data = fromJSON(rawToChar(res$content))
df <- data$values$total_stands
df$commune <- data$values$commune
grp_nom_arrondissement_communes <- df %>% group_by(commune) %>% 
  summarise(ebike_available = sum(availabilities$electricalBikes),
            mbike_available = sum(availabilities$mechanicalBikes),
            numbikes_available = sum(availabilities$bikes),
            capacity = sum(capacity),
            city="Lyon",
            .groups = 'drop'
)
Lyon$insert(grp_nom_arrondissement_communes)


Lille <- mongo(collection = "Lille", db = "AKZN")

Lille$remove('{}')

res = GET("https://opendata.lillemetropole.fr/api/records/1.0/search/?dataset=vlille-realtime&q=&rows=500&facet=libelle&facet=nom&facet=commune&facet=etat&facet=type&facet=etatconnexion")
data = fromJSON(rawToChar(res$content))
df <- data$records$fields
df <- df[,-c(3,4,5,6,8,9,10,11,12)]


grp_nom_arrondissement_communes <- df %>% group_by(commune) %>% 
  summarise(
    numbikes_available = sum(nbvelosdispo),
    capacity = sum(nbvelosdispo)+sum(nbplacesdispo),
    city="Lille",
    .groups = 'drop'
  )
Lille$insert(grp_nom_arrondissement_communes)


Toulouse <- mongo(collection = "Toulouse", db = "AKZN")

Toulouse$remove('{}')

res = GET("https://data.toulouse-metropole.fr/api/records/1.0/search/?dataset=api-velo-toulouse-temps-reel&q=&rows=50")
data = fromJSON(rawToChar(res$content))
df <- data$records$fields
grp_nom_arrondissement_communes <- df %>% group_by(address) %>% 
  summarise(numbikes_available = sum(available_bikes),
            capacity = sum(bike_stands),
            city="Toulouse",
            .groups = 'drop'
  )
Toulouse$insert(grp_nom_arrondissement_communes)