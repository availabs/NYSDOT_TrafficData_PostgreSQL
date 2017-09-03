BEGIN;


-- https://www.dot.ny.gov/divisions/engineering/technical-services/hds-respository/Tab/NYSDOT_2016_Seasonal_Adjustment_Factors.pdf


DROP DOMAIN IF EXISTS nysdot_seasonal_adjustment_factor_group CASCADE;

CREATE DOMAIN nysdot_seasonal_adjustment_factor_group AS SMALLINT
CHECK (VALUE IN (30, 40, 60));

COMMENT ON DOMAIN nysdot_seasonal_adjustment_factor_group IS
'Factor Group determines the set of seasonal factors to apply. Factor Groups are 30, 40, or 60 only.';



DROP TABLE IF EXISTS nysdot_seasonal_adjustment_factor_group_descriptions CASCADE;

CREATE TABLE nysdot_seasonal_adjustment_factor_group_descriptions (
  factor_group  nysdot_seasonal_adjustment_factor_group PRIMARY KEY,
  description   VARCHAR(16) UNIQUE
) WITH (fillfactor = 100);

INSERT INTO nysdot_seasonal_adjustment_factor_group_descriptions
VALUES
  (30, 'urban'),
  (40, 'suburban'),
  (60, 'recreational')
;


COMMIT;

