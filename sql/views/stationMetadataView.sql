BEGIN;

DROP MATERIALIZED VIEW IF EXISTS station_metadata;

CREATE MATERIALIZED VIEW IF NOT EXISTS station_metadata
WITH (fillfactor = 100)
AS
  SELECT
      rc_station AS station_id,
      functional_class,
      factor_group,
      'average_weekday_speed' AS table_name,
      COUNT(1) AS count,
      MIN(year::TEXT || LPAD(month::text, 2, '0') || LPAD(day_of_first_data::text, 2, '0')) AS min_date,
      MAX(year::TEXT || LPAD(month::text, 2, '0') || LPAD(day_of_first_data::text, 2, '0')) AS max_date
    FROM average_weekday_speed
    GROUP BY station_id, functional_class, factor_group, table_name
  UNION
  SELECT
      rc_station AS station_id,
      functional_class,
      factor_group,
      'average_weekday_vehicle_classification' AS table_name,
      COUNT(1) AS count,
      MIN(year::TEXT || LPAD(month::text, 2, '0') || LPAD(day_of_first_data::text, 2, '0')) AS min_date,
      MAX(year::TEXT || LPAD(month::text, 2, '0') || LPAD(day_of_first_data::text, 2, '0')) AS max_date
    FROM average_weekday_vehicle_classification
    GROUP BY station_id, functional_class, factor_group, table_name
  UNION
  SELECT
      rc_station AS station_id,
      functional_class,
      factor_group,
      'average_weekday_volume' AS table_name,
      COUNT(1) AS count,
      MIN(year::TEXT || LPAD(month::text, 2, '0') || LPAD(day_of_first_data::text, 2, '0')) AS min_date,
      MAX(year::TEXT || LPAD(month::text, 2, '0') || LPAD(day_of_first_data::text, 2, '0')) AS max_date
    FROM average_weekday_volume
    GROUP BY station_id, functional_class, factor_group, table_name
  UNION
  SELECT
      rc_station AS station_id,
      functional_class,
      factor_group,
      'short_count_speed' AS table_name,
      COUNT(1) AS count,
      MIN(year::TEXT || LPAD(month::text, 2, '0') || LPAD(day::text, 2, '0')) AS min_date,
      MAX(year::TEXT || LPAD(month::text, 2, '0') || LPAD(day::text, 2, '0')) AS max_date
    FROM short_count_speed
    GROUP BY station_id, functional_class, factor_group, table_name
  UNION
  SELECT
      rc_station AS station_id,
      functional_class,
      factor_group,
      'short_count_vehicle_classification' AS table_name,
      COUNT(1) AS count,
      MIN(year::TEXT || LPAD(month::text, 2, '0') || LPAD(day::text, 2, '0')) AS min_date,
      MAX(year::TEXT || LPAD(month::text, 2, '0') || LPAD(day::text, 2, '0')) AS max_date
    FROM short_count_vehicle_classification
    GROUP BY station_id, functional_class, factor_group, table_name
  UNION
  SELECT
      rc_station AS station_id,
      functional_class,
      factor_group,
      'short_count_volume' AS table_name,
      COUNT(1) AS count,
      MIN(year::TEXT || LPAD(month::text, 2, '0') || LPAD(day::text, 2, '0')) AS min_date,
      MAX(year::TEXT || LPAD(month::text, 2, '0') || LPAD(day::text, 2, '0')) AS max_date
    FROM short_count_volume
    GROUP BY station_id, functional_class, factor_group, table_name
  UNION
  SELECT
      (rc || '_' || station) AS station_id,
      fc AS functional_class,
      NULL::SMALLINT AS factor_group,
      'continuous_vehicle_classification' AS table_name,
      COUNT(1) AS count,
      MIN(year::TEXT || LPAD(month::text, 2, '0') || LPAD(day::text, 2, '0')) AS min_date,
      MAX(year::TEXT || LPAD(month::text, 2, '0') || LPAD(day::text, 2, '0')) AS max_date
    FROM continuous_vehicle_classification
    GROUP BY rc, station, functional_class, factor_group, table_name
  UNION
  SELECT
      (rc || '_' || station) AS station_id,
      fc AS functional_class,
      NULL::SMALLINT AS factor_group,
      'countinuous_volume' AS table_name,
      COUNT(1) AS count,
      MIN(year::TEXT || LPAD(month::text, 2, '0') || LPAD(day::text, 2, '0')) AS min_date,
      MAX(year::TEXT || LPAD(month::text, 2, '0') || LPAD(day::text, 2, '0')) AS max_date
    FROM continuous_volume
    GROUP BY rc, station, functional_class, factor_group, table_name
;

ALTER MATERIALIZED VIEW station_metadata OWNER TO npmrds_ninja;

CREATE INDEX station_metadata_idx ON station_metadata (station_id);

CLUSTER station_metadata USING station_metadata_idx;

COMMIT;

ANALYZE station_metadata;
