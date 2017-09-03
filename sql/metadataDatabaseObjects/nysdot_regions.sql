BEGIN;


-- Source: https://www.dot.ny.gov/regional-offices


DROP DOMAIN IF EXISTS nysdot_region CASCADE;

CREATE DOMAIN nysdot_region AS SMALLINT
CHECK (VALUE BETWEEN 1 AND 11);

COMMENT ON DOMAIN nysdot_region IS
'The NYSDOT Region numbers.';



DROP TABLE IF EXISTS nysdot_region_names CASCADE;

CREATE TABLE nysdot_region_names (
  region  nysdot_region PRIMARY KEY,
  name    VARCHAR(64) UNIQUE
) WITH (fillfactor = 100);


INSERT INTO nysdot_region_names (region, name)
VALUES
  (1,  'Capital District'),
  (2,  'Mohawk Valley'),
  (3,  'Central New York'),
  (4,  'Genesee Valley'),
  (5,  'Western New York'),
  (6,  'Southern Tier/Central New York'),
  (7,  'North Country'),
  (8,  'Hudson Valley'),
  (9,  'Southern Tier'),
  (10, 'Long Island'),
  (11, 'New York City ')
;

COMMENT ON TABLE nysdot_region_names IS 'NYS DOT Regions.';

COMMENT ON COLUMN nysdot_region_names.region IS
'The Region Number, a number 1-11 representing a NYSDOT Region.';

COMMENT ON COLUMN nysdot_region_names.name IS
'Name of the NYSDOT Region.';


COMMIT;

