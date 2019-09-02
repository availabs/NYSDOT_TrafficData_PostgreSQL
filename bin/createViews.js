#!/usr/bin/env node

const { join } = require('path');

const { execSync } = require('child_process');

const { readdirSync } = require('fs');

const pgEnvPath = join(__dirname, '../config/postgres_db.env');
require('dotenv').config({ path: pgEnvPath });

const parentTablesDir = join(__dirname, '../sql/views');

readdirSync(parentTablesDir).forEach(filename => {
  const filePath = join(parentTablesDir, filename);

  execSync(
    `PGOPTIONS='--client-min-messages=warning' psql -q -v ON_ERROR_STOP=1 -f '${filePath}'`,
    { env: process.env }
  );
});
