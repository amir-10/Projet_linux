## Exécution de l'application web
Ouvrir le script app.R 
## Instalation des packages de R en tappont les commandes suivantes sur sa console
```R
Install.packages('shiny')
Install.packages('shinydashboard')
Install.packages('mongolite')
Install.packages('highcharter')
Install.packages('dplyr')
Install.packages('httr')
Install.packages('jsonlite')
Install.packages('leaflet')
Install.packages('shinyWidgets')
Install.packages('maps')
Install.packages('lubridate')
Install.packages('plotly')
```
## Exnvironnement Ubuntu 
L installation de packages R nécessite des packages ubuntu, qui ne sont pas installés directement avec R

```bash
sudo apt-get install  build-essential
sudo apt-get install gfortran
sudo apt-get install g77
sudo apt-get install tcl8.4-dev
sudo apt-get install libreadline5-dev

```

une fois les packages sont bien installes , cliquez sur le button Run ou executer cette comonde sur la console de R

```R

runApp()

```