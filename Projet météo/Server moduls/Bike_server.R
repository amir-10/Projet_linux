Bike_server <- function(input, output, session) {
  
  data_bikes <- reactive({
    
    id <- strtoi(input$selectBike)
    BikesCollection = mongo(collection = "Bikes", db = "AKZN") 
    
    if(id == 2988507){#IDF
      
      tmp = BikesCollection$find(query = '{"city" : "IDF"}')
      
    }else if (id == 2973783){#Lyon
      
      tmp = BikesCollection$find(query = '{"city" : "Lyon"}')
      
    }else if (id == 2998324){#Lille
      
      tmp = BikesCollection$find(query = '{ "city" : "Lille"}')
      
    }else if(id == 2972315){#Toulouse
      
      tmp = BikesCollection$find(query = '{"city" : "Toulouse"}')
      
    }
    
  })
  
  
  
  output$AllBikesPlot <- renderPlot({
    
    pourcentage <- (data_bikes()$numbikes_available/data_bikes()$capacity)*100
    
    etiquette <- "Percentage of bicycles available by municipality"
    
    if(data_bikes()$city[1] == "IDF"){
      noms <- data_bikes()$nom_arrondissement_communes
    }else if(data_bikes()$city[1] == "Lyon" | data_bikes()$city[1] == "Lille"){
      noms <- data_bikes()$commune
    }else if(data_bikes()$city[1] == "Toulouse"){
      noms <- data_bikes()$address
      etiquette <- "Sample of the percentage of bicycles available by district"
    }
    
    barplot(pourcentage,names.arg = noms,las=2,col="#2D69B3",ylim=c(0,100),main=etiquette)
    
  })
  
  output$mBikesPlot <- renderPlot({
    
    if(data_bikes()$city[1] != "Lille" && data_bikes()$city[1] != "Toulouse"){
      
      pourcentage_m <- (data_bikes()$mbike_available/data_bikes()$capacity)*100
      
      if(data_bikes()$city[1] == "IDF"){
        noms <- data_bikes()$nom_arrondissement_communes
      }else if(data_bikes()$city[1] == "Lyon"){
        noms <- data_bikes()$commune
      }
      
      barplot(pourcentage_m,names.arg = noms,las=2,col="red",ylim=c(0,100),main="
Percentage of mechanical bicycles available by municipality")
      
    }
    
  })
  
  output$eBikesPlot <- renderPlot({
    
    if(data_bikes()$city [1] != "Lille" && data_bikes()$city[1] != "Toulouse"){
      
      pourcentage_e <- (data_bikes()$ebike_available/data_bikes()$capacity)*100
      
      if(data_bikes()$city[1] == "IDF"){
        noms <- data_bikes()$nom_arrondissement_communes
      }else if(data_bikes()$city[1] == "Lyon"){
        noms <- data_bikes()$commune
      }
      
      barplot(pourcentage_e,names.arg = noms,las=2,col="orange",ylim=c(0,100),main="Percentage of electric bikes available by municipality")
      
    }
    
  })
  
}