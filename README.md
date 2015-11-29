# ES-GLPI
Module de synchro entre GLPI et ElasticSearch.

L'idée est de synchroniser des données depuis GLPI vers ElasticSearch afin de pouvoir faire des tableau de bords avec Kibana. 

### Fonctionnement : 
On utilise Logstash pour aller chercher les données dans le serveur MySQL hébergeant la base de donnée GLPI et les envoyer à ElasticSearch. 

### Description :

#####/es-glpi/bin/

config.sh :
  - Création automatique des index et des mappings dans ElasticSearch (suppression si existant)
  - Import des données depuis MySQL à l'aide de requêtes SQL prédéfinies et envoi dans ElasticSearch
  - Execution du script de synchronisation

sync.sh :
  - Suppression des données existantes dans les index prédéfinis
  - Import de toutes les données depuis la base MySQL

#####/es-glpi/conf/logstash/

Fichiers de configurations passés en paramètres à Logstash pour aller récupérer le contenu voulu de la base GLPI via les drivers JDBC. C'est dans ces fichiers que l'on paramètre l'utilisateur et le mot de passe de connexion à la base

#####/es-glpi/conf/sql/

Requêtes SQL permettant de récupérer le jeu de donner à injecter dans ElasticSearch

#####/es-glpi/conf/mappings/

Fichiers de mappings ElasticSearch en cohérence avec les données extraites de la base GLPI. 

## Prérequis : 
- ElasticSearch 2.x
- Plugin delete-by-query for ElasticSearch
- Logstash 2.x
- Plugin JDBC for Logstash
- JDBC Driver for MySQL

## Installation 
Testé sur Ubuntu 14.04 (containeur LXC)

- Installer ElasticSearch, Logstash et Kibana (https://www.elastic.co/downloads). Pleins de tutos sur le net pour s'en sortir.  
- Télécharger le Driver JDBC pour MySQL : http://dev.mysql.com/downloads/connector/j/
- Extraire le dossier et copier le fichier "mysql-connector-java-5.x.jar" dans "/opt/logstash/jdbc-drivers". 

Le répertoire jdbc-drivers est à créér, possibilité de stocker le driver a n'importe quel autre emplacement, mais dans ce cas penser a modifier les fichiers de configurations logstash "dans /es-glpi/conf/logstash" 

- Installer le plugin delete-by-query pour ES (https://www.elastic.co/blog/core-delete-by-query-is-a-plugin)
/usr/share/elasticsearch/bin/plugin install delete-by-query
- Installer le plugin logstash-input-jdbc (https://www.elastic.co/guide/en/logstash/current/plugins-inputs-jdbc.html)
/opt/logstash/bin/plugin install logstash-input-jdbc




