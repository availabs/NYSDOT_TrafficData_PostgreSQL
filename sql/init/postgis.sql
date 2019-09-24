BEGIN;

-- Keeps postgis database objects from cluttering up the public schema.
-- SEE: http://www.postgresonline.com/journal/archives/248-Moving-PostGIS-to-another-schema-with-Extensions.html
DROP SCHEMA IF EXISTS postgis CASCADE;
CREATE SCHEMA postgis;

ALTER DATABASE __PGDATABASE__
  SET search_path="$user", public, postgis,topology;

GRANT ALL ON SCHEMA postgis TO public;

CREATE EXTENSION IF NOT EXISTS postgis
  WITH SCHEMA postgis;

COMMIT;
