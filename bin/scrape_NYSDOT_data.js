#!/usr/bin/env node

// https://www.linuxquestions.org/questions/programming-9/need-help-using-sed-to-remove-preceding-and-trailing-spaces-in-csv-832563/

/* eslint no-console: 0 */

const { join } = require('path');


const { execSync } = require('child_process');
const { existsSync } = require('fs');
const { sync: mkdirpSync } = require('mkdirp');

const VERSIONS = ['2010', '2011', '2012', '2013', '2014', '2015'];

const regionTemplateRegExp = /==REGION==/;

const dataDirRoot = join(__dirname, '../data/');

const regions = ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11'];

const urlBase = 'https://www.dot.ny.gov/divisions/engineering';


VERSIONS.forEach((VERSION) => {
  // https://www.dot.ny.gov/divisions/engineering/technical-services/highway-data-services/
  const shapefileURLBase = `${urlBase}/applications/traffic-data-viewer/traffic-data-viewer-repository`;

  const shapefileURLs = {
    aadt_shp: `TDV_Shapefile_AADT_${VERSION}.zip`,

    short_counts_shp: `TDV_Shapefile_Short_Counts_${VERSION}.zip`,

    continuous_counts_shp: `TDV_Shapefile_Continuous_Counts_${VERSION}.zip`,
  };


  // https://www.dot.ny.gov/divisions/engineering/technical-services/highway-data-services/hdsb
  const csvURLBase = `${urlBase}/technical-services/highway-data-services/hdsb/repository`;

  const csvURLs = {
    continuous_vehicle_classification: `CC_CLASS_==REGION==_${VERSION}.zip`,

    continuous_volume: `CC_VOL_==REGION==_${VERSION}.zip`,

    short_count_vehicle_classification: `SC_Class_Data_==REGION==_${VERSION}.zip`,

    short_count_volume: `SC_Volume_Data_==REGION==_${VERSION}.zip`,

    short_count_speed: `SC_Speed_Data_==REGION==_${VERSION}.zip`,

    average_weekday_vehicle_classification: `SC_CLASS_AVGWD_==REGION==_${VERSION}.zip`,

    average_weekday_volume: `SC_Volume_AVGWD_==REGION==_${VERSION}.zip`,

    average_weekday_speed: `SC_Speed_AVGWD_==REGION==_${VERSION}.zip`,
  };


  Object.entries(shapefileURLs).forEach(([tableName, basename]) => {
    console.log(tableName, basename);
    const dataDir = join(dataDirRoot, 'shapefile');

    const downloadDir = join(dataDir, `${tableName}`, VERSION);

    const url = `${shapefileURLBase}/${basename}`;
    const filepath = join(downloadDir, basename);

    if (existsSync(filepath)) {
      console.log(`===== Skipping ${basename}. =====`);
    } else {
      try {
        mkdirpSync(downloadDir);

        console.log(`Downloading ${basename}`);

        execSync(`curl -k -o '${filepath}' '${url}'`);
      } catch (err) {
        execSync(`rm -rf ${downloadDir}`);
      }
    }
  });


  Object.entries(csvURLs).forEach(([tableName, basenameTemplate]) => {
    const dataDir = join(dataDirRoot, 'csv');

    for (let i = 0; i < regions.length; i += 1) {
      const region = (basenameTemplate.match(/^CC_/)) ? +regions[i] : regions[i];

      const downloadDir = join(dataDir, `${tableName}`, VERSION, `R${regions[i]}`);
      mkdirpSync(downloadDir);

      const basename = basenameTemplate.replace(regionTemplateRegExp, `R${region}`);
      const url = `${csvURLBase}/${basename}`;
      const filepath = join(downloadDir, basename);

      if (existsSync(filepath)) {
        console.log(`===== Skipping ${basename}. =====`);
      } else {
        console.log(`Downloading ${basename}`);

        try {
          execSync(`curl -k -o '${filepath}' '${url}'`);

          execSync(`unzip ${filepath}`, { cwd: downloadDir });

          execSync('sed -i \'s/ *, */,/g\' *.csv', { cwd: downloadDir });

          execSync(`rm -f ${filepath}`, { cwd: downloadDir });

          execSync(`zip ${filepath} *.csv`, { cwd: downloadDir });

          execSync('rm -f *.csv', { cwd: downloadDir });
        } catch (err) {
          execSync(`rm -rf ${downloadDir}`);
        }
      }
    }
  });
});
