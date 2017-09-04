BEGIN;

SET LOCAL work_mem = '2GB';
SET LOCAL maintenance_work_mem = '2GB';

CREATE SCHEMA IF NOT EXISTS __REGION__;

CREATE TABLE IF NOT EXISTS __REGION__.average_weekday_speed (
  LIKE public.average_weekday_speed INCLUDING ALL,
  CONSTRAINT rg_chk CHECK (rg = '__REGION_NUM__')
)
INHERITS (public.average_weekday_speed)
WITH (fillfactor=100, autovacuum_enabled=false);

ALTER TABLE __REGION__.average_weekday_speed
  OWNER TO __PGUSER__;


DROP TABLE IF EXISTS __REGION__.average_weekday_speed___YEAR__;

CREATE TABLE __REGION__.average_weekday_speed___YEAR__ (
  LIKE __REGION__.average_weekday_speed EXCLUDING ALL
) WITH (fillfactor=100, autovacuum_enabled=false);


COPY __REGION__.average_weekday_speed___YEAR__ (
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
  speed_limit,
  year,
  month,
  day_of_first_data,
  federal_direction,
  full_count,
  avg_wkday_bin_1,
  avg_wkday_bin_2,
  avg_wkday_bin_3,
  avg_wkday_bin_4,
  avg_wkday_bin_5,
  avg_wkday_bin_6,
  avg_wkday_bin_7,
  avg_wkday_bin_8,
  avg_wkday_bin_9,
  avg_wkday_bin_10,
  avg_wkday_bin_11,
  avg_wkday_bin_12,
  avg_wkday_bin_13,
  avg_wkday_bin_14,
  avg_wkday_bin_15,
  avg_wkday_unclassified,
  avg_wkday_totals,
  avg_speed,
  fiftyth_percentile_speed,
  eightyfiveth_percentile_speed,
  percentile_exceeding_55,
  percentile_exceeding_65,
  flag_field,
  batch_id
) FROM '__CSV_PATH__'
  WITH DELIMITER ',' CSV HEADER FREEZE;


ALTER TABLE __REGION__.average_weekday_speed___YEAR__
  OWNER TO "__PGUSER__",
  INHERIT __REGION__.average_weekday_speed,
  ADD CONSTRAINT year_chk CHECK (year = __YEAR__),
  ADD CONSTRAINT rg_chk CHECK (rg = '__REGION_NUM__'),
  ADD CONSTRAINT functional_class_fk FOREIGN KEY (functional_class) REFERENCES nysdot_functional_classification_code_descriptions(code),
  ADD CONSTRAINT factor_group_fk FOREIGN KEY (factor_group) REFERENCES nysdot_seasonal_adjustment_factor_group_descriptions(factor_group),
  ADD CONSTRAINT month_fk FOREIGN KEY (month) REFERENCES calendar_month_names(calendar_month),
  ADD CONSTRAINT day_of_first_data_fk FOREIGN KEY (day_of_first_data) REFERENCES day_of_month_ordinals(day_of_month),
  ADD CONSTRAINT federal_direction_fk FOREIGN KEY (federal_direction) REFERENCES fhwa_direction_of_travel_code_descriptions(code)
;


COMMIT;
