weather_server <- function(input,output,session) {
#owmr_settings(Sys.getenv("OWM_API_KEY"))

#current weather
data_current <- reactive({
  id <- strtoi(input$select)
  weatherCollection = mongo(collection = "CWeather", db = "AKZN") 
  data=weatherCollection$find(
    query = paste0('
        { 
          "id": ',id,'
      }')
  )
  
  #res = GET(paste0("https://api.openweathermap.org/data/2.5/weather?id=",id,"&APPID=af2f6b280ae76a3d215f081e0c014235"))
  #print(res$content)
  #data = fromJSON(rawToChar(res$content))
  #get_current(id, units = "metric")
  
})
# weather forcast
data_forecast <- reactive({
  id <- strtoi(input$select)
  #res = GET(paste0("https://api.openweathermap.org/data/2.5/forecast?id=",id,"&APPID=af2f6b280ae76a3d215f081e0c014235"))
  #print(res$content)
  #data = fromJSON(rawToChar(res$content))
  #get_forecast(id,units = "metric")
  forcastCollection = mongo(collection = "forcast", db = "AKZN")  
  data=forcastCollection$find(
    query = paste0('
          { 
            "city.id": ',id,'
        }')
  )
  
  
})





# map leaflet

output$map <- renderLeaflet({
  invalidateLater(60000, session)
  
  
  weather <- data_current()
  #print("count", weather)
  
  weatherIcon= makeIcon(iconUrl=paste0(weather$weather[4]$icon,".svg"),iconWidth=40,iconHeight=40)
  
  leaflet(options = leafletOptions(zoomControl = FALSE)) %>%
    htmlwidgets::onRender("function(el, x) {
        L.control.zoom({ position: 'topright' }).addTo(this)
    }")%>%
  
    addProviderTiles(providers$Stamen.TonerLite,
                     options = providerTileOptions(noWrap = TRUE)
    ) %>%
    setView(lat =weather$coord$lat, lng =weather$coord$lon, zoom = 6)%>%
    addMarkers(lat =weather$coord$lat, 
               lng =weather$coord$lon,
               icon =weatherIcon,
               popup = paste(
                 "<b>City: </b>",paste0(weather$name), "<br>",
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
  invalidateLater(60000, session)
  weather <- data_current()
  #print(weather$main$temp)
  infoBox(
    "Temperature", paste0(format(weather$main$temp-273.15, digits = 2), " °C"), icon = icon("temperature-low", lib = "font-awesome"),
    color = "yellow"
  )
})
output$weatherMainBox <- renderInfoBox({
  invalidateLater(60000, session)
  weather <- data_current()
  infoBox(
    "Weather main", paste0(weather$weather[3]$description),icon = icon("sun", lib = "font-awesome"),
    color = "red",
    
  )
})
output$feelTempBox <- renderInfoBox({
  invalidateLater(60000, session)
  weather <- data_current()
  infoBox(
    "Visibility ", paste0(format(weather$visibility/1000), " Km"), icon = icon("eye", lib = "font-awesome"),
    color = "blue"
  )
})


# Same as above, but with fill=TRUE
output$pressureBox <- renderInfoBox({
  invalidateLater(60000, session)
  weather <- data_current()
  infoBox(
    "Pressure", paste0(weather$main$pressure, " hpa"), icon = icon("area-chart"),
    color = "purple", fill = TRUE
  )
})
output$humidityBox <- renderInfoBox({
  invalidateLater(60000, session)
  weather <- data_current()
  infoBox(
    "Humidity", paste0(weather$main$humidity, " %"), icon = icon("droplet", lib = "font-awesome"),
    color = "red", fill = TRUE
  )
})
output$windBox <- renderInfoBox({
  invalidateLater(60000, session)
  weather <- data_current()
  infoBox(
    "Wind", paste0(weather$wind$speed, " Km/h"), icon = icon("wind", lib = "font-awesome"),
    color = "green", fill = TRUE
  )
})

# les graphes
output$hcontainer <- renderHighchart({
  invalidateLater(60000, session)
  weather_forecast_data <- data.frame(data_forecast()$list)
  
  data_forecast <- as_tibble(weather_forecast_data)
  # View(data_forecast$dt_txt)
  
  #weather_forecast$new_date <- ymd_hms(weather_forecast$dt_txt)
  date <- (as_tibble(data_forecast)$dt_txt)
  #print(date)
  #format(weather$main$temp-273.15, digits = 2)
  température  <- as_tibble(data_forecast)$main$temp-273.15
  
  
  températureMin  <-  as_tibble(data_forecast)$main$temp_min-273.15
  températureMax  <- as_tibble(data_forecast)$main$temp_max-273.15
  d <- data.frame(date,température,températureMin,températureMax)
  #print(d)
  highchart() %>%
    hc_xAxis(categories =date) %>% 
    hc_add_series(name = "Temperature", data = température ) |> 
    hc_add_series(name = "Minimal temperature", data= températureMax ) |>
    hc_add_series(name = "Maximal temperature", data = températureMin ) |>
    hc_exporting(enabled = TRUE) %>% 
    hc_tooltip(crosshairs = TRUE, backgroundColor = "#FCFFC5",
               shared = TRUE, borderWidth = 2) %>%
    hc_title(text="Hourly weather forecast °C ",align="center") %>%
    
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





