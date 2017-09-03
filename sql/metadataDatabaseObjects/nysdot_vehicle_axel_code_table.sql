BEGIN;


-- https://www.dot.ny.gov/divisions/engineering/technical-services/highway-data-services/hdsb/repository/Field_Definitions_SC%20Formats.pdf


DROP DOMAIN IF EXISTS nysdot_vehicle_axle_code CASCADE;

CREATE DOMAIN nysdot_vehicle_axle_code AS SMALLINT 
CHECK ((VALUE = 1) OR (VALUE = 2));



DROP TABLE IF EXISTS nysdot_vehicle_axle_code_descriptions CASCADE;

CREATE TABLE nysdot_vehicle_axle_code_descriptions (
  code         nysdot_vehicle_axle_code PRIMARY KEY,
  description  VARCHAR(128) UNIQUE
) WITH (fillfactor = 100);

INSERT INTO nysdot_vehicle_axle_code_descriptions (code, description)
VALUES 
  (1, 'Vehicle Count'),
  (2, 'Axles/2 Count')
;

COMMENT ON DOMAIN nysdot_vehicle_axle_code IS
'Vehicle/Axle code in Volume files: 1=Vehicle count 2=Axles/2 count.';

COMMENT ON TABLE nysdot_vehicle_axle_code_descriptions IS
'Descriptions for the NYSDOT vehicle_axle_codes.';


COMMIT;

