#!/usr/bin/env node

/* eslint no-console: 0 */

const { join } = require('path');

const { execSync } = require('child_process');

const { sync: mkdirpSync } = require('mkdirp');

const VERSION = '2016';

const dataDirRoot = join(__dirname, '../data/shapefile/');

const urlBase = 'https://www.dot.ny.gov/divisions/engineering';

// https://www.dot.ny.gov/divisions/engineering/technical-services/highway-data-services/
const shapefileURLBase = `${urlBase}/applications/traffic-data-viewer/traffic-data-viewer-repository`;

const shapefileURLs = {
  aadt_shp: `TDV_Shapefile_AADT_${VERSION}.zip`,

  short_counts_shp: `TDV_Shapefile_Short_Counts_${VERSION}.zip`,

  continuous_counts_shp: `TDV_Shapefile_Continuous_Counts_${VERSION}.zip`
};

Object.entries(shapefileURLs).forEach(([tableName, basename]) => {
  console.log(tableName, basename);
  const downloadDir = join(dataDirRoot, `${tableName}`, VERSION);

  const url = `${shapefileURLBase}/${basename}`;
  const zipFilePath = join(downloadDir, basename);

  try {
    mkdirpSync(downloadDir);

    console.log(`Downloading ${basename}`);

    execSync(`curl -k -o '${zipFilePath}' '${url}'`);
  } catch (err) {
    execSync(`rm -rf ${downloadDir}`);
  }
});
