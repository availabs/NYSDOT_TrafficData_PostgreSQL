BEGIN;

SET LOCAL work_mem = '2GB';
SET LOCAL maintenance_work_mem = '2GB';

CREATE SCHEMA IF NOT EXISTS __REGION__;

CREATE TABLE IF NOT EXISTS __REGION__.average_weekday_vehicle_classification (
  LIKE public.average_weekday_vehicle_classification INCLUDING ALL,
  CONSTRAINT rg_chk CHECK (rg = '__REGION_NUM__')
)
INHERITS (public.average_weekday_vehicle_classification)
WITH (fillfactor=100, autovacuum_enabled=false);

ALTER TABLE __REGION__.average_weekday_vehicle_classification
  OWNER TO __PGUSER__;


DROP TABLE IF EXISTS __REGION__.average_weekday_vehicle_classification___YEAR__;

CREATE TABLE __REGION__.average_weekday_vehicle_classification___YEAR__ (
  LIKE __REGION__.average_weekday_vehicle_classification EXCLUDING ALL
) WITH (fillfactor=100, autovacuum_enabled=false);


\copy __REGION__.average_weekday_vehicle_classification___YEAR__ ( rc_station, count_id, rg, region_code, county_code, stat, rcsta, functional_class, factor_group, latitude, longitude, specific_recorder_placement, channel_notes, data_type, blank, year, month, day_of_first_data, federal_direction, full_count, avg_wkday_f1s, avg_wkday_f2s, avg_wkday_f3s, avg_wkday_f4s, avg_wkday_f5s, avg_wkday_f6s, avg_wkday_f7s, avg_wkday_f8s, avg_wkday_f9s, avg_wkday_f10s, avg_wkday_f11s, avg_wkday_f12s, avg_wkday_f13s, avg_wkday_unclassified, avg_wkday_totals, avg_wkday_perc_f3_13, avg_wkday_perc_f4_13, avg_wkday_perc_f4_7, avg_wkday_perc_f8_13, avg_wkday_perc_f1, avg_wkday_perc_f2, avg_wkday_perc_f3, avg_wkday_perc_f4, avg_wkday_perc_f5_7, axle_correction_factor, su_peak, cu_peak, su_aadt, cu_aadt, flag_field, batch_id) FROM '__CSV_PATH__' WITH DELIMITER ',' CSV HEADER FREEZE; 

ALTER TABLE __REGION__.average_weekday_vehicle_classification___YEAR__
  OWNER TO "__PGUSER__",
  INHERIT __REGION__.average_weekday_vehicle_classification,
  ADD CONSTRAINT year_chk CHECK (year = __YEAR__),
  ADD CONSTRAINT rg_chk CHECK (rg = '__REGION_NUM__'),
  ADD CONSTRAINT functional_class_fk FOREIGN KEY (functional_class) REFERENCES nysdot_functional_classification_code_descriptions(code),
  ADD CONSTRAINT factor_group_fk FOREIGN KEY (factor_group) REFERENCES nysdot_seasonal_adjustment_factor_group_descriptions(factor_group),
  ADD CONSTRAINT month_fk FOREIGN KEY (month) REFERENCES calendar_month_names(calendar_month),
  ADD CONSTRAINT day_of_first_data_fk FOREIGN KEY (day_of_first_data) REFERENCES day_of_month_ordinals(day_of_month),
  ADD CONSTRAINT federal_direction_fk FOREIGN KEY (federal_direction) REFERENCES fhwa_direction_of_travel_code_descriptions(code)
;


COMMIT;
