BEGIN;

SET LOCAL work_mem = '2GB';
SET LOCAL maintenance_work_mem = '2GB';

CREATE SCHEMA IF NOT EXISTS __REGION__;

CREATE TABLE IF NOT EXISTS __REGION__.continuous_volume (
  LIKE public.continuous_volume INCLUDING ALL,
  CONSTRAINT region_chk CHECK (region = __REGION_NUM__)
)
INHERITS (public.continuous_volume)
WITH (fillfactor=100, autovacuum_enabled=false);

ALTER TABLE __REGION__.continuous_volume
  OWNER TO __PGUSER__;


DROP TABLE IF EXISTS __REGION__.continuous_volume___YEAR__;

CREATE TABLE __REGION__.continuous_volume___YEAR__ (
  LIKE __REGION__.continuous_volume EXCLUDING ALL
) WITH (fillfactor=100, autovacuum_enabled=false);


\copy __REGION__.continuous_volume___YEAR__ ( rc, station, region, dotid, ccid, fc, route, roadname, county, county_fips, begin_desc, end_desc, station_id, road, one_way, year, month, day, dow, i1, i2, i3, i4, i5, i6, i7, i8, i9, i10, i11, i12, i13, i14, i15, i16, i17, i18, i19, i20, i21, i22, i23, i24) FROM '__CSV_PATH__' WITH DELIMITER ',' CSV HEADER FREEZE;

ALTER TABLE __REGION__.continuous_volume___YEAR__
  OWNER TO "__PGUSER__",
  INHERIT __REGION__.continuous_volume,
  ADD CONSTRAINT year_chk CHECK (year = __YEAR__),
  ADD CONSTRAINT region_chk CHECK (region = __REGION_NUM__),
  ADD CONSTRAINT region_fk FOREIGN KEY (region) REFERENCES nysdot_region_names(region),
  ADD CONSTRAINT fc_fk FOREIGN KEY (fc) REFERENCES nysdot_functional_classification_code_descriptions(code),
  ADD CONSTRAINT road_fk FOREIGN KEY (road) REFERENCES nysdot_road_direction_code_descriptions(code),
  ADD CONSTRAINT one_way_fk FOREIGN KEY (one_way) REFERENCES nysdot_one_way_road_flag_descriptions(flag_value),
  ADD CONSTRAINT month_fk FOREIGN KEY (month) REFERENCES calendar_month_names(calendar_month),
  ADD CONSTRAINT day_fk FOREIGN KEY (day) REFERENCES day_of_month_ordinals(day_of_month),
  ADD CONSTRAINT dow_fk FOREIGN KEY (dow) REFERENCES days_of_week(dow)
;

COMMIT;
