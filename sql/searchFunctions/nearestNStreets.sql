BEGIN;

DROP TYPE IF EXISTS nearest_n_streets CASCADE;

CREATE TYPE nearest_n_streets AS (
  tdv_route   VARCHAR,
  cc_id       VARCHAR,
  roadwaytyp  VARCHAR,
  begindesc   VARCHAR,
  enddesc     VARCHAR,
  muni        VARCHAR,
  distance_from_location_meters  DOUBLE PRECISION
);

DROP FUNCTION IF EXISTS search_nearest_n_streets(DOUBLE PRECISION, DOUBLE PRECISION, INTEGER);

CREATE FUNCTION search_nearest_n_streets(
    q_lon DOUBLE PRECISION,
    q_lat DOUBLE PRECISION,
    n INTEGER
  ) RETURNS SETOF nearest_n_streets AS
$$
  SELECT
      tdv_route,
      cc_id,
      roadwaytyp,
      begindesc,
      enddesc,
      muni,
      distance_from_location_meters
    FROM aadt_shp
      INNER JOIN (
      SELECT
          rc_id,
          AVG(
            ST_Distance(
              GEOGRAPHY(ST_PointFromText('POINT(' || q_lon || ' ' || q_lat || ')', 4326)),
              GEOGRAPHY(wkb_geometry)
            )
          ) AS distance_from_location_meters
        FROM short_counts_shp AS s
        GROUP BY rc_id
        ORDER BY distance_from_location_meters
        LIMIT n
    ) AS n_nearest USING (rc_id);

$$ LANGUAGE SQL STABLE;
;

COMMIT;
