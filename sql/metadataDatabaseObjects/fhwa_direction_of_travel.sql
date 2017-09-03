-- https://www.fhwa.dot.gov/policyinformation/tmguide/tmg_2013/traffic-monitoring-formats.cfm
CREATE DOMAIN fhwa_direction_of_travel_code AS SMALLINT
CHECK (VALUE BETWEEN 0 AND 9);


CREATE TABLE fhwa_direction_of_travel_code_descriptions (
  code         fhwa_direction_of_travel_code,
  description  VARCHAR(80)
) WITH (fillfactor = 100);


INSERT INTO fhwa_direction_of_travel_code_descriptions (code, description)
VALUES
  (1,	'North'),
  (2,	'Northeast'),
  (3,	'East'),
  (4,	'Southeast'),
  (5,	'South'),
  (6,	'Southwest'),
  (7,	'West'),
  (8,	'Northwest'),
  (9,	'North-South or Northeast-Southwest combined (volume stations only)'),
  (0,	'East-West or Southeast-Northwest combined (volume stations only)')
;


COMMENT ON DOMAIN fhwa_direction_of_travel_code IS 
'The direction of travel of the main roadway.'
