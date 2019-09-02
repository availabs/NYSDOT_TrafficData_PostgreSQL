#!/usr/bin/env node

const { join } = require('path');

const { execSync } = require('child_process');

const { readFileSync } = require('fs');

const pgEnvPath = join(__dirname, '../config/postgres_db.env');

require('dotenv').config({ path: pgEnvPath });

execSync(`dropdb --echo --if-exists ${process.env.PGDATABASE}`, {
  env: process.env
});

execSync(
  `createdb --echo --owner=${process.env.PGUSER} ${process.env.PGDATABASE} 'NYSDOT Traffic Counts'`,
  { env: process.env }
);

const createPostgisPath = join(__dirname, '../sql/init/postgis.sql');
const sql = readFileSync(createPostgisPath)
  .toString()
  .replace(/__PGDATABASE__/, process.env.PGDATABASE);

execSync(`psql -c '${sql}'`, { env: process.env });
