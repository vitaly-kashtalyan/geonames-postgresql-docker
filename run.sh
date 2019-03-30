#!/usr/bin/env bash

docker stop $(docker-compose ps -q geonames_db) && docker rm $(docker-compose ps -q geonames_db)
docker-compose up -d

wget -c http://download.geonames.org/export/dump/countryInfo.txt -O countryInfo.txt
sed '/^#/ d' < countryInfo.txt > country.txt
wget -c http://download.geonames.org/export/dump/allCountries.zip -O allCountries.zip
unzip -o allCountries.zip

docker container exec -i $(docker-compose ps -q geonames_db) psql -U db_user db_name < schemas.sql

docker cp country.txt $(docker-compose ps -q geonames_db):/tmp/country.txt
docker container exec -i $(docker-compose ps -q geonames_db) psql -U db_user db_name -c "copy countryinfo (iso_alpha2,iso_alpha3,iso_numeric,fips_code,country,capital,areainsqkm,population,continent,tld,currency_code,currency_name,phone,postal,postalRegex,languages,geonameId,neighbours,equivalent_fips_code) from '/tmp/country.txt' null as '';"

docker cp allCountries.txt $(docker-compose ps -q geonames_db):/tmp/allCountries.txt
docker container exec -i $(docker-compose ps -q geonames_db) psql -U db_user db_name -c "copy geoname (geonameid,name,asciiname,alternatenames,latitude,longitude,fclass,fcode,country,cc2,admin1,admin2,admin3,admin4,population,elevation,gtopo30,timezone,moddate) from '/tmp/allCountries.txt' null as '';"

docker container exec -it $(docker-compose ps -q geonames_db) sh -c 'rm -rf /tmp/*.txt'
docker container exec -i $(docker-compose ps -q geonames_db) psql -U db_user db_name < preparation.sql

docker container exec -i $(docker-compose ps -q geonames_db) pg_dump -U db_user -d db_name -t cities -t regions -t countries > dump.sql
