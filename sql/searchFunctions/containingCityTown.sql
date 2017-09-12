DROP TYPE containing_city_town CASCADE;

CREATE TYPE containing_city_town AS (name VARCHAR, county VARCHAR, muni_type VARCHAR);

DROP FUNCTION IF EXISTS search_containing_city_town(DOUBLE PRECISION, DOUBLE PRECISION);

CREATE FUNCTION search_containing_city_town(
    q_lon DOUBLE PRECISION,
    q_lat DOUBLE PRECISION
  ) RETURNS SETOF containing_city_town AS
$$

SELECT
    name,
    county,
    muni_type,
    fips
  FROM cities_towns
  WHERE ST_Contains(
    wkb_geometry,
    ST_PointFromText('POINT(' || q_lon || ' ' || q_lat || ')', 4326)
  )

$$ LANGUAGE SQL STABLE;
;



