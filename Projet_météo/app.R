## app.R ##
library(shiny)
library(shinydashboard)
library(mongolite)
require(highcharter)
library(dplyr)
library(httr)
library(jsonlite)
library(leaflet)
library(shinyWidgets)
library(maps)
library("lubridate")  
library(plotly)
source('./Ui moduls/header.R')
source('./Ui moduls/sidebar.R')
source('./Ui moduls/body.R')
source('./Server moduls/weather_server.R')
source('./Server moduls/horoscope_server.R')
source('./Server moduls/airquality_server.R')
source('./Server moduls/Bike_server.R')




ui <- dashboardPage(
  dashboardheader,
  sidebar,
  body
  
  
)



server <- function(input, output, session) {
  weather_server(input,output,session)
  horoscope_server(input,output)
  airquality_server(input,output)
  Bike_server(input,output,session)
  
  
}

shinyApp(ui, server)