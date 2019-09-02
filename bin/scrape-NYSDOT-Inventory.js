#!/usr/bin/env node

/* eslint no-console: 0 */

const { join } = require('path');

const { execSync } = require('child_process');

const { sync: mkdirpSync } = require('mkdirp');

const VERSION = '2016';

const dataDirRoot = join(__dirname, '../data/inventory/');

const urlBase =
  'https://www.dot.ny.gov/divisions/engineering/technical-services/hds-respository/';

const countyURLs = {
  Albany: `HighwayInventory-AlbanyCounty-${VERSION}.zip`,
  Allegany: `HighwayInventory-AlleganyCounty-${VERSION}.zip`,
  Bronx: `HighwayInventory-BronxCounty-${VERSION}.zip`,
  Broome: `HighwayInventory-BroomeCounty-${VERSION}.zip`,
  Cattaraugus: `HighwayInventory-CattaraugusCounty-${VERSION}.zip`,
  Cayuga: `HighwayInventory-CayugaCounty-${VERSION}.zip`,
  Chautauqua: `HighwayInventory-ChautauquaCounty-${VERSION}.zip`,
  Chemung: `HighwayInventory-ChemungCounty-${VERSION}.zip`,
  Chenango: `HighwayInventory-ChenangoCounty-${VERSION}.zip`,
  Clinton: `HighwayInventory-ClintonCounty-${VERSION}.zip`,
  Columbia: `HighwayInventory-ColumbiaCounty-${VERSION}.zip`,
  Cortland: `HighwayInventory-CortlandCounty-${VERSION}.zip`,
  Delaware: `HighwayInventory-DelawareCounty-${VERSION}.zip`,
  Dutchess: `HighwayInventory-DutchessCounty-${VERSION}.zip`,
  Erie: `HighwayInventory-ErieCounty-${VERSION}.zip`,
  Essex: `HighwayInventory-EssexCounty-${VERSION}.zip`,
  Franklin: `HighwayInventory-FranklinCounty-${VERSION}.zip`,
  Fulton: `HighwayInventory-FultonCounty-${VERSION}.zip`,
  Genesee: `HighwayInventory-GeneseeCounty-${VERSION}.zip`,
  Greene: `HighwayInventory-GreeneCounty-${VERSION}.zip`,
  Hamilton: `HamiltonCounty-${VERSION}.zip`,
  Herkimer: `HerkimerCounty-${VERSION}.zip`,
  Jefferson: `HighwayInventory-JeffersonCounty-${VERSION}.zip`,
  Kings: `HighwayInventory-KingsCounty-${VERSION}.zip`,
  Lewis: `HighwayInventory-LewisCounty-${VERSION}.zip`,
  Livingston: `HighwayInventory-LivingstonCounty-${VERSION}.zip`,
  Madison: `HighwayInventory-MadisonCounty-${VERSION}.zip`,
  Monroe: `HighwayInventory-MonroeCounty-${VERSION}.zip`,
  Montgomery: `HighwayInventory-MontgomeryCounty-${VERSION}.zip`,
  Nassau: `HighwayInventory-NassauCounty-${VERSION}.zip`,
  NewYork: `HighwayInventory-NewYorkCounty-${VERSION}.zip`,
  Niagara: `HighwayInventory-NiagaraCounty-${VERSION}.zip`,
  Oneida: `HighwayInventory-OneidaCounty-${VERSION}.zip`,
  Onondaga: `HighwayInventory-OnondagaCounty-${VERSION}.zip`,
  Ontario: `HighwayInventory-OntarioCounty-${VERSION}.zip`,
  Orange: `HighwayInventory-OrangeCounty-${VERSION}.zip`,
  Orleans: `HighwayInventory-OrleansCounty-${VERSION}.zip`,
  Oswego: `HighwayInventory-OswegoCounty-${VERSION}.zip`,
  Otsego: `HighwayInventory-OtsegoCounty-${VERSION}.zip`,
  Putnam: `HighwayInventory-PutnamCounty-${VERSION}.zip`,
  Queens: `HighwayInventory-QueensCounty-${VERSION}.zip`,
  Rensselaer: `HighwayInventory-RensselaerCounty-${VERSION}.zip`,
  Richmond: `HighwayInventory-RichmondCounty-${VERSION}.zip`,
  Rockland: `HighwayInventory-RocklandCounty-${VERSION}.zip`,
  Saratoga: `HighwayInventory-SaratogaCounty-${VERSION}.zip`,
  Schenectady: `HighwayInventory-SchenectadyCounty-${VERSION}.zip`,
  Schoharie: `HighwayInventory-SchoharieCounty-${VERSION}.zip`,
  Schuyler: `HighwayInventory-SchuylerCounty-${VERSION}.zip`,
  Seneca: `HighwayInventory-SenecaCounty-${VERSION}.zip`,
  Steuben: `HighwayInventory-SteubenCounty-${VERSION}.zip`,
  SaintLawrence: `HighwayInventory-SaintLawrenceCounty-${VERSION}.zip`,
  Suffolk: `HighwayInventory-SuffolkCounty-${VERSION}.zip`,
  Sullivan: `HighwayInventory-SullivanCounty-${VERSION}.zip`,
  Tioga: `HighwayInventory-TiogaCounty-${VERSION}.zip`,
  Tompkins: `HighwayInventory-TompkinsCounty-${VERSION}.zip`,
  Ulster: `HighwayInventory-UlsterCounty-${VERSION}.zip`,
  Warren: `HighwayInventory-WarrenCounty-${VERSION}.zip`,
  Washington: `HighwayInventory-WashingtonCounty-${VERSION}.zip`,
  Wayne: `HighwayInventory-WayneCounty-${VERSION}.zip`,
  Westchester: `HighwayInventory-WestchesterCounty-${VERSION}.zip`,
  Wyoming: `HighwayInventory-WyomingCounty-${VERSION}.zip`,
  Yates: `HighwayInventory-YatesCounty-${VERSION}.zip`
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
