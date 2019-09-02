#!/usr/bin/env node

/* eslint no-console: 0, no-param-reassign: 0, no-await-in-loop: 0 */

const { promisify } = require('util');

const { exec } = require('child_process');

const { readdirSync } = require('fs');

const { join } = require('path');

const SCHEMA = 'NY';

const execAsync = promisify(exec);

const minimistOptions = {
  // treat all double hyphenated arguments without equal signs as boolean
  boolean: true,

  // an object mapping string names to strings or arrays of string argument names to use as aliases
  alias: {
    //
    tables: 'table',
    years: 'year'
  }
};

const cliArgs = require('minimist')(process.argv.slice(2), minimistOptions);

const {
  pgEnvPath = join(__dirname, '../config/postgres_db.env'),
  dataDir = join(__dirname, '../data/'),
  cleanup // Delete the extracted Shapefiles and leave only the ZIPs when done.
} = cliArgs;

require('dotenv').config({ path: pgEnvPath });

const { PGHOSTADDR, PGPORT, PGUSER, PGDATABASE, PGPASSWORD } = process.env;

const pgConnectStr = `PG:host=${PGHOSTADDR} port=${PGPORT} user=${PGUSER} dbname=${PGDATABASE} password=${PGPASSWORD}`;

let { tables: requestedTables, years: requestedYears } = cliArgs;

requestedTables =
  requestedTables &&
  requestedTables
    .toString()
    .split(',')
    .map(s => s && s.trim())
    .filter(s => s);
requestedYears =
  requestedYears &&
  requestedYears
    .toString()
    .split(',')
    .map(s => s && s.trim())
    .filter(s => +s);

async function cleanDir(dir) {
  if (cleanup) {
    const toDelete = readdirSync(dir)
      .filter(f => !f.match(/zip$/i))
      .map(f => `'${join(dir, f)}'`)
      .join(' ');

    await execAsync(`rm -f ${toDelete}`);
  }
}

function getLoadInfo() {
  const shpDir = join(dataDir, 'shapefile');

  const shpTables = readdirSync(shpDir);

  const invalidTableRequests = requestedTables
    ? requestedTables.filter(x => !shpTables.includes(x))
    : [];

  if (invalidTableRequests.length) {
    console.error(
      `The following requested tables are invalid: ${invalidTableRequests}`
    );
    process.exit(1);
  }

  const tables = requestedTables || shpTables;

  return tables.reduce((acc1, table) => {
    const tableDir = join(shpDir, table);

    const shpYears = readdirSync(tableDir);

    const invalidYearRequests = requestedYears
      ? requestedYears.filter(x => !shpYears.includes(x))
      : [];

    if (invalidYearRequests.length) {
      console.error(
        `${table} has no data for the following requested years: ${invalidYearRequests}`
      );
      process.exit(1);
    }

    const years = requestedYears || shpYears;

    acc1[table] = years.reduce((acc2, year) => {
      const yearDir = join(tableDir, year);

      const dataFiles = readdirSync(yearDir);

      let shpFiles = dataFiles.filter(f => !f.match(/zip$/i));
      const zipFiles = dataFiles.filter(f => f.match(/zip$/i));

      if (zipFiles.length > 1) {
        console.error(`More than one ZIP file found in ${yearDir}`);
        process.exit(1);
      }

      const zipPath = zipFiles.length ? zipFiles[0] : null;

      if (!shpFiles.length) {
        if (!zipPath) {
          console.error(
            `No data found in ${yearDir}. Remove empty dirs, if necessary.`
          );
          process.exit(1);
        }
        execAsync(`unzip ${join(yearDir, zipPath)}`, { cwd: yearDir });

        shpFiles = readdirSync(yearDir).filter(f => !f.match(/zip$/i));
      }

      if (!shpFiles.length) {
        console.error(`No Shapefile file found in ${yearDir}`);

        cleanDir(yearDir);

        process.exit(1);
      }

      acc2[year] = yearDir;

      return acc2;
    }, {});

    return acc1;
  }, {});
}

let createSchemaOnce = async () => {
  await execAsync(`psql -c 'CREATE SCHEMA IF NOT EXISTS ${SCHEMA};'`, {
    env: process.env
  });
  createSchemaOnce = async () => {};
};

(async () => {
  const loadInfo = getLoadInfo();

  const tables = Object.keys(loadInfo);

  for (let i = 0; i < tables.length; i += 1) {
    const table = tables[i];

    let createdParentTable = false;

    const years = Object.keys(loadInfo[table]);

    for (let j = 0; j < years.length; j += 1) {
      const year = years[j];

      const dir = loadInfo[table][year];

      await createSchemaOnce();

      const versionTableName = `${table}_y${year}`;

      const cmd = `
        ogr2ogr -f PostgreSQL '${pgConnectStr}' ${dir} \
          -lco SPATIAL_INDEX=FALSE \
          -lco SCHEMA=${SCHEMA.toLowerCase()} \
          -lco OVERWRITE=YES \
          -nln ${versionTableName} \
          -t_srs EPSG:4326 \
      `;

      try {
        // First try without PROMOTE_TO_MULTI
        console.log(cmd);
        const { stderr } = await execAsync(cmd, { env: process.env });

        if (stderr) {
          throw stderr;
        }
      } catch (err) {
        // If above failed, retry with PROMOTE_TO_MULTI
        console.log(`${cmd} -nlt PROMOTE_TO_MULTI -lco PRECISION=NO`);
        const { stderr } = await execAsync(
          `${cmd} -nlt PROMOTE_TO_MULTI -lco PRECISION=NO  --config SHAPE_RESTORE_SHX true`,
          { env: process.env }
        );

        if (stderr) {
          throw stderr;
        }
      }

      if (!createdParentTable) {
        console.log(
          `psql -c 'CREATE TABLE IF NOT EXISTS public.${table} (LIKE ${SCHEMA}.${versionTableName});'`
        );
        await execAsync(
          `psql -c 'CREATE TABLE IF NOT EXISTS public.${table} (LIKE ${SCHEMA}.${versionTableName});'`,
          { env: process.env }
        );
        createdParentTable = true;
      }

      const sql = `
        BEGIN;

        ALTER TABLE ${SCHEMA}.${versionTableName}
          INHERIT public.${table},
          SET (fillfactor = 100, autovacuum_enabled = false, toast.autovacuum_enabled = false);

        CREATE INDEX ${versionTableName}_gix ON ${SCHEMA}.${versionTableName} USING GIST (wkb_geometry);

        CLUSTER ${SCHEMA}.${versionTableName} USING ${versionTableName}_gix;
   
        COMMIT;

        ANALYZE ${SCHEMA}.${versionTableName};
      `;

      await execAsync(`psql -c '${sql}'`, { env: process.env });
      // console.log(`psql -c '${sql}'`);
    }
  }
})();
