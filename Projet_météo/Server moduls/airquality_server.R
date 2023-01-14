airquality_server <- function(input, output,session){
  
  # Pour mettre à jour
  observe ({
    invalidateLater(3600000, session)
    
    # récupérer la date sélectionnée par l'utilisateur
    xx <- as.Date(input$date)
    ss <- xx - Sys.Date()
     
    dd <- as.integer(ss)
    limitLeft <- 1 + 24*dd
    limitRight <- 24 + 24*dd
    
    
    
    # connexion à mongoDB et récupérer les données de la ville sélectionnée
    
    mydata <- mongo ( collection = "AirQuality", url="mongodb://127.0.0.1:27017/AKZN")
    
    # ville sélectionnée ==input$town, par défaut c'est Paris
    
    ville <- input$town
    #requête
    mongo_string = paste0('{\"ville": \"',ville, '\"}')
    
    result <- mydata$find( mongo_string )
    
      
    
    #Récupérer les valeurs des polluants correspondant à la date et la ville sélectionnée par l'utilisateur
    
    #pm10
    pm10<- unlist(result$hourly$pm10)[limitLeft: limitRight]
    
    #pm2_5
    pm2_5<- unlist(result$hourly$pm2_5)[limitLeft: limitRight]
    
    #carbon monoxide
    no<- unlist(result$hourly$carbon_monoxide)[limitLeft: limitRight]
   
    #nitrogen dioxide
    no2<- unlist(result$hourly$nitrogen_dioxide)[limitLeft: limitRight]
    
    #sulphur dioxide
    so2<- unlist(result$hourly$sulphur_dioxide)[limitLeft: limitRight]
   
    #ozone
    o3<- unlist(result$hourly$ozone)[limitLeft: limitRight]
    
    
    
    y <-reactive({
      pm10
    })
    
    y1 <- reactive({
      no2
    })
    y2 <- reactive({
      o3
    })
    y3 <- reactive({
      no
    })
    y4 <- reactive({
      pm2_5
    })
    y5 <- reactive({
      so2
    })
    
    
    currenthour <-hour(Sys.time())
   
    if (currenthour == 0)
    { currenthour <- currenthour+1}
    heures <- 0:23
    x <- reactive({
      heures
    })
    
    
    
    
    output$plots <- renderPlotly({
      print("zahrat el kassr")
       
      #print(pm10)
      plot_ly(
        
        x = x(),
        y = y(), 
        type = 'scatter',
        mode = 'lines+markers',
        name=paste("PM10", "per", result$hourly_units$pm10 ),
        hovertemplate = paste('<i><b>Value</b></i>: %{y:.2f}',
                              '<br>',
                              '<i><b>Polluant</b></i>: PM10 ',
                              '<br><b>Time hour</b>: %{x}<b>h</b><br>'),
        showlegend = TRUE)%>%
        layout(title=paste("Polluants line chart " , input$town), xaxis = list(title = 'hours'), yaxis = list(title = paste('polluant per unit', input$date,  sep="      ") , legend = list(title=list(text='plluants names ')))) %>%
        
        
        add_trace(
          x = x(),
          y = y1(), 
          type = 'scatter',
          mode = 'lines+markers',
          name=paste("NO2", "per", result$hourly_units$nitrogen_dioxide),
          hovertemplate = paste('<i><b>Value</b></i>: %{y:.2f}',
                                '<br>',
                                '<i><b>Polluant</b></i>: NO2 ',
                                '<br><b>Time hour</b>: %{x}<b>h</b><br>'),
          showlegend = TRUE
        )%>%
        add_trace(
          x = x(),
          y = y2(), 
          type = 'scatter',
          mode = 'lines+markers',
          name=paste("O3", "per", result$hourly_units$ozone),
          hovertemplate = paste('<i><b>Value</b></i>: %{y:.2f}',
                                '<br>',
                               '<i><b>Polluant</b></i>: O3 ',
                               '<br><b>Time hour</b>: %{x}<b>h</b><br>'),
          showlegend = TRUE)%>%
        add_trace(
          x = x(),
          y = y3(), 
          type = 'scatter',
          mode = 'lines+markers',
          name=paste("NO", "per", result$hourly_units$carbon_monoxide),
          hovertemplate = paste('<i><b>Value</b></i>: %{y:.2f}',
                                '<br>',
                                '<i><b>Polluant</b></i>: NO ',
                                '<br><b>Time hour</b>: %{x}<b>h</b><br>'),
          showlegend = TRUE)%>%
        add_trace(
          x = x(),
          y = y4(), 
          type = 'scatter',
          mode = 'lines+markers',
          name=paste("PM2_5", "per", result$hourly_units$pm2_5), 
          hovertemplate = paste('<i><b>Value</b></i>: %{y:.2f}',
                              '<br>',
                              '<i><b>Polluant</b></i>: PM2_5 ',
                              '<br><b>Time hour</b>: %{x}<b>h</b><br>'),
          showlegend = TRUE)%>%
        add_trace(
          
          x = x(),
          y = y5(), 
          type = 'scatter',
          mode = 'lines+markers',
          name=paste("SO2", "per",result$hourly_units$sulphur_dioxide),
          hovertemplate = paste('<i><b>Value</b></i>: %{y:.2f}',
                                '<br>',
                               '<i><b>Polluant</b></i>: SO2 ',
                              '<br><b>Time hour</b>: %{x}<b>h</b><br>'),
          showlegend = TRUE) 
      
    })
    
    
    
    output$PM10 <- renderInfoBox({
      
      
      infoBox(
        "PM10", paste(pm10[currenthour ],result$hourly_units$pm10),
        color = "purple", fill = TRUE,icon = icon("smog")
      )
    })
    output$PM2_5 <- renderInfoBox({
       
      infoBox(
        "PM2_5",paste( pm2_5[currenthour], result$hourly_units$pm2_5),
        color = "yellow", fill = TRUE,icon = icon("smog"))
    })
    
    
    
    output$NO2 <- renderInfoBox({
      
      
      infoBox(
        "NO2", paste(no2[currenthour],result$hourly_units$nitrogen_dioxide),
        color = "blue", fill = TRUE,icon = icon("smog"))
    })
    output$eaqi <- renderInfoBox({
     
      infoBox(
        "EAQI",unlist(result$hourly$european_aqi)[currenthour],
        color = "blue", fill = TRUE,icon = icon("wind"))
    })
    
    output$NO <- renderInfoBox({
      infoBox(
        "NO",
        paste( no[currenthour],result$hourly_units$carbon_monoxide),
        color = "green", fill = TRUE,icon = icon("smog"))
    })
    
    output$O3 <- renderInfoBox({
      infoBox(
        "O3", paste(o3[currenthour],result$hourly_units$ozone),
        color = "orange", fill = TRUE,icon = icon("smog"))
    })
    
    output$SO2 <- renderInfoBox({
      infoBox(
        "SO2", paste( so2[currenthour],result$hourly_units$sulphur_dioxide),
        color = "purple", fill = TRUE,icon = icon("smog"))
    })
    
    
    
    
  })
  
  
  
  
  
  
  
}