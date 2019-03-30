-- countries
DROP TABLE IF EXISTS countries;
CREATE TABLE countries
(
  id         serial not null
    constraint countries_pkey primary key,

  geoname_id int,
  iso        char(2),
  country    character varying(50),
  capital    character varying(50),
  created_at timestamp,
  updated_at timestamp,
  deleted_at timestamp
);
create index idx_countries_deleted_at
  on countries (deleted_at);

insert into countries(geoname_id, iso, country, capital, created_at, updated_at
)
select geonameId, iso_alpha2, country, capital, NOW(), NOW()
from countryinfo;

-- regions
DROP TABLE IF EXISTS regions;
CREATE TABLE regions
(
  id         serial not null
    constraint regions_pkey primary key,

  country_id int,
  geoname_id int,
  name       varchar(200),
  ascii_name varchar(200),
  adm        varchar(20),
  country    char(2),
  latitude   float,
  longitude  float,
  created_at timestamp,
  updated_at timestamp,
  deleted_at timestamp
);
create index idx_regions_deleted_at
  on regions (deleted_at);

insert into regions(country_id, geoname_id, name, ascii_name, adm, country, latitude, longitude, created_at, updated_at
)
select c.id,
       g.geonameid,
       g.name,
       g.asciiname,
       g.admin1,
       c.iso,
       g.latitude,
       g.longitude,
       to_timestamp(TO_CHAR(g.moddate, 'YYYY-MM-DD'), 'YYYY-MM-DD'),
       to_timestamp(TO_CHAR(g.moddate, 'YYYY-MM-DD'), 'YYYY-MM-DD')
from countries as c
       inner join geoname as g on c.iso = g.country and g.fcode like 'ADM1';

-- cities
DROP TABLE IF EXISTS cities;
CREATE TABLE cities
(
  id         serial not null
    constraint cities_pkey primary key,

  country_id int,
  region_id  int,
  geoname_id int,
  name       varchar(200),
  ascii_name varchar(200),
  latitude   float,
  longitude  float,
  created_at timestamp,
  updated_at timestamp,
  deleted_at timestamp
);
create index idx_cities_deleted_at
  on cities (deleted_at);


insert into cities(country_id, region_id, geoname_id, name, ascii_name, latitude, longitude, created_at, updated_at
)
select r.country_id,
       r.id,
       g.geonameid,
       g.name,
       g.asciiname,
       g.latitude,
       g.longitude,
       to_timestamp(TO_CHAR(g.moddate, 'YYYY-MM-DD'), 'YYYY-MM-DD'),
       to_timestamp(TO_CHAR(g.moddate, 'YYYY-MM-DD'), 'YYYY-MM-DD')
from geoname as g
       join regions as r on r.adm = g.admin1
  and r.country = g.country
  and (g.fcode in ('PPLC', 'PPLA') or (g.fcode like 'PPLA%' and g.population >= 50000));