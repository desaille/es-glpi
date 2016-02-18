#!/bin/bash

#########################################################
#		ES-GLPI - Sync Shell Script		#
#			   desaille.fr			#
#							#
# Full Path of es-glpi					#
# If you change this directory, you have to update it	#
# in the two es-glpi logstash config files		#
# (conf/logstash/*.conf)				#
DIR="/opt/es-glpi"					#
#							#
# Params for dynamic configuration			#
INDEX=(glpi_tickets glpi_tasks)				#
#							#
# ElasticSearch Host					#
ES=localhost:9200					#
#							#
# Colors						#
G="\033[32m"						#
W="\033[0m"						#
Y="\033[33m"						#
R="\033[31m"						#
#							#
#########################################################

for v in ${INDEX[@]}
  do
echo -e "${Y}####    Delete docs from index [${v}] in ElasticSearch:${W}"
/usr/bin/curl -XDELETE 'http://'${ES}'/'${v}'/_query' -d' { "query" : { "match_all": {} } }' &>${DIR}/logs/curl.log
if [ $? == 0 ]
  then
  echo -e "${G}==> OK${W}"
  else
  echo -e "${R}==> NOK - Check ${DIR}/logs/curl.log for more informations${W}"
fi
echo -e "${Y}####    Sync [${v}] data from MySQL:${W}"
/opt/logstash/bin/logstash agent --config ${DIR}/conf/logstash/${v}.conf &>${DIR}/logs/logstash.log
if [ $? == 0 ]
  then
  echo -e "${G}==> OK${W}"
  else
  echo -e "${R}==> NOK - Check ${DIR}/logs/logstash.log for more informations${W}"
fi
done
