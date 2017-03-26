#!/bin/bash

while getopts "p:" opt; do
    case $opt in
        p)
            serviceport=$OPTARG
            echo "[+]Service port: $serviceport"
            ;;
        \?)  
            echo "[+]Invalid option: -$OPTARG.Use -p (PORT) -n (NAME)."   
            ;;  
    esac
done

#curl -sSL https://get.daocloud.io/daotools/set_mirror.sh | sh -s http://d5219f42.m.daocloud.io
#systemctl restart docker.service
#sleep 20s

sudo docker run --name FHIR-postgreSQL -p 5432:5432 -d postgres

sleep 30s
echo 'wake'
sudo docker exec -it FHIR-postgreSQL psql -U postgres --command "create user hapi with password 'p@ssw0rd';"

sudo docker exec -it FHIR-postgreSQL psql -U postgres --command "create database hapi owner hapi;"

sudo docker exec -it FHIR-postgreSQL psql -U postgres --command "grant all privileges on database hapi to hapi;"
echo '[+]postgreSQL configure success!'

mvn package #&& \
docker build -t hapi-fhir/hapi-fhir-jpaserver-example-postgres .

sudo docker run --link FHIR-postgreSQL:postgres -d -p $serviceport:8080 hapi-fhir/hapi-fhir-jpaserver-example-postgres


