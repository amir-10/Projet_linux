## app.R ##
library(shiny)
library(shinydashboard)
library(mongolite)
require(highcharter)
library(dplyr)
library(httr)
library(jsonlite)
library(leaflet)
source('./Ui moduls/header.R')
source('./Ui moduls/sidebar.R')
source('./Ui moduls/body.R')
source('./Server moduls/weather_server.R')

ui <- dashboardPage(
  dashboardheader,
  sidebar,
  body
  
  
)



server <- function(input, output, session) {
  weather_server(input,output,session)

  
}

shinyApp(ui, server)