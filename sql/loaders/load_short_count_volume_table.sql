BEGIN;

SET LOCAL work_mem = '2GB';
SET LOCAL maintenance_work_mem = '2GB';

CREATE SCHEMA IF NOT EXISTS __REGION__;

CREATE TABLE IF NOT EXISTS __REGION__.short_count_volume (
  LIKE public.short_count_volume INCLUDING ALL,
  CONSTRAINT rg_chk CHECK (rg = '__REGION_NUM__')
)
INHERITS (public.short_count_volume)
WITH (fillfactor=100, autovacuum_enabled=false);

ALTER TABLE __REGION__.short_count_volume
  OWNER TO __PGUSER__;


DROP TABLE IF EXISTS __REGION__.short_count_volume___YEAR__;

CREATE TABLE __REGION__.short_count_volume___YEAR__ (
  LIKE __REGION__.short_count_volume EXCLUDING ALL
) WITH (fillfactor=100, autovacuum_enabled=false);


COPY __REGION__.short_count_volume___YEAR__ (
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
    day,
    day_of_week,
    federal_direction,
	  lane_code,
	  lanes_in_direction,
	  collection_interval,
    interval_1_1,
    interval_1_2,
    interval_1_3,
    interval_1_4,
    interval_2_1,
    interval_2_2,
    interval_2_3,
    interval_2_4,
    interval_3_1,
    interval_3_2,
    interval_3_3,
    interval_3_4,
    interval_4_1,
    interval_4_2,
    interval_4_3,
    interval_4_4,
    interval_5_1,
    interval_5_2,
    interval_5_3,
    interval_5_4,
    interval_6_1,
    interval_6_2,
    interval_6_3,
    interval_6_4,
    interval_7_1,
    interval_7_2,
    interval_7_3,
    interval_7_4,
    interval_8_1,
    interval_8_2,
    interval_8_3,
    interval_8_4,
    interval_9_1,
    interval_9_2,
    interval_9_3,
    interval_9_4,
    interval_10_1,
    interval_10_2,
    interval_10_3,
    interval_10_4,
    interval_11_1,
    interval_11_2,
    interval_11_3,
    interval_11_4,
    interval_12_1,
    interval_12_2,
    interval_12_3,
    interval_12_4,
    interval_13_1,
    interval_13_2,
    interval_13_3,
    interval_13_4,
    interval_14_1,
    interval_14_2,
    interval_14_3,
    interval_14_4,
    interval_15_1,
    interval_15_2,
    interval_15_3,
    interval_15_4,
    interval_16_1,
    interval_16_2,
    interval_16_3,
    interval_16_4,
    interval_17_1,
    interval_17_2,
    interval_17_3,
    interval_17_4,
    interval_18_1,
    interval_18_2,
    interval_18_3,
    interval_18_4,
    interval_19_1,
    interval_19_2,
    interval_19_3,
    interval_19_4,
    interval_20_1,
    interval_20_2,
    interval_20_3,
    interval_20_4,
    interval_21_1,
    interval_21_2,
    interval_21_3,
    interval_21_4,
    interval_22_1,
    interval_22_2,
    interval_22_3,
    interval_22_4,
    interval_23_1,
    interval_23_2,
    interval_23_3,
    interval_23_4,
    interval_24_1,
    interval_24_2,
    interval_24_3,
    interval_24_4,
    total,
    flag_field,
    batch_id
) FROM '__CSV_PATH__'
  WITH DELIMITER ',' CSV HEADER FREEZE;

ALTER TABLE __REGION__.short_count_volume___YEAR__
  OWNER TO "__PGUSER__",
  INHERIT __REGION__.short_count_volume,
  ADD CONSTRAINT year_chk CHECK (year = __YEAR__),
  ADD CONSTRAINT rg_chk CHECK (rg = '__REGION_NUM__'),
  ADD CONSTRAINT functional_class_fk FOREIGN KEY (functional_class) REFERENCES nysdot_functional_classification_code_descriptions(code),
  ADD CONSTRAINT factor_group_fk FOREIGN KEY (factor_group) REFERENCES nysdot_seasonal_adjustment_factor_group_descriptions(factor_group),
  ADD CONSTRAINT vehicle_axle_code_fk FOREIGN KEY (vehicle_axle_code) REFERENCES nysdot_vehicle_axle_code_descriptions(code),
  ADD CONSTRAINT month_fk FOREIGN KEY (month) REFERENCES calendar_month_names(calendar_month),
  ADD CONSTRAINT day_fk FOREIGN KEY (day) REFERENCES day_of_month_ordinals(day_of_month),
  ADD CONSTRAINT day_of_week_fk FOREIGN KEY (day_of_week) REFERENCES days_of_week(day_of_week),
  ADD CONSTRAINT federal_direction_fk FOREIGN KEY (federal_direction) REFERENCES fhwa_direction_of_travel_code_descriptions(code)
;
