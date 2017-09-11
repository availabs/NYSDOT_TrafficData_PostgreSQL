BEGIN;

DROP MATERIALIZED VIEW IF EXISTS region_metadata;

CREATE MATERIALIZED VIEW IF NOT EXISTS region_metadata
WITH (fillfactor = 100)
AS
  SELECT
      region,
      COUNT(DISTINCT station_id) AS station_count,
      'Short Count' AS count_type,
      county_code,
      functional_class,
      factor_group,
      MIN(min_date) AS min_date,
      MAX(max_date) AS max_date
    FROM station_metadata
    WHERE table_name LIKE 'short_count%'
    GROUP BY
      region,
      count_type,
      county_code,
      functional_class,
      factor_group
  UNION
  SELECT
      region,
      COUNT(DISTINCT station_id) AS station_count,
      'Continuous Count' AS count_type,
      county_code,
      functional_class,
      factor_group,
      MIN(min_date),
      MAX(max_date)
    FROM station_metadata
    WHERE table_name LIKE 'continuous%'
    GROUP BY
      region,
      count_type,
      county_code,
      functional_class,
      factor_group
;

CREATE INDEX region_metadata_idx ON region_metadata (region);

CLUSTER region_metadata USING region_metadata_idx;

COMMIT;

ANALYZE region_metadata;
