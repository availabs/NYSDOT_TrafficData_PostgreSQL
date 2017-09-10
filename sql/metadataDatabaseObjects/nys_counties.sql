-- https://www.dot.ny.gov/divisions/engineering/technical-services/hds-respository/Traffic%20Data%20Report%202011%20Appendix%20D%20-%20NYSDOT%20Regions%20and%20County%20Codes.pdf

BEGIN;

DROP TABLE IF EXISTS nys_counties CASCADE;

CREATE TABLE nys_counties (
  region VARCHAR(2),
  name VARCHAR,
  rc   VARCHAR(2) PRIMARY KEY,
  fips VARCHAR(3)
) WITH (fillfactor=100, autovacuum_enabled=false);

INSERT INTO nys_counties
VALUES
  ('1',  'Albany',       '11',  '001'),
  ('1',  'Essex',        '12',  '031'),
  ('1',  'Greene',       '13',  '039'),
  ('1',  'Rensselaer',   '14',  '083'),
  ('1',  'Saratoga',     '15',  '091'),
  ('1',  'Schenectady',  '16',  '093'),
  ('1',  'Warren',       '17',  '113'),
  ('1',  'Washington',   '18',  '115'),
  ('2',  'Fulton',       '21',  '035'),
  ('2',  'Hamilton',     '22',  '041'),
  ('2',  'Herkimer',     '23',  '043'),
  ('2',  'Madison',      '24',  '053'),
  ('2',  'Montgomery',   '25',  '057'),
  ('2',  'Oneida',       '26',  '065'),
  ('3',  'Cayuga',       '31',  '011'),
  ('3',  'Cortland',     '32',  '023'),
  ('3',  'Onondaga',     '33',  '067'),
  ('3',  'Oswego',       '34',  '075'),
  ('3',  'Seneca',       '35',  '099'),
  ('3',  'Tompkins',     '36',  '109'),
  ('4',  'Genesee',      '41',  '037'),
  ('4',  'Livingston',   '42',  '051'),
  ('4',  'Monroe',       '43',  '055'),
  ('4',  'Ontario',      '44',  '069'),
  ('4',  'Orleans',      '45',  '073'),
  ('4',  'Wayne',        '47',  '117'),
  ('4',  'Wyoming',      '46',  '121'),
  ('5',  'Cattaraugus',  '51',  '009'),
  ('5',  'Chautauqua',   '52',  '013'),
  ('5',  'Erie',         '53',  '029'),
  ('5',  'Niagara',      '54',  '063'),
  ('6',  'Allegany',     '61',  '003'),
  ('6',  'Chemung',      '62',  '015'),
  ('6',  'Schuyler',     '63',  '097'),
  ('6',  'Steuben',      '64',  '101'),
  ('6',  'Yates',        '66',  '123'),
  ('7',  'Clinton',      '71',  '019'),
  ('7',  'Franklin',     '72',  '033'),
  ('7',  'Jefferson',    '73',  '045'),
  ('7',  'Lewis',        '74',  '049'),
  ('7',  'St. Lawrence', '75',  '089'),
  ('8',  'Columbia',     '81',  '021'),
  ('8',  'Dutchess',     '82',  '027'),
  ('8',  'Orange',       '83',  '071'),
  ('8',  'Putnam',       '84',  '079'),
  ('8',  'Rockland',     '85',  '087'),
  ('8',  'Ulster',       '86',  '111'),
  ('8',  'Westchester',  '87',  '119'),
  ('9',  'Broome',       '91',  '007'),
  ('9',  'Chenango',     '92',  '017'),
  ('9',  'Delaware',     '93',  '025'),
  ('9',  'Otsego',       '94',  '077'),
  ('9',  'Schoharie',    '95',  '095'),
  ('9',  'Sullivan',     '96',  '105'),
  ('9',  'Tioga',        '97',  '107'),
  ('10', 'Nassau',       '03',  '059'),
  ('10', 'Suffolk',      '07',  '103'),
  ('11', 'Bronx',        '01',  '005'),
  ('11', 'Kings',        '02',  '047'),
  ('11', 'New York',     '04',  '061'),
  ('11', 'Queens',       '05',  '081'),
  ('11', 'Richmond',     '06',  '085')
;

COMMIT;

VACUUM ANALYZE nys_counties;
