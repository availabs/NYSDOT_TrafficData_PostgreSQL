#!/usr/bin/env node

/* eslint no-console: 0, no-param-reassign: 0 */

const { execSync } = require('child_process');

const {
  readdirSync,
  readFileSync,
  writeFileSync,
} = require('fs');

const { join } = require('path');

const uuidv1 = require('uuid/v1');

const csvLoadersDir = join(__dirname, '../sql/loaders');


const minimistOptions = {
  // treat all double hyphenated arguments without equal signs as boolean
  boolean: true,

  // an object mapping string names to strings or arrays of string argument names to use as aliases
  alias: { //
    tables: 'table',
    years: 'year',
    regions: 'region',
  },
};

const cliArgs = require('minimist')(process.argv.slice(2), minimistOptions);

const {
  pgEnvPath = join(__dirname, '../config/postgres_db.env'),
  dataDir = join(__dirname, '../data/'),
  cleanup, // Delete the extracted CSVs and leave only the ZIPs when done.
} = cliArgs;

require('dotenv').config({ path: pgEnvPath });


let {
  tables: requestedTables,
  years: requestedYears,
  regions: requestedRegions,
} = cliArgs;

requestedTables = requestedTables && requestedTables.toString().split(',').map(s => s && s.trim()).filter(s => s);
requestedYears = requestedYears && requestedYears.toString().split(',').map(s => s && s.trim()).filter(s => +s);

// Convert requested regions to R01-R11 format.
requestedRegions = requestedRegions &&
    requestedRegions.toString().split(',')
      .map(s => s && s.trim())
      .filter(s => s)
      .map(s => `R${`0${s.replace(/r/i, '').replace(/^0/, '')}`.slice(-2)}`);

// Get the table load SQL script paths.
const csvLoaders =
  readdirSync(csvLoadersDir)
    .filter(f => f.match(/^load.*sql$/))
    .reduce((acc, filename) => {
      const tableName = filename.replace(/load_/, '').replace(/_table\.sql/, '');
      acc[tableName] = join(csvLoadersDir, filename);
      return acc;
    }, {});


function cleanDir(dir) {
  if (cleanup) {
    const toDelete =
        readdirSync(dir)
          .filter(f => !f.match(/zip$/i))
          .map(f => `'${join(dir, f)}'`)
          .join(' ');

    execSync(`rm -f ${toDelete}`);
  }
}


function getLoadCSVsInfo() {
  const csvDir = join(dataDir, 'csv');

  const csvTables = new Set(readdirSync(csvDir));

  const invalidTableRequests = requestedTables
    ? [...requestedTables].filter(x => !csvTables.has(x))
    : [];

  if (invalidTableRequests.length) {
    console.error(`The following requested tables are invalid: ${invalidTableRequests}`);
    process.exit(1);
  }

  const tables = requestedTables || [...csvTables];

  return tables.reduce((acc1, table) => {
    const tableDir = join(csvDir, table);

    const csvYears = new Set(readdirSync(tableDir));

    const invalidYearRequests = requestedYears
      ? [...requestedYears].filter(x => !csvYears.has(x))
      : [];

    if (invalidYearRequests.length) {
      console.error(`${table} has no data for the following requested years: ${invalidYearRequests}`);
      process.exit(1);
    }

    const years = requestedYears || [...csvYears];

    acc1[table] = years.reduce((acc2, year) => {
      const yearDir = join(tableDir, year);

      const csvRegions = new Set(readdirSync(yearDir));

      const invalidRegionRequests = requestedRegions
        ? [...requestedRegions].filter(x => !csvRegions.has(x))
        : [];

      if (invalidRegionRequests.length) {
        console.error(`${table} has no data for ${year} for the following requested regions: ${invalidRegionRequests}`);
        process.exit(1);
      }

      const regions = requestedRegions || [...csvRegions];

      acc2[year] = regions.reduce((acc3, region) => {
        const regionDir = join(yearDir, region);

        const dataFiles = readdirSync(regionDir);

        let csvFiles = dataFiles.filter(f => f.match(/\.csv$/i));
        const zipFiles = dataFiles.filter(f => f.match(/\.zip$/i));

        if (zipFiles.length > 1) {
          console.error(`More than one ZIP file found in ${regionDir}`);
          process.exit(1);
        }

        const zipPath = zipFiles.length ? zipFiles[0] : null;

        if (!csvFiles.length) {
          if (!zipPath) {
            console.error(`No data found in ${regionDir}. Remove enpty dirs, if necessary.`);
            process.exit(1);
          }
          execSync(`unzip ${join(regionDir, zipPath)}`, { cwd: regionDir });

          csvFiles = readdirSync(regionDir).filter(f => f.match(/\.csv$/i));
        }

        if (csvFiles.length !== 1) {
          if (csvFiles.length === 0) {
            console.error(`No CSV file found in ${regionDir}`);
          } else {
            console.error(`More than one CSV file found in ${regionDir}`);
          }

          cleanDir(regionDir);

          process.exit(1);
        }

        acc3[region] = { csvPath: join(regionDir, csvFiles[0]) };

        return acc3;
      }, {});
      return acc2;
    }, {});
    return acc1;
  }, {});
}


Object.entries(getLoadCSVsInfo()).forEach(([table, yearsInfo]) => {
  const templateLoaderScriptPath = csvLoaders[table];

  if (!templateLoaderScriptPath) {
    console.error(`Something is wrong. No match for ${table} in ${csvLoadersDir}.`);
    process.exit(1);
  }

  const userName = process.env.PGUSER;

  const templateLoaderScript = readFileSync(templateLoaderScriptPath, 'utf8');

  const usrTemplateLoaderScript = templateLoaderScript.replace(/__PGUSER__/g, userName);

  Object.entries(yearsInfo).forEach(([year, regionsInfo]) => {
    const yrTemplateLoaderScript = usrTemplateLoaderScript.replace(/__YEAR__/g, year);

    Object.entries(regionsInfo).forEach(([region, dataFilesInfo]) => {
      const {
        csvPath,
      } = dataFilesInfo;

      const loaderScript =
          yrTemplateLoaderScript
            .replace(/__REGION__/g, region)
            .replace(/__REGION_NUM__/g, region.replace(/R/g, ''))
            .replace(/__CSV_PATH__/g, csvPath);

      const tmpFilePath = `/tmp/nysdot_traffic_data_loader_${uuidv1()}.sql`;
      writeFileSync(tmpFilePath, loaderScript);

      try {
        execSync(`PGOPTIONS='--client-min-messages=warning' psql -q -v ON_ERROR_STOP=1 -f '${tmpFilePath}'`, { env: process.env });
      } catch (err) {
        console.error(err);
        execSync(`rm -f ${tmpFilePath}`);
        process.exit(1);
      }

      execSync(`rm -f ${tmpFilePath}`);
    });
  });
});
