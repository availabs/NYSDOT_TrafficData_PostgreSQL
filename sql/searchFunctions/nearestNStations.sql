BEGIN;

DROP TYPE IF EXISTS nearest_n_short_count_stations CASCADE;

CREATE TYPE nearest_n_short_count_stations AS (
  station_id            VARCHAR,
  region                SMALLINT,
  region_code           SMALLINT,
  county_code           SMALLINT,
  latitude              DOUBLE PRECISION,
  longitude             DOUBLE PRECISION,
  muni                  VARCHAR,
  tdv_route             VARCHAR,
  begindesc             VARCHAR,
  enddesc               VARCHAR,
  functional_class      SMALLINT,
  factor_group          SMALLINT,
  distance_from_location_meters  DOUBLE PRECISION
);

DROP FUNCTION IF EXISTS search_nearest_n_short_count_stations(DOUBLE PRECISION, DOUBLE PRECISION, INTEGER);

CREATE FUNCTION search_nearest_n_short_count_stations(
    q_lon DOUBLE PRECISION,
    q_lat DOUBLE PRECISION,
    n INTEGER
  ) RETURNS SETOF nearest_n_short_count_stations AS
$$
  SELECT
      loc.station_id,
      loc.region,
      loc.region_code,
      loc.county_code,
      loc.latitude::DOUBLE PRECISION,
      loc.longitude::DOUBLE PRECISION,
      loc.muni,
      loc.tdv_route,
      loc.begindesc,
      loc.enddesc,
      meta.functional_class,
      meta.factor_group,
      shp.distance_from_location_meters
    FROM station_location_data AS loc
      INNER JOIN (
        SELECT
            station_id,
            functional_class,
            factor_group
          FROM station_metadata
          WHERE (station_id, max_date) IN (
            SELECT
                station_id,
                MAX(max_date)
              FROM station_metadata 
              GROUP BY station_id
          )
      ) AS meta USING (station_id)
      INNER JOIN (
        SELECT
            rc_id,
            AVG(
              ST_Distance(
                GEOGRAPHY(ST_PointFromText('POINT(' || q_lon || ' ' || q_lat || ')', 4326)),
                GEOGRAPHY(ST_PointFromText('POINT(' || s.longitude || ' ' || s.latitude || ')', 4326))
              )
            ) AS distance_from_location_meters
          FROM short_counts_shp AS s
          GROUP BY rc_id
          ORDER BY distance_from_location_meters
          LIMIT n
      ) AS shp ON (meta.station_id = shp.rc_id)

$$ LANGUAGE SQL STABLE;
;

COMMIT;
