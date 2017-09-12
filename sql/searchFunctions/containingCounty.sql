DROP TYPE containing_county CASCADE;

CREATE TYPE containing_county AS (name VARCHAR, region SMALLINT, fips VARCHAR);

DROP FUNCTION IF EXISTS search_containing_county(DOUBLE PRECISION, DOUBLE PRECISION);

CREATE FUNCTION search_containing_county(
    q_lon DOUBLE PRECISION,
    q_lat DOUBLE PRECISION
  ) RETURNS SETOF containing_county AS
$$

SELECT
    c2.name,
    c2.region::SMALLINT,
    c2.fips
  FROM counties AS c1
    INNER JOIN nys_counties AS c2
    ON (c1.countyfips = c2.fips)
  WHERE ST_Contains(
    c1.wkb_geometry,
    ST_PointFromText('POINT(' || q_lon || ' ' || q_lat || ')', 4326)
  )

$$ LANGUAGE SQL STABLE;
;
