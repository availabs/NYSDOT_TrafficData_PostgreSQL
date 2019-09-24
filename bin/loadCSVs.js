#!/usr/bin/env node

/* eslint no-console: 0, no-param-reassign: 0 */

const { execSync } = require('child_process');

const { readdirSync, readFileSync, writeFileSync } = require('fs');

const { join } = require('path');

const uuidv1 = require('uuid/v1');

const csvLoadersDir = join(__dirname, '../sql/loaders');

const minimistOptions = {
  // treat all double hyphenated arguments without equal signs as boolean
  boolean: true,

  // an object mapping string names to strings or arrays of string argument names to use as aliases
  alias: {
    tables: 'table',
    years: 'year',
    regions: 'region'
  }
};

const cliArgs = require('minimist')(process.argv.slice(2), minimistOptions);

const {
  pgEnvPath = join(__dirname, '../config/postgres_db.env'),
  dataDir = join(__dirname, '../data/'),
  cleanup // Delete the extracted CSVs and leave only the ZIPs when done.
} = cliArgs;

require('dotenv').config({ path: pgEnvPath });

const { tables, years, regions } = cliArgs;

const requestedTables =
  tables &&
  tables
    .toString()
    .split(',')
    .map(s => s && s.trim())
    .filter(s => s);

const requestedYears =
  years &&
  years
    .toString()
    .split(',')
    .map(s => s && s.trim())
    .filter(s => +s);

// Convert requested regions to R01-R11 format.
const requestedRegions =
  regions &&
  regions
    .toString()
    .split(',')
    .map(s => s && s.trim())
    .filter(s => s)
    .map(s => `R${`0${s.replace(/r/i, '').replace(/^0/, '')}`.slice(-2)}`);

// Get the table load SQL script paths.
const csvLoaders = readdirSync(csvLoadersDir)
  .filter(f => f.match(/^load.*sql$/))
  .reduce((acc, filename) => {
    const tableName = filename.replace(/load_/, '').replace(/_table\.sql/, '');
    acc[tableName] = join(csvLoadersDir, filename);
    return acc;
  }, {});

function removeUnzippedCSVFiles(dir) {
  if (cleanup) {
    const toDelete = readdirSync(dir)
      .filter(f => !f.match(/zip$/i))
      .map(f => `'${join(dir, f)}'`)
      .join(' ');

    execSync(`rm -f ${toDelete}`);
  }
}

