BEGIN;

DROP TABLE IF EXISTS continuous_volume CASCADE;

CREATE TABLE continuous_volume (
    rc            VARCHAR(2),
    station       VARCHAR(4),
    region        nysdot_region REFERENCES nysdot_region_names(region),
    dotid         VARCHAR,
    ccid          VARCHAR(4),
    fc            nysdot_functional_classification_code REFERENCES nysdot_functional_classification_code_descriptions(code),
    route         VARCHAR,
    roadname      VARCHAR,
    county        VARCHAR,
    county_fips   VARCHAR(3),
    begin_desc    VARCHAR,
    end_desc      VARCHAR,
    station_id    VARCHAR(6),
    road          nysdot_road_direction_code REFERENCES nysdot_road_direction_code_descriptions(code),
    one_way       nysdot_one_way_road_flag REFERENCES nysdot_one_way_road_flag_descriptions(flag_value),
    year          calendar_year,
    month         calendar_month REFERENCES calendar_month_names(calendar_month),
    day           day_of_month REFERENCES day_of_month_ordinals(day_of_month),
    dow           day_of_week_code REFERENCES days_of_week(dow),
    i1            INTEGER, 
    i2            INTEGER, 
    i3            INTEGER, 
    i4            INTEGER, 
    i5            INTEGER, 
    i6            INTEGER, 
    i7            INTEGER, 
    i8            INTEGER, 
    i9            INTEGER, 
    i10           INTEGER, 
    i11           INTEGER, 
    i12           INTEGER, 
    i13           INTEGER, 
    i14           INTEGER, 
    i15           INTEGER, 
    i16           INTEGER, 
    i17           INTEGER, 
    i18           INTEGER, 
    i19           INTEGER, 
    i20           INTEGER, 
    i21           INTEGER, 
    i22           INTEGER, 
    i23           INTEGER, 
    i24           INTEGER
);


-- https://www.dot.ny.gov/divisions/engineering/technical-services/highway-data-services/hdsb/repository/Field_Definitions_CC%20Formats.pdf

COMMENT ON TABLE continuous_volume IS
'Hourly continuous count volume data by direction.';


COMMENT ON COLUMN continuous_volume.rc IS
'Region County Code, a two digit NYSDOT code representing the Region and County number within the Region.';

COMMENT ON COLUMN continuous_volume.station IS
'A four digit number, unique within a county representing a specific segment of road.';

COMMENT ON COLUMN continuous_volume.region IS
'The NYSDOT Region number.';

COMMENT ON COLUMN continuous_volume.dotid IS
'A unique ID.';

COMMENT ON COLUMN continuous_volume.ccid IS
'Continuous Count ID, a four digit number identifying a continuous count location within a station. May also be referred to as CCSTA or Continuous Count Station Number.';

COMMENT ON COLUMN continuous_volume.fc IS
'Functional Class of the roadway segment to which the station applies.';

COMMENT ON COLUMN continuous_volume.route IS
'Route number of the roadway segment to which the station applies.';

COMMENT ON COLUMN continuous_volume.roadname IS
'Name of the roadway segment to which the station applies.';

COMMENT ON COLUMN continuous_volume.county IS
'Name of the county where the station is located.';

COMMENT ON COLUMN continuous_volume.county_fips IS
'The FIPS county code is a five-digit Federal Information Processing Standards (FIPS) code (FIPS 6-4) which uniquely identifies counties and county equivalents in the United States, certain U.S. possessions, and certain freely associated states.';

COMMENT ON COLUMN continuous_volume.begin_desc IS
'A description of the beginning of the roadway segment to which the station applies.';

COMMENT ON COLUMN continuous_volume.end_desc IS
'A description of the ending of the roadway segment to which the station applies.';

COMMENT ON COLUMN continuous_volume.station_id IS
'A concatenation of the Region County and Station fields. Creates a Unique six character ID.';

COMMENT ON COLUMN continuous_volume.road IS
'The direction of the data.';

COMMENT ON COLUMN continuous_volume.one_way IS
'Indicates if the segment is a one‐way road. ‘Y’.';

COMMENT ON COLUMN continuous_volume.year IS
'The year in which the data was collected.';

COMMENT ON COLUMN continuous_volume.month IS
'Where applicable, the month in which the data was collected.';

COMMENT ON COLUMN continuous_volume.day IS
'Where applicable, the day of the month on which the data was collected.';

COMMENT ON COLUMN continuous_volume.dow IS
'Day of Week. Where applicable, the day of week, expressed as 1‐7 with 1 being Sunday and 7 being Saturday.';

COMMENT ON COLUMN continuous_volume.i1 IS
'Where applicable, the volume in interval 1 (00:00-01:00).';

COMMENT ON COLUMN continuous_volume.i2 IS
'Where applicable, the volume in interval 2 (01:00-02:00).';

COMMENT ON COLUMN continuous_volume.i3 IS
'Where applicable, the volume in interval 3 (02:00-03:00).';

COMMENT ON COLUMN continuous_volume.i4 IS
'Where applicable, the volume in interval 4 (03:00-04:00).';

COMMENT ON COLUMN continuous_volume.i5 IS
'Where applicable, the volume in interval 5 (04:00-05:00).';

COMMENT ON COLUMN continuous_volume.i6 IS
'Where applicable, the volume in interval 6 (05:00-06:00).';

COMMENT ON COLUMN continuous_volume.i7 IS
'Where applicable, the volume in interval 7 (06:00-07:00).';

COMMENT ON COLUMN continuous_volume.i8 IS
'Where applicable, the volume in interval 8 (07:00-08:00).';

COMMENT ON COLUMN continuous_volume.i9 IS
'Where applicable, the volume in interval 9 (08:00-09:00).';

COMMENT ON COLUMN continuous_volume.i10 IS
'Where applicable, the volume in interval 10 (09:00-10:00).';

COMMENT ON COLUMN continuous_volume.i11 IS
'Where applicable, the volume in interval 11 (10:00-11:00).';

COMMENT ON COLUMN continuous_volume.i12 IS
'Where applicable, the volume in interval 12 (11:00-12:00).';

COMMENT ON COLUMN continuous_volume.i13 IS
'Where applicable, the volume in interval 13 (12:00-13:00).';

COMMENT ON COLUMN continuous_volume.i14 IS
'Where applicable, the volume in interval 14 (13:00-14:00).';

COMMENT ON COLUMN continuous_volume.i15 IS
'Where applicable, the volume in interval 15 (14:00-15:00).';

COMMENT ON COLUMN continuous_volume.i16 IS
'Where applicable, the volume in interval 16 (15:00-16:00).';

COMMENT ON COLUMN continuous_volume.i17 IS
'Where applicable, the volume in interval 17 (16:00-17:00).';

COMMENT ON COLUMN continuous_volume.i18 IS
'Where applicable, the volume in interval 18 (17:00-18:00).';

COMMENT ON COLUMN continuous_volume.i19 IS
'Where applicable, the volume in interval 19 (18:00-19:00).';

COMMENT ON COLUMN continuous_volume.i20 IS
'Where applicable, the volume in interval 20 (19:00-20:00).';

COMMENT ON COLUMN continuous_volume.i21 IS
'Where applicable, the volume in interval 21 (20:00-21:00).';

COMMENT ON COLUMN continuous_volume.i22 IS
'Where applicable, the volume in interval 22 (21:00-22:00).';

COMMENT ON COLUMN continuous_volume.i23 IS
'Where applicable, the volume in interval 23 (22:00-23:00).';

COMMENT ON COLUMN continuous_volume.i24 IS
'Where applicable, the volume in interval 24 (23:00-24:00).';


COMMIT;
