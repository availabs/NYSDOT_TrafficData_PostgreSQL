BEGIN;


-- https://www.dot.ny.gov/divisions/engineering/technical-services/highway-data-services/hdsb/repository/Field_Definitions_CC%20Formats.pdf


DROP DOMAIN IF EXISTS nysdot_one_way_road_flag CASCADE;

CREATE DOMAIN nysdot_one_way_road_flag AS CHAR(1)
CHECK ((VALUE = 'Y') OR (VALUE IS NULL));



DROP TABLE IF EXISTS nysdot_one_way_road_flag_descriptions CASCADE;

CREATE TABLE nysdot_one_way_road_flag_descriptions (
  flag_value    nysdot_one_way_road_flag UNIQUE,
  description   VARCHAR(16) UNIQUE
) WITH (fillfactor = 100);

COMMENT ON TABLE nysdot_one_way_road_flag_descriptions IS
'Indicates if the segment is a one‐way road. ‘Y’ for one‐way or null for bi‐directional.';

INSERT INTO nysdot_one_way_road_flag_descriptions (flag_value, description)
VALUES
  ('Y', 'one-way'),
  (NULL, 'bi-directional')
;


COMMIT;

