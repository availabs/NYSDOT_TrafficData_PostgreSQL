BEGIN;

SET LOCAL work_mem = '2GB';
SET LOCAL maintenance_work_mem = '2GB';

CREATE SCHEMA IF NOT EXISTS __REGION__;

CREATE TABLE IF NOT EXISTS __REGION__.continuous_vehicle_classification (
  LIKE public.continuous_vehicle_classification INCLUDING ALL,
  CONSTRAINT region_chk CHECK (region = __REGION_NUM__)
)
INHERITS (public.continuous_vehicle_classification)
WITH (fillfactor=100, autovacuum_enabled=false);

ALTER TABLE __REGION__.continuous_vehicle_classification
  OWNER TO __PGUSER__;


DROP TABLE IF EXISTS __REGION__.continuous_vehicle_classification___YEAR__;

CREATE TABLE __REGION__.continuous_vehicle_classification___YEAR__ (
  LIKE __REGION__.continuous_vehicle_classification EXCLUDING ALL
) WITH (fillfactor=100, autovacuum_enabled=false);


COPY __REGION__.continuous_vehicle_classification___YEAR__ (
    rc,
    station,
    region,
    dotid,
    ccid,
    fc,
    route,
    roadname,
    county,
    county_fips,
    begin_desc,
    end_desc,
    station_id,
    road,
    one_way,
    year,
    month,
    day,
    dow,
    hour,
    f1,
    f2,
    f3,
    f4,
    f5,
    f6,
    f7,
    f8,
    f9,
    f10,
    f11,
    f12,
    f13
) FROM '__CSV_PATH__'
  WITH DELIMITER ',' CSV HEADER FREEZE;

ALTER TABLE __REGION__.continuous_vehicle_classification___YEAR__
  OWNER TO "__PGUSER__",
  INHERIT __REGION__.continuous_vehicle_classification,
  ADD CONSTRAINT year_chk CHECK (year = __YEAR__),
  ADD CONSTRAINT region_chk CHECK (region = __REGION_NUM__),
  ADD CONSTRAINT region_fk FOREIGN KEY (region) REFERENCES nysdot_region_names(region),
  ADD CONSTRAINT fc_fk FOREIGN KEY (fc) REFERENCES nysdot_functional_classification_code_descriptions(code),
  ADD CONSTRAINT road_fk FOREIGN KEY (road) REFERENCES nysdot_road_direction_code_descriptions(code),
  ADD CONSTRAINT one_way_fk FOREIGN KEY (one_way) REFERENCES nysdot_one_way_road_flag_descriptions(flag_value),
  ADD CONSTRAINT month_fk FOREIGN KEY (month) REFERENCES calendar_month_names(calendar_month),
  ADD CONSTRAINT day_fk FOREIGN KEY (day) REFERENCES day_of_month_ordinals(day_of_month),
  ADD CONSTRAINT dow_fk FOREIGN KEY (dow) REFERENCES days_of_week(dow),
  ADD CONSTRAINT hour_fk FOREIGN KEY (hour) REFERENCES hour_of_day_ranges(hour_of_day)
;


COMMIT;