// FIXME: This function needs to be decomposed. A lot going on in here:
//   NOTE: It causes the loader process to exit with an error if:
//           a) the requested tables are not valid
//           b) the requested years are not valid
//           c) the requested years are not valid
function getLoadCSVsInfo() {
  const csvDir = join(dataDir, 'csv');

  // Validate requested table names.
  // FIXME: The CSV directory sub-directory names are being used as ENUMs.
  const csvTables = readdirSync(csvDir);

  const invalidTableRequests = requestedTables
    ? requestedTables.filter(x => !csvTables.includes(x))
    : [];

  if (invalidTableRequests.length) {
    console.error(
      `The following requested tables are invalid: ${invalidTableRequests}`
    );
    process.exit(1);
  }

  // tablesToLoad are either the specified or all csvTables
  const tablesToLoad = requestedTables || csvTables;

  // FIXME: Massive reduce function that needs to be decomposed.
  //  The returned object:
  //    * keys are region id
  //    * values are csvPaths to the unzipped CSVs
  //  NOTE: In this reduce function, ZIP archives are getting unzipped.
  //  NOTE: This reduce function validates process input and will cause the process to exit if
  //          a) any CLI config variables are invalid.
  //          b) any input data invariants are broken.
  return tablesToLoad.reduce((acc1, table) => {
    const tableDir = join(csvDir, table);

    const csvYears = readdirSync(tableDir);

    const invalidYearRequests = requestedYears
      ? requestedYears.filter(x => !csvYears.includes(x))
      : [];

    if (invalidYearRequests.length) {
      console.error(
        `${table} has no data for the following requested years: ${invalidYearRequests}`
      );
      process.exit(1);
    }

    const yearsToLoad = requestedYears || csvYears;
    console.log(yearsToLoad)

    acc1[table] = yearsToLoad.reduce((acc2, year) => {
      const yearDir = join(tableDir, year);

      const csvRegions = new Set(readdirSync(yearDir));

      const invalidRegionRequests = requestedRegions
        ? [...requestedRegions].filter(x => !csvRegions.has(x))
        : [];

      if (invalidRegionRequests.length) {
        console.error(
          `${table} has no data for ${year} for the following requested regions: ${invalidRegionRequests}`
        );
        process.exit(1);
      }

      const regionsToLoad = requestedRegions || [...csvRegions];

      acc2[year] = regionsToLoad.reduce((acc3, region) => {
        const regionDir = join(yearDir, region);

        const dataFiles = readdirSync(regionDir);

        let csvFiles = dataFiles.filter(f => f.match(/\.csv$/i));
        const zipFiles = dataFiles.filter(f => f.match(/\.zip$/i));

        // INVARIANT: There is at most one zip file in the regionDir
        if (zipFiles.length > 1) {
          console.error(`More than one ZIP file found in ${regionDir}`);
          process.exit(1);
        }

        // If there is a zipFile, get its path.
        const zipPath = zipFiles.length ? zipFiles[0] : null;

        // If we don't have an unzipped CSV in this directory,
        //   unzip the (single) archive file to get (a single) unzipped CSV.
        if (!csvFiles.length) {
          if (!zipPath) {
            // NO data at all in the region's directory.
            console.error(
              `No data found in ${regionDir}. Remove empty dirs, if necessary.`
            );

            process.exit(1);
          }

          // Extract the (single) CSV from the ZIP archive.
          execSync(`unzip ${join(regionDir, zipPath)}`, { cwd: regionDir });

          // MUTATION: Update the csvFiles variable
          csvFiles = readdirSync(regionDir).filter(f => f.match(/\.csv$/i));
        }

        // EXIT With Error if number of csvFiles in the ZIP is not exactly 1.
        if (csvFiles.length !== 1) {
          if (csvFiles.length === 0) {
            console.error(`No CSV file found in ${regionDir}`);
          } else {
            console.error(`More than one CSV file found in ${regionDir}`);
          }

          // cleanup the unzipped CSV files
          removeUnzippedCSVFiles(regionDir);

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

const loadCSVsInfo = getLoadCSVsInfo();

Object.entries(loadCSVsInfo).forEach(([table, yearsInfo]) => {
  const templateLoaderScriptPath = csvLoaders[table];

  if (!templateLoaderScriptPath) {
    console.error(
      `Something is wrong. No match for ${table} in ${csvLoadersDir}.`
    );
    process.exit(1);
  }

  const userName = process.env.PGUSER;

  const templateLoaderScript = readFileSync(templateLoaderScriptPath, 'utf8');

  const usrTemplateLoaderScript = templateLoaderScript.replace(
    /__PGUSER__/g,
    userName
  );

  Object.entries(yearsInfo).forEach(([year, regionsInfo]) => {
    const yrTemplateLoaderScript = usrTemplateLoaderScript.replace(
      /__YEAR__/g,
      year
    );

    Object.entries(regionsInfo).forEach(([region, dataFilesInfo]) => {
      const { csvPath } = dataFilesInfo;

      const loaderScript = yrTemplateLoaderScript
        .replace(/__REGION__/g, region)
        .replace(/__REGION_NUM__/g, region.replace(/R/g, ''))
        .replace(/__CSV_PATH__/g, csvPath);

      const tmpFilePath = `/tmp/nysdot_traffic_data_loader_${uuidv1()}.sql`;
      writeFileSync(tmpFilePath, loaderScript);

      try {
        execSync(
          `PGOPTIONS='--client-min-messages=warning' psql -q -v ON_ERROR_STOP=1 -f '${tmpFilePath}'`,
          { env: process.env }
        );
      } catch (err) {
        console.error(err);
        execSync(`rm -f ${tmpFilePath}`);
        process.exit(1);
      } finally {
        execSync(`rm -f ${tmpFilePath}`);
      }
    });
  });
});
