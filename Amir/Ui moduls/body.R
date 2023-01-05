######### horoscope ############
signs <- c( 'aries'      , 'taurus'   ,'gemini'   , 'cancer' ,
            'leo'        ,  'virgo'   ,'libra'    , 'scorpio',
            'sagittarius', 'capricorn', 'aquarius', 'pisces')


images_cute <- c(
  "aries.png",
  "taurus.png",
  "gemini.png",
  "cancer.png",
  "leo.png",
  "virgo.png",
  "libra.png",
  "scorpio.png",
  "sagittarius.png",
  "capricorn.png",
  "aquarius.png",
  "pisces.png"
  
)

############## End ###############"
############ airquality ####################

# Liste des villes
townList <-  c("Paris", "Nice","Strasbourg", "Bordeaux", "Le Havre", "Lille", 
               "Angers","Brest","Marseille", "Toulouse", "Nantes", "Montpellier", 
               "Rennes", "Dijon", "Amiens","Rouen")

# Récupération des données par défaut (Paris)

# connexion à la base de données Mongo
mydatabase <- mongo ("Paris", url="mongodb://127.0.0.1:27017/AKZN")
# récupérer les données nécessaires
result <- mydatabase$find( '{}', fields='{"hourly_time": true,"hourly_pm2_5":true,"hourly_carbon_monoxide":true,"hourly_nitrogen_dioxide":true,"hourly_sulphur_dioxide":true,"hourly_ozone":true, "hourly_pm10" : true , "_id" : false }' )
units <- mydatabase$find('{}', fields='{"hourly_units_european_aqi":true ,"hourly_units_pm10":true, "hourly_units_pm2_5":true, "hourly_units_carbon_monoxide":true ,"hourly_units_nitrogen_dioxide":true, "hourly_units_sulphur_dioxide":true, "hourly_units_ozone":true,"_id" : false}', limit=1)
resultEAQI <- mydatabase$find('{}', fields='{"hourly_european_aqi":true, "_id" : false}')


# récupérer les données du jour
pm2_5 <- result$hourly_pm2_5[1:24]
#carbon monoxide
no <- result$hourly_carbon_monoxide[1:24]
#nitrogen dioxide
no2 <- result$hourly_nitrogen_dioxide[1:24]
#sulphur dioxide
so2 <- result$hourly_sulphur_dioxide[1:24]
#ozone
o3 <- result$hourly_ozone[1:24]

#################### end ########
body <-  dashboardBody(
  
  tabItems(
    tabItem(tabName = "dashboard",
            fluidPage(
              fluidRow(
                column(width = 4,
                       selectInput("select", label = h5("selectionnez une ville"), 
                                   choices = list("Paris" =2988507, "Strasbourg" =2973783, "Lille"=2998324,
                                                  "Marseille"=2995468, "Nice"=2990439,"Lyon"=2996943,
                                                  "Bordeaux"=3031582,"Toulouse"=2972315, "Rouen"=2982652,
                                                  "Le Havre"=3003796, "Angers"=3037656, "Brest"=6448047,
                                                  "Nîmes"=2990362, "Montpellier"=2992166, "Rennes"=2983989,
                                                  "Saint-Étienne"=2980288, "Dijon"=3021372, "Amiens"=3037854), 
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
    ## Horoscope ##
    tabItem(tabName = "secondsection",
            fluidRow(
              column(width = 2,
                     align = "center",
                     ##here the pickerInput starts
                     #selectInput("sign", "Select your sign", signs)
                     pickerInput("sign", "sign", 
                                 choices = signs,
                                 choicesOpt = list(
                                   content = mapply(signs, images_cute, FUN = function(si, im){
                                     (paste(
                                       img(src = im, width = 50, height = 40),
                                       toupper(si)
                                     ))
                                   }, SIMPLIFY = FALSE, USE.NAMES = FALSE )
                                 ), 
                                 width = 250
                     )
                     
                     ##here the pickerInput ends
              ),  #here ends the column
              
              
              column(
                width = 8,
                offset = 2,
                align = "center",
                box(
                  em(h3(textOutput("my_sign"))),
                  imageOutput("preImage", height = 250, width = 350  ),
                  background = "navy"
                ),
              )
              
              
            ),
            fluidRow(
              column(
                align = "center",
                width = 8,
                offset = 4,
                box( title = strong("Description"),
                     h3(textOutput("descr")), background = "navy", height = 225)
              )
            ),
            
            fluidRow(
              column(
                offset = 3,
                width = 3,
                infoBoxOutput("compatibility", width = 10),
                
              ),
              column(
                offset = 1,
                width = 3,
                infoBoxOutput("mood", width = 10)
              )
            ),
            
            fluidRow(
              column(
                offset  = 2,
                width = 3,
                valueBoxOutput("lucky_nb", width = 10)
              ),
              column(
                width = 3,
                infoBoxOutput("lucky_color", width = 10)
              ),
              column(
                width = 3,
                valueBoxOutput("lucky_time", width = 10)
              )
              
            )
            
    ),
    ## AirQuality ##
    tabItem(tabName = "thirdsection",
            fluidRow(
              column(1,NULL) ,
              column(12 ,box(background="blue", selectInput("town", "Choose a city :", townList),
                             textOutput("result")))
            ),
            
            
            h3(" Main polluants values for today "),
            br(),
            fluidRow(
              
              infoBoxOutput("PM10", width=4),
              infoBoxOutput("PM2_5", width=4),
              infoBoxOutput("NO2", width=4),
              infoBoxOutput("NO", width=4),
              infoBoxOutput("O3", width=4),
              infoBoxOutput("SO2", width=4)
            ),
            
            br(),
            br(),
            h3("LINE GRAPHS"),
            br(),
            
            fluidRow(
              column(1,NULL) ,
              column(10,box(background="blue", dateInput("date", "Choose a day , current day + (0, 4) days:", value = Sys.Date(), min=Sys.Date(), max=Sys.Date()+4 ))),
              
              
              
              
              
              textOutput("er")) ,
            
            fluidRow(
              column(1,NULL),
              column(10,box( title = "line Graph",background = "blue", solidHeader = TRUE,width=12,height=500,
                             box(width=12,plotlyOutput("plots"))),
                     
              ),
              column(1,NULL)),
            
            br(),
            br(),
            h3("Europen air quality index AQI "),
            br(),
            fluidRow(
              
              column(8, infoBoxOutput("eaqi", width=4)),
              #column(tags$img(src="aqi.png", height=230, width="100%", hspace="10")),
            ),
            fluidRow(
              column(width=7,
                     tags$h3(" How is the AQI calculated"),
                     tags$h4(width=5,"A pollutants index value is basically its concentration which is expressed in measuring units. The goal
                                 is to convert the pollutant concentration into a number between 0 and 500.  The AQIs of 0, 50, 100, 150...500
                                 is referred to as breakpoints.Each AQI breakpoint corresponds to a defined pollution concentration. Using the 
                                 breakpoint value of each pollutant and its ambient concentration the sub index value is calculated. The sub 
                                 index for a given pollutant is calculatedusing linear segmented principle. The overall AQI is expressed by the highest sub-index.")),
              column(5, tags$img(src="aqi.png", height=230, width="100%", hspace="10")),
            ),
            
            
            
    ), 
    tabItem(tabName = "fourthsection",
            fluidPage(
              h2("content is here")
            )
    )
    
    #second interface is here
    
  )
  
  
)
