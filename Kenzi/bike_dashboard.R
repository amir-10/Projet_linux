## app.R ##
library(shiny)
library(shinydashboard)
require(highcharter)
library(dplyr)
library(httr)
library(jsonlite)
#library(leaflet)

ui <- dashboardPage(
  dashboardHeader(title = "Bike rental"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
      menuItem("second section", tabName = "secondsection", icon = icon("th")),
      menuItem("third section", tabName = "thirdsection", icon = icon("th")),
      menuItem("fourth section", tabName = "fourthsection", icon = icon("th"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "dashboard",
              fluidPage(
                fluidRow(
                  column(width = 4,
                         selectInput("select", label = h5("selectionnez une ville"), 
                                     choices = list("IDF" =2988507, "Lyon" =2973783,"Lille" = 2998324,"Toulouse"=2972315), 
                                     selected = 1)
                  )
                ),
                fluidRow(
                  column(width = 12,
                         plotOutput("AllBikesPlot")
                  )
                ),
                fluidRow(
                  column(width = 12,
                    plotOutput("mBikesPlot")
                  )
                ),
                fluidRow(
                  column(width = 12,
                         plotOutput("eBikesPlot")
                  )
                ),
              )
      ),
      tabItem(tabName = "secondsection",
              fluidPage(
                h2("content is here")
              )
      ),
      tabItem(tabName = "thirdsection",
              fluidPage(
                h2("content is here")
              )
      ), 
      tabItem(tabName = "fourthsection",
              fluidPage(
                h2("content is here")
              )
      )
      
    )
  )
)

server <- function(input, output, session) {
  
  data_bikes <- reactive({
    
    id <- strtoi(input$select)
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
    
    etiquette <- "Pourcentage des vélos disponibles par communes"
    
    if(data_bikes()$city[1] == "IDF"){
      noms <- data_bikes()$nom_arrondissement_communes
    }else if(data_bikes()$city[1] == "Lyon" | data_bikes()$city[1] == "Lille"){
      noms <- data_bikes()$commune
    }else if(data_bikes()$city[1] == "Toulouse"){
      noms <- data_bikes()$address
      etiquette <- "Echantillion des pourcentage des vélos disponibles par quartier"
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
      
      barplot(pourcentage_m,names.arg = noms,las=2,col="red",ylim=c(0,100),main="Pourcentage des vélos mécaniques disponibles par communes")
      
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
      
      barplot(pourcentage_e,names.arg = noms,las=2,col="orange",ylim=c(0,100),main="Pourcentage des vélos électriques disponibles par communes")
      
    }
    
  })
  
}

shinyApp(ui, server)