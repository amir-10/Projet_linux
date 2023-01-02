
# This script updates the horoscope collection in our mongo data base
# It should be called once a day

# It makes sure that the collection has the right structure (number of docs and value fields for the sign names)
# Then updates it by calling the aztro API
# API doc : https://rapidapi.com/sameer.kumar/api/aztro/


library(mongolite)
library(httr)


sign_name <- c('aries', 'taurus', 'gemini', 'cancer',
               'leo', 'virgo', 'libra', 'scorpio',
               'sagittarius', 'capricorn', 'aquarius', 'pisces')


#connect to the collection and db
horoscope <- mongo(collection = "horoscope", db = "linuxproject")

#get the number of documents in the collection
nb.docs <- horoscope$count()

#if nb.docs != 0 and != 12, then there's been some unwanted manipulation done to the collection, 
# we'll have to remove everything to fill it up again
if(nb.docs != 12 & nb.docs != 0){
  horoscope$remove('{}')
  nb.docs <- 0
} else if (nb.docs == 12){  
  #make sure we have the same sign names
  sign.names <- horoscope$find(fields = '{"sign_name" : true, "_id": false}')
  both <- sign_name %in% unlist(sign.names)
  if (FALSE %in% both){
    nb.docs <- 0
  }
}

#if nb.docs = 0 : it means that the collection was never filled or was emptied,
#we'll create the 12 docs, one for each sign
#we'll start by giving the sign name field:
if(nb.docs == 0){
  for(sn in sign_name) {
    horoscope$insert(paste0('{ \"sign_name\" : \"', sn, '\" }'))
  }
}


#We can add sign_name field as an index since we will use it for all the queries 
indexes <- horoscope$index()
if(nrow(indexes) == 1){
  
  #add sign_name as index:
  horoscope$index('{ "sign_name" : 1 }')
}



#At this point, we're sure to have 12 docs with the right names
# Now we'll call the API to update the docs:
url <- "https://sameer-kumar-aztro-v1.p.rapidapi.com/"

queryString <- list(
  sign = '',
  day = 'tomorrow'
)

#iterate on every sign to update the 12 docs:
for (s in sign_name) {
  
  #get the data of the sign name from the API
  queryString$sign <- s
  response <- VERB("POST", url, 
                   add_headers('X-RapidAPI-Key' = 'adeb7a202dmsh5fea2b1e4e8b773p17937bjsna13b311ffa5e',
                               'X-RapidAPI-Host' = 'sameer-kumar-aztro-v1.p.rapidapi.com'),
                   query = queryString,
                   content_type("application/octet-stream"))
  
  #the data we want is stored in this list
  cont <- content(response)
  col.names <- names(cont)
  
  #iterate on every 'column' of the list and put it as a field of the doc with the s sign name:
  for(field in col.names){
    query <- paste0(' { \"sign_name\" : \"', s, '\"} ')
    update <- paste0( '{\"$set\" : { \"',
                   field,
                   '\" : \"',
                   cont[[field]],
                   '\"}}' )
    
    horoscope$update(query = query, update = update )
  }
  
}

