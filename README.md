## Exécution de l'application web  ' Your Daily Dashboard '

## Environnement Ubuntu 
lors de l'instalation des packages R , nous avons recontré quelques soucis et apres nos recherches nous avons trouvé qu'il fallait  d'abord installer les packages ubuntu suivant :

```bash
sudo apt-get update

sudo add-apt-repository ppa:ubuntugis/ubuntugis-unstable  # si cette commande ne fonctionne pas parfaitement chez vous , ce n'est pas grave, veuillez poursuivre l'execution le reste des commandes
sudo apt-get install libudunits2-dev libgdal-dev libgeos-dev libproj-dev
sudo apt-get install libssl-dev libsasl2-dev
sudo apt-get install  build-essential

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
```bash
*/3 * * * * Rscript /home/hmel/Documents/Projet_lunux/Projet_météo/scripts_stockage_mongoDB/DB_currentWeather.R

0 * * * * Rscript /home/hmel/Documents/Projet_lunux/Projet_météo/scripts_stockage_mongoDB/DB_forcast.R

0 * * * * Rescript /home/hmel/Documents/Projet_lunux/Projet_météo/scripts_stockage_mongoDB/DB.airquality.R

0 1 * * * Rescript /home/hmel/Documents/Projet_lunux/Projet_météo/scripts_stockage_mongoDB/DB.horoscope.R

*/30 * * * * Rescript /home/hmel/Documents/Projet_lunux/Projet_météo/scripts_stockage_mongoDB/DB.bike.R
```


### Lancement de l'application web 
Ouvrir le script app.R, cliquez sur le button Run ou exécuter cette commande sur la console de R
```R

runApp()

```


[![Watch the video]()](https://mega.nz/file/ozgGiBRa#Uoc4-5hxSi35rzLEB-DVSx9-p6ZjfNunLkRb0XD9WzE)