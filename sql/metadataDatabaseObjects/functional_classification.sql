-- https://www.dot.ny.gov/gisapps/functional-class-maps

CREATE TYPE functional_classification_code AS ENUM (
  '1', '2', '3', '4', '5', '6', '7',         -- FHWA Codes
  '01', '02', '04', '06', '07', '08', '09',  -- NYS Codes Rural
  '11', '12', '14', '16', '17', '18', '19'   -- NYS Codes Urban
);

CREATE TYPE functional_classification_distinctor AS ENUM (
  'NYS Codes Urban', 'NYS Codes Rural', 'FHWA Codes'
);

CREATE TABLE functional_classification_code_descriptions (
  code         functional_classification_code,
  distinctor   functional_classification_distinctor,
  description  VARCHAR(64)
) WITH (fillfactor = 100);


INSERT INTO functional_classification_code_descriptions (code, distinctor, description)
VALUES 
  ('1', 'FHWA Codes', 'Principal Arterial - Interstate'),
  ('2', 'FHWA Codes', 'Principal Arterial - Other Freeway/Expressway'),
  ('3', 'FHWA Codes', 'Principal Arterial - Other'),
  ('4', 'FHWA Codes', 'Minor Arterial'),
  ('5', 'FHWA Codes', 'Major Collector'),
  ('6', 'FHWA Codes', 'Minor Collector'),
  ('7', 'FHWA Codes', 'Local'),

  ('01', 'NYS Codes Rural', 'Principal Arterial - Interstate'),
  ('02', 'NYS Codes Rural', 'Principal Arterial - Other Freeway/Expressway'),
  ('04', 'NYS Codes Rural', 'Principal Arterial - Other'),
  ('06', 'NYS Codes Rural', 'Minor Arterial'),
  ('07', 'NYS Codes Rural', 'Major Collector'),
  ('08', 'NYS Codes Rural', 'Minor Collector'),
  ('09', 'NYS Codes Rural', 'Local'),

  ('11', 'NYS Codes Urban', 'Principal Arterial - Interstate'),
  ('12', 'NYS Codes Urban', 'Principal Arterial - Other Freeway/Expressway'),
  ('14', 'NYS Codes Urban', 'Principal Arterial - Other'),
  ('16', 'NYS Codes Urban', 'Minor Arterial'),
  ('17', 'NYS Codes Urban', 'Major Collector'),
  ('18', 'NYS Codes Urban', 'Minor Collector'),
  ('19', 'NYS Codes Urban', 'Local')
;
