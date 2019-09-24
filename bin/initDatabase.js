#!/usr/bin/env node

const { execSync } = require('child_process');
const { readFileSync } = require('fs');
const { join } = require('path');

const pgEnvPath = join(__dirname, '../config/postgres_db.env');
require('dotenv').config({ path: pgEnvPath });

const { env } = process;
const { PGUSER, PGDATABASE } = env;

execSync(
  `createdb --echo --owner=${PGUSER} ${PGDATABASE} 'NYSDOT Traffic Counts'`
);

const createPostgisPath = join(__dirname, '../sql/init/postgis.sql');

const sql = readFileSync(createPostgisPath)
  .toString()
  .replace(/__PGDATABASE__/, PGDATABASE);

execSync(`psql -c '${sql}'`);
