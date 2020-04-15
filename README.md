# THIS PROJECT IS DEPRECATED. CODE MOVED TO NPMRDS_DATABASE REPO.



# NYSDOT_TrafficData_PostgreSQL

## Scraping the data

```
./bin/scrape-NYSDOT-Shapefiles.js
./bin/scrape-NYSDOT-Inventory.js
./bin/scrape-NYSDOT-CSVs.js
```

## Removing empty directories

```
find data/csv -type d -empty -exec rmdir {} \;
```

## Creating the database

```
./bin/initDatabase.js
./bin/createMetadataTables.js
./bin/createParentTables.js
```

## Loading the data

```
./bin/loadCSVs.js
```
