-- https://www.dot.ny.gov/divisions/engineering/technical-services/highway-data-services/hdsb/repository/Field_Definitions_SC%20Formats.pdf
CREATE DOMAIN vehicle_axle_code AS SMALLINT 
CHECK ((VALUE = 1) OR (VALUE = 2));

CREATE TABLE vehicle_axle_code_descriptions (
  code         vehicle_axle_code PRIMARY KEY,
  description  VARCHAR(128)
) WITH (fillfactor = 100);


INSERT INTO vehicle_axle_code_descriptions (code, description)
VALUES 
  (1, 'Vehicle Count'),
  (2, 'Axles/2 Count')
;

COMMENT ON DOMAIN vehicle_axle_code IS
'Vehicle/Axle code in Volume files: 1=Vehicle count 2=Axles/2 count.';

COMMENT ON TABLE vehicle_axle_code IS
'Descriptions for the NYSDOT vehicle_axle_codes.';

