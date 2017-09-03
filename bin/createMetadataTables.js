#!/usr/bin/env node

'use strict'


const { join } = require('path')

const { execSync } = require('child_process')

const {
  readdirSync
} = require('fs')


const pgEnvPath = join(__dirname, '../config/postgres_db.env')

const env = Object.assign({}, process.env, {})

require('dotenv').config({path: pgEnvPath })


const metdataSQLDir = join(__dirname, '../sql/metadataDatabaseObjects')

readdirSync(metdataSQLDir).forEach(filename => {
  const filePath = join(metdataSQLDir, filename)

  execSync(`PGOPTIONS='--client-min-messages=warning' psql -q -v ON_ERROR_STOP=1 -f '${filePath}'`, { env: process.env })
})
