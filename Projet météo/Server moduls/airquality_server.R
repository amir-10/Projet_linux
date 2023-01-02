airquality_server <- function(input, output){
  pm10 <- result$hourly_pm10[1:24]
  output$result <- renderText({
    #= print( input$town)
    
    
    
  })
  
  
  # Pour mettre à jour
  observe ({
    
    xx <- as.Date(input$date)
    ss <- xx - Sys.Date()
    dd <- as.integer(ss)
    
    # connexion à mongoDB et récupérer les données de la ville sélectionnée
    mydata <- mongo (input$town , url="mongodb://127.0.0.1:27017/AKZN")
    
    result <- mydata$find( '{}', fields='{"hourly_time": true,"hourly_pm2_5":true,"hourly_carbon_monoxide":true,"hourly_nitrogen_dioxide":true,"hourly_sulphur_dioxide":true,"hourly_ozone":true, "hourly_pm10" : true , "_id" : false }' )
    
    units <- mydata$find('{}', fields='{"hourly_units_european_aqi":true ,"hourly_units_pm10":true, "hourly_units_pm2_5":true, "hourly_units_carbon_monoxide":true ,"hourly_units_nitrogen_dioxide":true, "hourly_units_sulphur_dioxide":true, "hourly_units_ozone":true,"_id" : false}', limit=1)
    resultEAQI <- mydata$find('{}', fields='{"hourly_european_aqi":true, "_id" : false}')
    
    limitLeft <- 1 + 24*dd
    limitRight <- 24 + 24*dd
    pm10<- result$hourly_pm10[limitLeft: limitRight]
    
    pm2_5 <- result$hourly_pm2_5[limitLeft:limitRight]
    #carbon monoxide
    no <- result$hourly_carbon_monoxide[limitLeft:limitRight]
    #nitrogen dioxide
    no2 <- result$hourly_nitrogen_dioxide[limitLeft:limitRight]
    #sulphur dioxide
    so2 <- result$hourly_sulphur_dioxide[limitLeft:limitRight]
    #ozone
    o3 <- result$hourly_ozone[limitLeft:limitRight]
    
    
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
      #print(pm10)
      plot_ly(
        
        x = x(),
        y = y(), 
        type = 'scatter',
        mode = 'lines+markers',
        name=paste("PM10", "per", units$hourly_units_nitrogen_dioxide ),
        hovertemplate = paste('<i><b>Value</b></i>: %{y:.2f}',
                              '<br>',
                              '<i><b>Name</b></i>: PM10 ',
                              '<br><b>Time hour</b>: %{x}<b>h</b><br>'),
        showlegend = TRUE)%>%
        layout(title=paste("Polluants line chart " , input$town), xaxis = list(title = 'hours'), yaxis = list(title = paste('polluant per unit', input$date,  sep="      ") , legend = list(title=list(text='plluants names ')))) %>%
        
        
        add_trace(
          x = x(),
          y = y1(), 
          type = 'scatter',
          mode = 'lines+markers',
          name=paste("NO2", "per", units$hourly_units_nitrogen_dioxide),
          hovertemplate = paste('<i><b>Value</b></i>: %{y:.2f}',
                                '<br>',
                                '<i><b>Name</b></i>: NO2 ',
                                '<br><b>Time hour</b>: %{x}<b>h</b><br>'),
          showlegend = TRUE
        )%>%
        add_trace(
          x = x(),
          y = y2(), 
          type = 'scatter',
          mode = 'lines+markers',
          name=paste("O3", "per", units$hourly_units_ozone), hovertemplate = paste('<i><b>Value</b></i>: %{y:.2f}',
                                                                                   '<br>',
                                                                                   '<i><b>Name</b></i>: O3 ',
                                                                                   '<br><b>Time hour</b>: %{x}<b>h</b><br>'),
          showlegend = TRUE)%>%
        add_trace(
          x = x(),
          y = y3(), 
          type = 'scatter',
          mode = 'lines+markers',
          name=paste("NO", "per", units$hourly_units_carbon_monoxide), hovertemplate = paste('<i><b>Value</b></i>: %{y:.2f}',
                                                                                             '<br>',
                                                                                             '<i><b>Name</b></i>: NO ',
                                                                                             '<br><b>Time hour</b>: %{x}<b>h</b><br>'),
          showlegend = TRUE)%>%
        add_trace(
          x = x(),
          y = y4(), 
          type = 'scatter',
          mode = 'lines+markers',
          name=paste("PM2_5", "per", units$hourly_units_pm2_5), hovertemplate = paste('<i><b>Value</b></i>: %{y:.2f}',
                                                                                      '<br>',
                                                                                      '<i><b>Name</b></i>: PM2_5 ',
                                                                                      '<br><b>Time hour</b>: %{x}<b>h</b><br>'),
          showlegend = TRUE)%>%
        add_trace(
          
          x = x(),
          y = y5(), 
          type = 'scatter',
          mode = 'lines+markers',
          name=paste("SO2", "per", units$hourly_units_sulphur_dioxide), hovertemplate = paste('<i><b>Value</b></i>: %{y:.2f}',
                                                                                              '<br>',
                                                                                              '<i><b>Name</b></i>: SO2 ',
                                                                                              '<br><b>Time hour</b>: %{x}<b>h</b><br>'),
          showlegend = TRUE) 
      
    })
    
    
    
    output$PM10 <- renderInfoBox({
      
      infoBox(
        "PM10", paste(pm10[currenthour ],units$hourly_units_pm10),
        color = "purple", fill = TRUE,icon = icon("smog")
      )
    })
    output$PM2_5 <- renderInfoBox({
      infoBox(
        "PM2_5",paste( pm2_5[currenthour], units$hourly_units_pm2_5),
        color = "yellow", fill = TRUE,icon = icon("smog"))
    })
    
    
    
    output$NO2 <- renderInfoBox({
      
      infoBox(
        "NO2", paste(no2[currenthour],units$hourly_units_nitrogen_dioxide),
        color = "blue", fill = TRUE,icon = icon("smog"))
    })
    output$eaqi <- renderInfoBox({
      infoBox(
        "EAQI",resultEAQI$hourly_european_aqi[currenthour],
        color = "blue", fill = TRUE,icon = icon("wind"))
    })
    
    output$NO <- renderInfoBox({
      infoBox(
        "NO",
        paste( no[currenthour],units$hourly_units_carbon_monoxide),
        color = "green", fill = TRUE,icon = icon("smog"))
    })
    
    output$O3 <- renderInfoBox({
      infoBox(
        "O3", paste(o3[currenthour],units$hourly_units_ozone),
        color = "orange", fill = TRUE,icon = icon("smog"))
    })
    
    output$SO2 <- renderInfoBox({
      infoBox(
        "SO2", paste( so2[currenthour],units$hourly_units_sulphur_dioxide ),
        color = "purple", fill = TRUE,icon = icon("smog"))
    })
    
    
    
    
  })
  
  
  
  
  
  
  
}