BEGIN;

-- http://www.postgresonline.com/journal/archives/248-Moving-PostGIS-to-another-schema-with-Extensions.html
CREATE SCHEMA IF NOT EXISTS postgis;

ALTER DATABASE nys_dot_traffic_data
  SET search_path="$user", public, postgis,topology;

GRANT ALL ON SCHEMA postgis TO public;

CREATE EXTENSION IF NOT EXISTS postgis
  WITH SCHEMA postgis;

COMMIT;
