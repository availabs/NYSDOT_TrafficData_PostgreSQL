BEGIN;


-- https://www.dot.ny.gov/divisions/engineering/technical-services/highway-data-services/hdsb/repository/Field_Definitions_CC%20Formats.pdf


DROP DOMAIN IF EXISTS nysdot_road_direction_code CASCADE;

CREATE DOMAIN nysdot_road_direction_code AS SMALLINT 
CHECK ((VALUE = 99) OR (VALUE = -99));



DROP TABLE IF EXISTS nysdot_road_direction_code_descriptions CASCADE;

CREATE TABLE nysdot_road_direction_code_descriptions (
  code         nysdot_road_direction_code PRIMARY KEY,
  description  VARCHAR(100) UNIQUE
) WITH (fillfactor = 100);

COMMENT ON TABLE nysdot_road_direction_code_descriptions IS
'The direction of the data for each record.';

INSERT INTO nysdot_road_direction_code_descriptions (code, description)
VALUES 
  ( 99,  '99 represents data traveling from the Begin Desc to the End Desc, or primary direction'),
  (-99, '-99 represents data traveling from the End Desc to the Begin Desc, or non‐primary direction.')
;


COMMIT;

