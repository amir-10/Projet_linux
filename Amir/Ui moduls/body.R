
body <-  dashboardBody(
  
  tabItems(
    tabItem(tabName = "dashboard",
            fluidPage(
              fluidRow(
                column(width = 4,
                       selectInput("select", label = h5("selectionnez une ville"), 
                                   choices = list("Paris" =2988507, "Strasbourg" =2973783, "Lille"=2998324,
                                                  "Marseille"=2995468, "Nice"=2990439,"Lyon"=2996943,
                                                  "Bordeaux"=3031582,"Toulouse"=2972315, "Rouen"=2982652), 
                                   selected = 1)
                       
                       
                )
              ),
              fluidRow(
                column(width = 12,
                       box(
                         width = 12,
                         
                         title = "Carte géographique", status = "primary", solidHeader = TRUE,
                         collapsible = TRUE,
                         #below function is used to define a highcharter output plot which will be made in the server side
                         leafletOutput(outputId="map",height = 300)
                       ) #end box2) 
                       
                )
              ),
              fluidRow(
                column(width = 4, infoBoxOutput(width = 12,"tempBox")) ,
                column(width = 4,infoBoxOutput(width = 12,"weatherMainBox")) ,
                column(width = 4,infoBoxOutput(width = 12,"feelTempBox"))
              ),
              fluidRow(
                column(width = 4,infoBoxOutput(width = 12,"pressureBox")) ,
                column(width = 4,infoBoxOutput(width = 12,"humidityBox")) ,
                column(width = 4,infoBoxOutput(width = 12,"windBox"))
                
              ),
              fluidRow(
                
                
                #column(width = 12,
                #box(width = 12,
                # title = "humidity", status = "primary", solidHeader = TRUE,
                # collapsible = TRUE,
                #plotOutput("plot1"))
                #),
                fluidRow(
                  column(width = 12,
                         box(
                           width = 12,
                           title = "Prévisions météo à 5 jours", status = "primary", solidHeader = TRUE,
                           collapsible = TRUE,
                           #below function is used to define a highcharter output plot which will be made in the server side
                           highchartOutput("hcontainer")
                         ) #end box2
                  )
                )
              )
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
    
    #second interface is here
    
  )
  
  
)
