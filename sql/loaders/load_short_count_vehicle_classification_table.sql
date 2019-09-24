BEGIN;

SET LOCAL work_mem = '2GB';
SET LOCAL maintenance_work_mem = '2GB';

CREATE SCHEMA IF NOT EXISTS __REGION__;

CREATE TABLE IF NOT EXISTS __REGION__.short_count_vehicle_classification (
  LIKE public.short_count_vehicle_classification INCLUDING ALL,
  CONSTRAINT rg_chk CHECK (rg = '__REGION_NUM__')
)
INHERITS (public.short_count_vehicle_classification)
WITH (fillfactor=100, autovacuum_enabled=false);

ALTER TABLE __REGION__.short_count_vehicle_classification
  OWNER TO __PGUSER__;


DROP TABLE IF EXISTS __REGION__.short_count_vehicle_classification___YEAR__;

CREATE TABLE __REGION__.short_count_vehicle_classification___YEAR__ (
  LIKE __REGION__.short_count_vehicle_classification EXCLUDING ALL
) WITH (fillfactor=100, autovacuum_enabled=false);


\copy __REGION__.short_count_vehicle_classification___YEAR__ ( rc_station, count_id, rg, region_code, county_code, stat, rcsta, functional_class, factor_group, latitude, longitude, specific_recorder_placement, channel_notes, data_type, blank, year, month, day, day_of_week, federal_direction, lane_code, lanes_in_direction, collection_interval, data_interval, class_f1, class_f2, class_f3, class_f4, class_f5, class_f6, class_f7, class_f8, class_f9, class_f10, class_f11, class_f12, class_f13, unclassified, total, flag_field, batch_id) FROM '__CSV_PATH__' WITH DELIMITER ',' CSV HEADER FREEZE;

ALTER TABLE __REGION__.short_count_vehicle_classification___YEAR__
  OWNER TO "__PGUSER__",
  INHERIT __REGION__.short_count_vehicle_classification,
  ADD CONSTRAINT year_chk CHECK (year = __YEAR__),
  ADD CONSTRAINT rg_chk CHECK (rg = '__REGION_NUM__'),
  ADD CONSTRAINT functional_class_fk FOREIGN KEY (functional_class) REFERENCES nysdot_functional_classification_code_descriptions(code),
  ADD CONSTRAINT factor_group_fk FOREIGN KEY (factor_group) REFERENCES nysdot_seasonal_adjustment_factor_group_descriptions(factor_group),
  ADD CONSTRAINT month_fk FOREIGN KEY (month) REFERENCES calendar_month_names(calendar_month),
  ADD CONSTRAINT day_fk FOREIGN KEY (day) REFERENCES day_of_month_ordinals(day_of_month),
  ADD CONSTRAINT day_of_week_fk FOREIGN KEY (day_of_week) REFERENCES days_of_week(day_of_week),
  ADD CONSTRAINT federal_direction_fk FOREIGN KEY (federal_direction) REFERENCES fhwa_direction_of_travel_code_descriptions(code),
  ADD CONSTRAINT data_interval_fk FOREIGN KEY (data_interval) REFERENCES nysdot_data_interval_descriptions(data_interval)
;


COMMIT;
