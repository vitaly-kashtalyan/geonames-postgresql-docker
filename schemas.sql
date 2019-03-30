DROP TABLE IF EXISTS geoname;
create table geoname
(
  geonameid      int,
  name           varchar(200),
  asciiname      varchar(200),
  alternatenames text,
  latitude       float,
  longitude      float,
  fclass         char(1),
  fcode          varchar(10),
  country        varchar(2),
  cc2            varchar(600),
  admin1         varchar(20),
  admin2         varchar(80),
  admin3         varchar(20),
  admin4         varchar(20),
  population     bigint,
  elevation      int,
  gtopo30        int,
  timezone       varchar(40),
  moddate        date
);

DROP TABLE IF EXISTS countryinfo;
CREATE TABLE countryinfo
(
  iso_alpha2           char(2),
  iso_alpha3           char(3),
  iso_numeric          integer,
  fips_code            character varying(3),
  country              character varying(200),
  capital              character varying(200),
  areainsqkm           double precision,
  population           integer,
  continent            char(2),
  tld                  CHAR(10),
  currency_code        char(3),
  currency_name        CHAR(20),
  phone                character varying(20),
  postal               character varying(60),
  postalRegex          character varying(200),
  languages            character varying(200),
  geonameId            int,
  neighbours           character varying(50),
  equivalent_fips_code character varying(3)
);

