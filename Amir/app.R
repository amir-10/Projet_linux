## app.R ##
library(shiny)
library(shinydashboard)
library(owmr)
require(highcharter)
library(dplyr)
library(httr)
library(jsonlite)
library(leaflet)

ui <- dashboardPage(
  dashboardHeader(title = "Paris's weather"
  ),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
      menuItem("second part", tabName = "secondpart", icon = icon("th"))
      
    )
  ),
  dashboardBody(
    
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
      tabItem(tabName = "secondpart",
              fluidPage(
                h2("content is here")
              )
      )
      #second interface is here
      
    )
    
    
  )
  
  
)



server <- function(input, output, session) {
  
  
  #owmr_settings(Sys.getenv("OWM_API_KEY"))
  
  #current weather
  data_current <- reactive({
    id <- strtoi(input$select)
    res = GET(paste0("https://api.openweathermap.org/data/2.5/weather?id=",id,"&APPID=af2f6b280ae76a3d215f081e0c014235"))
    #print(res$content)
    data = fromJSON(rawToChar(res$content))
    #get_current(id, units = "metric")
    
  })
  # weather forcast
  data_forecast <- reactive({
    id <- strtoi(input$select)
    res = GET(paste0("https://api.openweathermap.org/data/2.5/forecast?id=",id,"&APPID=af2f6b280ae76a3d215f081e0c014235"))
    #print(res$content)
    data = fromJSON(rawToChar(res$content))
    #get_forecast(id,units = "metric")
  })
  
  
  
  
  
  # map leaflet
  
  output$map <- renderLeaflet({
    weather <- data_current()
    weatherIcon= makeIcon(iconUrl=paste0(weather$weather[4]$icon,".svg"),iconWidth=40,iconHeight=40)
    
    leaflet() %>%
      addProviderTiles(providers$Stamen.TonerLite,
                       options = providerTileOptions(noWrap = TRUE)
      ) %>%
      setView(lat =weather$coord$lat, lng =weather$coord$lon, zoom = 6)%>%
      addMarkers(lat =weather$coord$lat, 
                 lng =weather$coord$lon,
                 icon =weatherIcon,
                 popup = paste(
                   "<b>Ville: </b>",paste0(weather$name), "<br>",
                   "<b>Weather: </b>",paste0(weather$weather[3]$description),"<br>",
                   "<b>Temperature: </b>",paste0(format(weather$main$temp-273.15, digits = 2), " C","<br>",
                                                 "<b>Wind Speed: </b>",paste0(weather$wind$speed), " km/h","<br>",
                                                 "<b>Sunrise: </b>", as.POSIXct(weather$sys$sunrise, origin="1970-01-01"),"<br>",
                                                 "<b>Sunset: </b>",as.POSIXct(weather$sys$sunset, origin="1970-01-01"),"<br>",
                                                 sep=""))
      )
    
    
  })
  #les infobox(cards)
  output$tempBox <- renderInfoBox({
    weather <- data_current()
    infoBox(
      "Temperature", paste0(format(weather$main$temp-273.15, digits = 2), " °C"), icon = icon("temperature-low", lib = "font-awesome"),
      color = "yellow"
    )
  })
  output$weatherMainBox <- renderInfoBox({
    weather <- data_current()
    infoBox(
      "Weather main", paste0(weather$weather[3]$description),icon = icon("sun", lib = "font-awesome"),
      color = "red"
    )
  })
  output$feelTempBox <- renderInfoBox({
    weather <- data_current()
    infoBox(
      "Visibilité ", paste0(format(weather$visibility/1000), "Km"), icon = icon("eye", lib = "font-awesome"),
      color = "blue"
    )
  })
  
  
  # Same as above, but with fill=TRUE
  output$pressureBox <- renderInfoBox({
    weather <- data_current()
    infoBox(
      "Pression", paste0(weather$main$pressure, " hpa"), icon = icon("area-chart"),
      color = "purple", fill = TRUE
    )
  })
  output$humidityBox <- renderInfoBox({
    weather <- data_current()
    infoBox(
      "Humidity", paste0(weather$main$humidity, " %"), icon = icon("droplet", lib = "font-awesome"),
      color = "red", fill = TRUE
    )
  })
  output$windBox <- renderInfoBox({
    weather <- data_current()
    infoBox(
      "Vent", paste0(weather$wind$speed, " Km/h"), icon = icon("wind", lib = "font-awesome"),
      color = "green", fill = TRUE
    )
  })
  
  # les graphes
  output$hcontainer <- renderHighchart({
    weather_forecast_data <- data_forecast()
    weather_forecast <- as_tibble(weather_forecast_data$list)
    #weather_forecast$new_date <- ymd_hms(weather_forecast$dt_txt)
    date <- (as_tibble(data_forecast()$list)$dt_txt)
    #format(weather$main$temp-273.15, digits = 2)
    température  <- as_tibble(data_forecast()$list)$main$temp-273.15
    
    
    températureMin  <-  as_tibble(data_forecast()$list)$main$temp_min-273.15
    températureMax  <- as_tibble(data_forecast()$list)$main$temp_max-273.15
    d <- data.frame(date,température,températureMin,températureMax)
    #print(d)
    highchart() %>%
      hc_xAxis(categories =date) %>% 
      hc_add_series(name = "Température", data = température ) |> 
      hc_add_series(name = "Température minimal", data= températureMax ) |>
      hc_add_series(name = "Température maximal", data = températureMin ) |>
      hc_exporting(enabled = TRUE) %>% 
      hc_tooltip(crosshairs = TRUE, backgroundColor = "#FCFFC5",
                 shared = TRUE, borderWidth = 2) %>%
      hc_title(text="Prévision horaire de température °C ",align="center") %>%
      
      hc_add_theme(hc_theme_elementary())%>%
      hc_legend(
        align = "left",
        verticalAlign = "top",
        layout = "vertical",
        x = 0,
        y = 100
      ) 
    
    
    
  })
  
  
  
  
  
  
  
}

shinyApp(ui, server)