DROP TYPE containing_village CASCADE;

CREATE TYPE containing_village AS (name VARCHAR, county VARCHAR);

DROP FUNCTION IF EXISTS search_containing_village(DOUBLE PRECISION, DOUBLE PRECISION);

CREATE FUNCTION search_containing_village(
    q_lon DOUBLE PRECISION,
    q_lat DOUBLE PRECISION
  ) RETURNS SETOF containing_village AS
$$

SELECT
    name,
    county
  FROM villages
  WHERE ST_Contains(
    wkb_geometry,
    ST_PointFromText('POINT(' || q_lon || ' ' || q_lat || ')', 4326)
  )

$$ LANGUAGE SQL STABLE;
;



