BEGIN;


-- https://www.dot.ny.gov/gisapps/nysdot_functional-class-maps


DROP DOMAIN IF EXISTS nysdot_functional_classification_code CASCADE;

CREATE DOMAIN nysdot_functional_classification_code AS SMALLINT
CHECK (
  VALUE IN (
    1, 2, 4, 6, 7, 8, 9,         -- NYS Codes Rural
    11, 12, 14, 16, 17, 18, 19   -- NYS Codes Urban
  )
);


DROP TYPE IF EXISTS nysdot_functional_classification_distinctor CASCADE;

CREATE TYPE nysdot_functional_classification_distinctor AS ENUM (
  'NYS Codes Urban', 'NYS Codes Rural'
);


DROP TABLE IF EXISTS nysdot_functional_classification_code_descriptions CASCADE;

CREATE TABLE nysdot_functional_classification_code_descriptions (
  code         nysdot_functional_classification_code PRIMARY KEY,
  distinctor   nysdot_functional_classification_distinctor,
  description  VARCHAR(64)
) WITH (fillfactor = 100);


INSERT INTO nysdot_functional_classification_code_descriptions (code, distinctor, description)
VALUES 
  (1, 'NYS Codes Rural', 'Principal Arterial - Interstate'),
  (2, 'NYS Codes Rural', 'Principal Arterial - Other Freeway/Expressway'),
  (4, 'NYS Codes Rural', 'Principal Arterial - Other'),
  (6, 'NYS Codes Rural', 'Minor Arterial'),
  (7, 'NYS Codes Rural', 'Major Collector'),
  (8, 'NYS Codes Rural', 'Minor Collector'),
  (9, 'NYS Codes Rural', 'Local'),

  (11, 'NYS Codes Urban', 'Principal Arterial - Interstate'),
  (12, 'NYS Codes Urban', 'Principal Arterial - Other Freeway/Expressway'),
  (14, 'NYS Codes Urban', 'Principal Arterial - Other'),
  (16, 'NYS Codes Urban', 'Minor Arterial'),
  (17, 'NYS Codes Urban', 'Major Collector'),
  (18, 'NYS Codes Urban', 'Minor Collector'),
  (19, 'NYS Codes Urban', 'Local')
;


COMMIT;

