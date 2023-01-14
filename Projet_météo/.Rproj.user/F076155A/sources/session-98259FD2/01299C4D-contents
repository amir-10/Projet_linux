## insertion les données de l'API forcast  ""
library(httr)
#library(jsonlite)
library(mongolite)
library(rjson)
 
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
  # recupération de l'api
  res = GET(paste0("https://api.openweathermap.org/data/2.5/weather?id=",item,"&APPID=af2f6b280ae76a3d215f081e0c014235"))
  #print(res$content)
  data = fromJSON(rawToChar(res$content))
  class(data)
  #df=data.frame(data) 
  visibility=data$visibility
  main=data.frame(data$main)
  coord=data.frame(data$coord)
  #View(coord)
  weather=data.frame(data$weather)
  #print(weather[1,])
  wind=data.frame(data$wind)
  clouds=data.frame(data$clouds)
  sys=data.frame(data$sys)
  id=data$id
  name=data$name
  
  df=data.frame(
    id=id,
    name=name,
    visibility=visibility
    
    
     
    
  )
  df$main=main
  df$wind=wind
  df$sys=sys
  df$weather=weather[1,]
  #View(weather)
  df$clouds=clouds
  df$coord=coord
  
   
  nrow(df)
  x=toJSON(df)
  
  
  # creation d'une collection forcast
  
  weatherCollection = mongo(collection = "CWeather", db = "test")  
  # get first document
  
  
  # verifier l'existance du document par son identifiant
  nb=weatherCollection$count(query = paste0('
  { 
    "id": ',item,'
}'))
  
  # si le document n'existe pas , on insere un nouveau
  if(nb==0){
    weatherCollection$insert(df)
    
  }
  
  #sinon on remplace le document par un nouveau 
  if(nb==1){
     
    
    weatherCollection$replace(query = paste0('
      { 
        "id": ',item,'
    }'), update=toJSON(df))
  }
   
  
  
}

#print(mongo(db = "test"))  
#print(weatherCollection$find(limit=1))


 










