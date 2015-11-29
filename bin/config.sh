#!/bin/bash

#########################################################
#               ES-GLPI - Config Shell Script           #
#                       by desaille.fr                  #
#                                                       #
# Full Path of es-glpi                                  #
# If you change this directory, you have to update it   #
# in the two es-glpi logstash config files              #
# =>  conf/logstash/*.conf                              #
DIR="/opt/es-glpi"                                      #
#                                                       #
# Params for dynamic configuration                      #
INDEX=(glpi_tickets glpi_tasks)                         #
#                                                       #
# ElasticSearch Host                                    #
ES=localhost:9200                                       #
#          						#
# Kibana Version                                        #
KIB="4.3.0"						#
#							#
# Colors                                                #
G="\033[32m"                                            #
W="\033[0m"                                             #
Y="\033[33m"                                            #
R="\033[31m"                                            #
#                                                       #
#########################################################

echo -e "${Y} _____ ____         ____ _     ____ ___ "
echo "| ____/ ___|       / ___| |   |  _ \_ _|"
echo "|  _| \___ \ _____| |  _| |   | |_) | | "
echo "| |___ ___) |_____| |_| | |___|  __/| | "
echo "|_____|____/       \____|_____|_|  |___|"
echo " "
echo -e "${W}[Sync config script between GLPI and ElasticSearch from desaille.fr]${W}"
echo " "
for v in ${INDEX[@]}
  do
  echo -e "${Y}####    Put index [${v}] in ElasticSearch (delete if already exists):${W}"
  /usr/bin/curl -XDELETE ''${ES}'/'${v}'' &>/dev/null
  /usr/bin/curl -XPUT ''${ES}'/'${v}'' &>${DIR}/logs/curl.log
if [ $? == 0 ]
  then
  echo -e "${G}==> OK${W}"
  else
  echo -e "${R}==> NOK - Check ${DIR}/logs/curl.log for more informations${W}"
fi
  echo -e "${Y}####    Puts [${v}] mappings in ElasticSearch:${W}"
  /usr/bin/curl -XPUT ''${ES}'/'${v}'/'${v}'/_mapping' -d @${DIR}/conf/mappings/${v}.json &>${DIR}/logs/curl.log
if [ $? == 0 ]
  then
  echo -e "${G}==> OK${W}"
  else
  echo -e "${R}==> NOK - Check ${DIR}/logs/curl.log for more informations${W}"
fi
   echo -e "${Y}####    Puts [${v}] indices to Kibana config:${W}"
  /usr/bin/curl -XPUT ''${ES}'/.kibana/index-pattern/'${v}'' -d '{"title" : "${v}",  "timeFieldName": "date"}' &>${DIR}/logs/curl.log
if [ $? == 0 ]
  then
  echo -e "${G}==> OK${W}"
  else
  echo -e "${R}==> NOK - Check ${DIR}/logs/curl.log for more informations${W}"
fi
done

echo -e "${Y}####    Puts default index to Kibana config${W}"
/usr/bin/curl -XPUT ''${ES}'/.kibana/config/'${KIB}'' -d '{"defaultIndex" : "glpi_tickets"}' &>${DIR}/logs/curl.log
if [ $? == 0 ]
  then
  echo -e "${G}==> OK${W}"
  else
  echo -e "${R}==> NOK - Check ${DIR}/logs/curl.log for more informations${W}"
fi

${DIR}/bin/sync.sh

echo ""
echo -e "If you need to schedule sync, please add a line to your crontab like below. In this example i do a full reimport every 15min."
echo ""
echo -e "*/15 * * * * ${DIR}/bin/sync.sh &>/dev/null"
echo ""
echo -e "[More information on desaille.fr]"
echo ""
