## Exécution de l'application web
Ouvrir le script app.R 
## Instalation des packages de R en tappont les commandes suivantes sur sa console
```R
install.packages('shiny')
install.packages('shinydashboard')
install.packages('mongolite')
install.packages('highcharter')
install.packages('dplyr')
install.packages('httr')
install.packages('jsonlite')
install.packages('leaflet')
install.packages('shinyWidgets')
install.packages('maps')
install.packages('lubridate')
install.packages('plotly')
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
