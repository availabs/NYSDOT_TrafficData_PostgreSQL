BEGIN;

SET LOCAL work_mem = '2GB';
SET LOCAL maintenance_work_mem = '2GB';

CREATE SCHEMA IF NOT EXISTS __REGION__;

CREATE TABLE IF NOT EXISTS __REGION__.average_weekday_volume (
  LIKE public.average_weekday_volume INCLUDING ALL,
  CONSTRAINT rg_chk CHECK (rg = '__REGION_NUM__')
)
INHERITS (public.average_weekday_volume)
WITH (fillfactor=100, autovacuum_enabled=false);

ALTER TABLE __REGION__.average_weekday_volume
  OWNER TO __PGUSER__;


DROP TABLE IF EXISTS __REGION__.average_weekday_volume___YEAR__;

CREATE TABLE __REGION__.average_weekday_volume___YEAR__ (
  LIKE __REGION__.average_weekday_volume EXCLUDING ALL
) WITH (fillfactor=100, autovacuum_enabled=false);


COPY __REGION__.average_weekday_volume___YEAR__ (
  rc_station,
  count_id,
  rg,
  region_code,
  county_code,
  stat,
  rcsta,
  functional_class,
  factor_group,
  latitude,
  longitude,
  specific_recorder_placement,
  channel_notes,
  data_type,
  vehicle_axle_code,
  year,
  month,
  day_of_first_data,
  federal_direction,
  full_count,
  avg_wkday_interval_1,
  avg_wkday_interval_2,
  avg_wkday_interval_3,
  avg_wkday_interval_4,
  avg_wkday_interval_5,
  avg_wkday_interval_6,
  avg_wkday_interval_7,
  avg_wkday_interval_8,
  avg_wkday_interval_9,
  avg_wkday_interval_10,
  avg_wkday_interval_11,
  avg_wkday_interval_12,
  avg_wkday_interval_13,
  avg_wkday_interval_14,
  avg_wkday_interval_15,
  avg_wkday_interval_16,
  avg_wkday_interval_17,
  avg_wkday_interval_18,
  avg_wkday_interval_19,
  avg_wkday_interval_20,
  avg_wkday_interval_21,
  avg_wkday_interval_22,
  avg_wkday_interval_23,
  avg_wkday_interval_24,
  avg_wkday_daily_traffic,
  seasonal_factor,
  axle_factor,
  aadt,
  high_hour_value,
  high_hour_interval,
  k_factor,
  d_factor,
  flag_field,
  batch_id
) FROM '__CSV_PATH__'
  WITH DELIMITER ',' CSV HEADER FREEZE;

ALTER TABLE __REGION__.average_weekday_volume___YEAR__
  OWNER TO "__PGUSER__",
  INHERIT __REGION__.average_weekday_volume,
  ADD CONSTRAINT year_chk CHECK (year = __YEAR__),
  ADD CONSTRAINT rg_chk CHECK (rg = '__REGION_NUM__'),
  ADD CONSTRAINT functional_class_fk FOREIGN KEY (functional_class) REFERENCES nysdot_functional_classification_code_descriptions(code),
  ADD CONSTRAINT factor_group_fk FOREIGN KEY (factor_group) REFERENCES nysdot_seasonal_adjustment_factor_group_descriptions(factor_group),
  ADD CONSTRAINT vehicle_axle_code_fk FOREIGN KEY (vehicle_axle_code) REFERENCES nysdot_vehicle_axle_code_descriptions(code),
  ADD CONSTRAINT month_fk FOREIGN KEY (month) REFERENCES calendar_month_names(calendar_month),
  ADD CONSTRAINT day_of_first_data_fk FOREIGN KEY (day_of_first_data) REFERENCES day_of_month_ordinals(day_of_month),
  ADD CONSTRAINT federal_direction_fk FOREIGN KEY (federal_direction) REFERENCES fhwa_direction_of_travel_code_descriptions(code)
;


COMMIT;

