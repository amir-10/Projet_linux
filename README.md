## Exécution de l'application web

## Environnement Ubuntu 
L'installation de packages R nécessite des packages ubuntu, qui ne sont pas installés directement avec R

```bash
sudo apt-get install  build-essential
sudo apt-get install gfortran
sudo apt-get install g77
sudo apt-get install tcl8.4-dev
sudo apt-get install libreadline5-dev
```
## Instalation des packages de R en executant le script suivant
install_packages.R

## Création de la BDD
Pour le premier lancement il faut exécuter les scripts afin de créer et remplir la BDD nommée AKZN, et par la suite CRON s'occupe de la mettre à jour .
### les scripts a executer 
scripts_stockage_mongoDB/DB_airquality.\
scripts_stockage_mongoDB/DB_currentWeather.\
scripts_stockage_mongoDB/DB_forcast.\
scripts_stockage_mongoDB/DB_horoscope.\
scripts_stockage_mongoDB/DB_bike.
### les commandes CRON:


### Lancement de l'application web 
Ouvrir le script app.R, cliquez sur le button Run ou exécuter cette commande sur la console de R
```R

runApp()

```
