BEGIN;

DROP FUNCTION IF EXISTS search_n_nearest_short_count_stations(DOUBLE PRECISION, DOUBLE PRECISION);

CREATE FUNCTION search_n_nearest_short_count_stations(
    q_lon DOUBLE PRECISION,
    q_lat DOUBLE PRECISION
  ) RETURNS SETOF VARCHAR AS
$$

SELECT
    rc_id
  FROM short_counts_shp
  ORDER BY ST_Distance(
    ST_PointFromText('POINT(' || q_lon || ' ' || q_lat || ')', 4326),
    ST_PointFromText('POINT(' || longitude || ' ' || latitude || ')', 4326)
  )
  LIMIT 5

$$ LANGUAGE SQL STABLE;
;

COMMIT;
