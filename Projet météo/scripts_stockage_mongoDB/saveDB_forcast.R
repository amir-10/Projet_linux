## insertion les données de l'API forcast  ""
library(httr)
library(jsonlite)
library(mongolite)

villes=c("Paris","Lyon","Nice",
         "Strasbourg",
         "Bordeaux ",
         "Le Havre",
         "Lille",
         "Angers",
         "Brest",
         "Nîmes",
         "Marseille",
         "Toulouse",
         "Nantes",
         "Montpellier",
         "Rennes",
         "Saint-Étienne",
         "Dijon",
         "Amiens",
         "Rouen"
)

codeville=c(2988507,
            2996943,
            2990439,
            2973783,
            3031582,
            3003796,
            2998324,
            3037656,
            6448047,
            2990362,
            2995468,
            2972315,
            2990968,
            2992166,
            2983989,
            2980288,
            3021372,
            3037854,
            2982652
)
for (item in  codeville) {
  #print(item)

# recupération de l'api
res = GET(paste0("https://api.openweathermap.org/data/2.5/forecast?id=",item,"&APPID=af2f6b280ae76a3d215f081e0c014235"))
#print(res$content)
data = fromJSON(rawToChar(res$content))
#cat(toJSON(data)) 
#class(data)
#print(data) 
city=data$city
#View(data)
forcast=data$list
#class(forcast)
#View(forcast)
# visualiser la structure
#dput(head(forcast))

# creation d'une collection forcast

forcastCollection = mongo(collection = "forcast", db = "AKZN")  
# get first document

#df2 = forcastCollection$find(limit=1)
# visualiser la structure du dataframe
#dput(head(df2))

# insert API data in collection

ID=c("1")
df <- data.frame(ID)
# create le document du mongodb sou forme du datafrmae (chaque ligne dans le DF represente un document)
ville=data.frame(name=c(city$name),
                 id=city$id,
                 coord=city$coord, 
                 sunrise=c(city$sunrise),
                 sunset=c(city$sunset)
)

df$city <- ville
#View(df)
df$list <-list(data$list)
#View(list(data$list))
#dput(head(list(data.frame(data$list))))
#View(list(data.frame(data$list)))


 


# insertion du document dans la collection
 
nb= forcastCollection$count(query = paste0('
    { 
      "city.id": ',item,'
  }'))
if(nb==0){
  forcastCollection$insert(toJSON(data))
  
}
if(nb==1){
  forcastCollection$replace(query = paste0('
      { 
        "city.id": ',item,'
    }'), update=toJSON(data))
  
}
 
}
  

#print(weatherCollection$find(limit=1))



 






