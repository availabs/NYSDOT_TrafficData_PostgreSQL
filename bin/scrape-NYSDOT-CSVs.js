#!/usr/bin/env node

// https://www.linuxquestions.org/questions/programming-9/need-help-using-sed-to-remove-preceding-and-trailing-spaces-in-csv-832563/

/* eslint no-console: 0 */

const { join } = require('path');

const { execSync } = require('child_process');
const { existsSync, readdirSync } = require('fs');

const { sync: mkdirpSync } = require('mkdirp');

const VERSIONS = ['2010', '2011', '2012', '2013', '2014', '2015'];

const regionTemplateRegExp = /==REGION==/;

const dataDirRoot = join(__dirname, '../data/');

const regions = [
  '01',
  '02',
  '03',
  '04',
  '05',
  '06',
  '07',
  '08',
  '09',
  '10',
  '11'
];

const urlBase = 'https://www.dot.ny.gov/divisions/engineering';

VERSIONS.forEach(VERSION => {
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

    average_weekday_speed: `SC_Speed_AVGWD_==REGION==_${VERSION}.zip`
  };

  Object.entries(csvURLs).forEach(([tableName, basenameTemplate]) => {
    const dataDir = join(dataDirRoot, 'csv');

    for (let i = 0; i < regions.length; i += 1) {
      const region = basenameTemplate.match(/^CC_/) ? +regions[i] : regions[i];

      const downloadDir = join(
        dataDir,
        `${tableName}`,
        VERSION,
        `R${regions[i]}`
      );
      mkdirpSync(downloadDir);

      const basename = basenameTemplate.replace(
        regionTemplateRegExp,
        `R${region}`
      );
      const url = `${csvURLBase}/${basename}`;
      const zipFilePath = join(downloadDir, basename);

      if (existsSync(zipFilePath)) {
        console.log(`===== Skipping ${basename}. =====`);
      } else {
        console.log(`Downloading ${basename}`);

        try {
          execSync(`curl -k -o '${zipFilePath}' '${url}'`);

          execSync(`unzip -o ${zipFilePath}`, { cwd: downloadDir });

          // Get the name of the extracted CSV.
          const csvFileName = readdirSync(downloadDir).filter(f =>
            f.match(/csv$/i)
          )[0];

          // Trim whitespace from the columns.
          execSync(`sed -i 's/ *, */,/g' '${csvFileName}'`, {
            cwd: downloadDir
          });

          // Remove Windows line endings.
          // https://stackoverflow.com/a/44318366/3970755
          execSync(`sed -i 's/\r//' '${csvFileName}'`, { cwd: downloadDir });

          // Fix the columns here either side of an '/' are many whitespaces apart.
          execSync(`sed -i 's# */ *# / #g' '${csvFileName}'`, {
            cwd: downloadDir
          });

          // Some CSVs had a line with 'rows selected' in it.
          execSync(`sed -i '/rows selected/d' '${csvFileName}'`, {
            cwd: downloadDir
          });

          // Some CSVs had a line with ---,---,
          //   So we delete rows that have no alpha-numeric characters
          execSync(`sed -i '/[A-Za-Z0-9]/!d' '${csvFileName}'`, {
            cwd: downloadDir
          });

          // Remove duplicate rows to fix the problem of
          //    the header showing up at the beginning and the end of a file.
          // https://stackoverflow.com/a/20639730/3970755
          execSync(
            `cat -n '${csvFileName}' | sort -uk2 | sort -nk1 | cut -f2- > no_dupes.csv`,
            { cwd: downloadDir }
          );

          execSync(`mv no_dupes.csv '${csvFileName}'`, { cwd: downloadDir });

          execSync(`rm -f ${zipFilePath}`, { cwd: downloadDir });

          execSync(`zip ${zipFilePath} '${csvFileName}'`, { cwd: downloadDir });

          execSync(`rm -f '${csvFileName}'`, { cwd: downloadDir });
        } catch (err) {
          execSync(`rm -rf ${downloadDir}`);
        }
      }
    }
  });
});
