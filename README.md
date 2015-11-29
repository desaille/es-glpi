# Es-GLPI
Module de synchro entre GLPI et ElasticSearch.

L'idée est de synchroniser des données depuis GLPI vers ElasticSearch afin de pouvoir faire des tableau de bords avec Kibana. 

### Fonctionnement : 
On utilise Logstash pour aller chercher les données dans le serveur MySQL hébergeant la base de donnée GLPI et les envoyer à ElasticSearch. 

### Description :

/es-glpi/bin 

config.sh :
  - Création automatique des index et des mappings dans ElasticSearch (suppression si existant)
  - Import des données depuis MySQL à l'aide de requêtes SQL prédéfinies et envoi dans ElasticSearch
  - Execution du script de synchronisation

sync.sh :
  - Suppression des données existantes dans les index prédéfinis
  - Import de toutes les données depuis la base MySQL
