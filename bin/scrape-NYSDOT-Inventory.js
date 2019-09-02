#!/usr/bin/env node

/* eslint no-console: 0 */

const { join } = require('path');

const { execSync } = require('child_process');

const { sync: mkdirpSync } = require('mkdirp');

const VERSION = '2014';

const dataDirRoot = join(__dirname, '../data/inventory/');

const urlBase =
  'https://www.dot.ny.gov/divisions/engineering/technical-services/hds-respository/';

const countyURLs = {
  Albany: 'HighwayInventory-AlbanyCounty-2014.zip',
  Allegany: 'HighwayInventory-AlleganyCounty-2014.zip',
  Bronx: 'HighwayInventory-BronxCounty-2014.zip',
  Broome: 'HighwayInventory-BroomeCounty-2014.zip',
  Cattaraugus: 'HighwayInventory-CattaraugusCounty-2014.zip',
  Cayuga: 'HighwayInventory-CayugaCounty-2014.zip',
  Chautauqua: 'HighwayInventory-ChautauquaCounty-2014.zip',
  Chemung: 'HighwayInventory-ChemungCounty-2014.zip',
  Chenango: 'HighwayInventory-ChenangoCounty-2014.zip',
  Clinton: 'HighwayInventory-ClintonCounty-2014.zip',
  Columbia: 'HighwayInventory-ColumbiaCounty-2014.zip',
  Cortland: 'HighwayInventory-CortlandCounty-2014.zip',
  Delaware: 'HighwayInventory-DelawareCounty-2014.zip',
  Dutchess: 'HighwayInventory-DutchessCounty-2014.zip',
  Erie: 'HighwayInventory-ErieCounty-2014.zip',
  Essex: 'HighwayInventory-EssexCounty-2014.zip',
  Franklin: 'HighwayInventory-FranklinCounty-2014.zip',
  Fulton: 'HighwayInventory-FultonCounty-2014.zip',
  Genesee: 'HighwayInventory-GeneseeCounty-2014.zip',
  Greene: 'HighwayInventory-GreeneCounty-2014.zip',
  Hamilton: 'HamiltonCounty-2014.zip',
  Herkimer: 'HerkimerCounty-2014.zip',
  Jefferson: 'HighwayInventory-JeffersonCounty-2014.zip',
  Kings: 'HighwayInventory-KingsCounty-2014.zip',
  Lewis: 'HighwayInventory-LewisCounty-2014.zip',
  Livingston: 'HighwayInventory-LivingstonCounty-2014.zip',
  Madison: 'HighwayInventory-MadisonCounty-2014.zip',
  Monroe: 'HighwayInventory-MonroeCounty-2014.zip',
  Montgomery: 'HighwayInventory-MontgomeryCounty-2014.zip',
  Nassau: 'HighwayInventory-NassauCounty-2014.zip',
  NewYork: 'HighwayInventory-NewYorkCounty-2014.zip',
  Niagara: 'HighwayInventory-NiagaraCounty-2014.zip',
  Oneida: 'HighwayInventory-OneidaCounty-2014.zip',
  Onondaga: 'HighwayInventory-OnondagaCounty-2014.zip',
  Ontario: 'HighwayInventory-OntarioCounty-2014.zip',
  Orange: 'HighwayInventory-OrangeCounty-2014.zip',
  Orleans: 'HighwayInventory-OrleansCounty-2014.zip',
  Oswego: 'HighwayInventory-OswegoCounty-2014.zip',
  Otsego: 'HighwayInventory-OtsegoCounty-2014.zip',
  Putnam: 'HighwayInventory-PutnamCounty-2014.zip',
  Queens: 'HighwayInventory-QueensCounty-2014.zip',
  Rensselaer: 'HighwayInventory-RensselaerCounty-2014.zip',
  Richmond: 'HighwayInventory-RichmondCounty-2014.zip',
  Rockland: 'HighwayInventory-RocklandCounty-2014.zip',
  Saratoga: 'HighwayInventory-SaratogaCounty-2014.zip',
  Schenectady: 'HighwayInventory-SchenectadyCounty-2014.zip',
  Schoharie: 'HighwayInventory-SchoharieCounty-2014.zip',
  Schuyler: 'HighwayInventory-SchuylerCounty-2014.zip',
  Seneca: 'HighwayInventory-SenecaCounty-2014.zip',
  Steuben: 'HighwayInventory-SteubenCounty-2014.zip',
  SaintLawrence: 'HighwayInventory-SaintLawrenceCounty-2014.zip',
  Suffolk: 'HighwayInventory-SuffolkCounty-2014.zip',
  Sullivan: 'HighwayInventory-SullivanCounty-2014.zip',
  Tioga: 'HighwayInventory-TiogaCounty-2014.zip',
  Tompkins: 'HighwayInventory-TompkinsCounty-2014.zip',
  Ulster: 'HighwayInventory-UlsterCounty-2014.zip',
  Warren: 'HighwayInventory-WarrenCounty-2014.zip',
  Washington: 'HighwayInventory-WashingtonCounty-2014.zip',
  Wayne: 'HighwayInventory-WayneCounty-2014.zip',
  Westchester: 'HighwayInventory-WestchesterCounty-2014.zip',
  Wyoming: 'HighwayInventory-WyomingCounty-2014.zip',
  Yates: 'HighwayInventory-YatesCounty-2014.zip'
};

Object.entries(countyURLs).forEach(([county, basename]) => {
  const downloadDir = join(dataDirRoot, county, VERSION);

  const url = `${urlBase}/${basename}`;
  const zipFilePath = join(downloadDir, basename);

  try {
    mkdirpSync(downloadDir);

    console.log(`Downloading ${basename}`);

    execSync(`curl -k -o '${zipFilePath}' '${url}'`);
  } catch (err) {
    execSync(`rm -rf ${downloadDir}`);
  }
});
