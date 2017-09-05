-- -- Short Counts Shapefile
-- --   *  18% of Avg Weekday stations from the speed CSV do not have an entry in the shapefile.
-- --   *  19% of Avg Weekday stations from the classification CSV do not have an entry in the shapefile.
-- --   *  27% of Avg Weekday stations from the volume CSV do not have an entry in the shapefile.
-- --   *  18% of Short Count stations from the speed CSV do not have an entry in the shapefile.
-- --   *  18% of Short Count stations from the classification CSV do not have an entry in the shapefile.
-- --   *  27% of Short Count stations from the volume CSV do not have an entry in the shapefile.
-- --
-- --   *   9% of Short Count stations in the shapefile have no CSV average weekday data.
-- --   *  66% of Short Count stations in the shapefile have no CSV short_counts data.
-- --
-- -- Continuous Counts Shapefile
-- --   *  1% of Continuous Counts stations from the classification CSV do not have an entry in the shapefile.
-- --   * <1% of Continuous Counts stations from the volume CSV do not have an entry in the shapefile.
-- --
-- --   * <1% of the stations in the shapefile have no CSV data.

-------------------------------------------------------


-- SELECT COUNT(DISTINCT rc_station)
-- 	FROM average_weekday_speed
-- 	WHERE rc_station NOT IN (
-- 		SELECT DISTINCT rc_id
-- 			FROM short_counts_shp
-- 	)
-- ;
-- 
-- --  count
-- -- -------
-- --  2256
-- -- (1 row)

-- SELECT COUNT(DISTINCT rc_station)
-- 	FROM average_weekday_speed
-- ;
-- 
-- --  count
-- -- -------
-- --  12639
-- -- (1 row)

-- SELECT 2256.0/12639.0;
-- 
-- --  ?column?
-- -- ------------------------
-- --  0.17849513410871113221
-- -- (1 row)

-- SELECT COUNT(DISTINCT rc_station)
-- 	FROM average_weekday_vehicle_classification
-- 	WHERE rc_station NOT IN (
-- 		SELECT DISTINCT rc_id
-- 			FROM short_counts_shp
-- 	)
-- ;
-- 
-- --  count
-- -- -------
-- --  2470
-- -- (1 row)


-- SELECT COUNT(DISTINCT rc_station)
-- 	FROM average_weekday_vehicle_classification
-- ;

--  count
-- -------
-- 13054 
-- (1 row)

-- SELECT 2470.0/13054.0;

-- ?column?
-- ------------------------
--  0.18921403401256319902
-- (1 row)

-- SELECT COUNT(DISTINCT rc_station)
-- 	FROM average_weekday_volume
-- 	WHERE rc_station NOT IN (
-- 		SELECT DISTINCT rc_id
-- 			FROM short_counts_shp
-- 	)
-- ;

--  count
-- -------
--  10705
-- (1 row)


-- SELECT COUNT(DISTINCT rc_station)
-- 	FROM average_weekday_volume
-- ;
-- 
-- --  count
-- -- -------
-- --  38943
-- -- (1 row)

-- SELECT 10705.0/38943.0;
-- 
-- -- ?column?
-- -- ------------------------
-- --  0.27488894024600056493
-- -- (1 row)



-- SELECT COUNT(DISTINCT rc_station)
-- 	FROM short_count_speed
-- 	WHERE rc_station NOT IN (
-- 		SELECT DISTINCT rc_id
-- 			FROM short_counts_shp
-- 	)
-- ;
-- 
-- --  count
-- -- -------
-- --  2256
-- -- (1 row)
-- 
-- SELECT COUNT(DISTINCT rc_station)
-- 	FROM short_count_speed
-- ;
-- 
-- --  count
-- -- -------
-- --  12623
-- -- (1 row)
-- 
-- SELECT 2256.0/12623.0;
-- 
-- --  ?column?
-- -- ------------------------
-- --  0.17872138160500673374
-- -- (1 row)

-- SELECT COUNT(DISTINCT rc_station)
-- 	FROM short_count_vehicle_classification
-- 	WHERE rc_station NOT IN (
-- 		SELECT DISTINCT rc_id
-- 			FROM short_counts_shp
-- 	)
-- ;
-- 
-- --  count
-- -- -------
-- --   2279
-- -- (1 row)
-- 
-- 
-- SELECT COUNT(DISTINCT rc_station)
-- 	FROM short_count_vehicle_classification
-- ;
-- 
-- --  count
-- -- -------
-- --  12772
-- -- (1 row)

-- SELECT 2279.0/12623.0;
-- 
-- -- ?column?
-- -- ------------------------
-- --  0.17843720638897588475
-- -- (1 row)


-- SELECT COUNT(DISTINCT rc_station)
-- 	FROM short_count_volume
-- 	WHERE rc_station NOT IN (
-- 		SELECT DISTINCT rc_id
-- 			FROM short_counts_shp
-- 	)
-- ;
-- 
-- --  count
-- -- -------
-- --  10572
-- -- (1 row)
-- 
-- 
-- SELECT COUNT(DISTINCT rc_station)
-- 	FROM short_count_volume
-- ;
-- 
-- --  count
-- -- -------
-- --  38809
-- -- (1 row)

-- SELECT 10572.0/38809.0;
-- 
-- -- ?column?
-- -- ------------------------
-- --  0.27241103867659563503
-- -- (1 row)


-- SELECT COUNT(DISTINCT rc_id)
-- 	FROM short_counts_shp	
-- 	WHERE rc_id NOT IN (
-- 		SELECT rc_station
-- 			FROM short_count_speed
-- 		UNION
-- 		SELECT rc_station
-- 			FROM short_count_vehicle_classification
-- 		UNION
-- 		SELECT rc_station
-- 			FROM short_count_volume
-- 	)
-- ;
-- 
-- --  count
-- -- -------
-- --  20451 
-- -- (1 row)


-- SELECT COUNT(DISTINCT rc_id)
-- 	FROM short_counts_shp;
-- ;
-- 
-- --  count
-- -- -------
-- --  31172
-- -- (1 row)

-- SELECT 20451.0/31172.0;
--
-- --        ?column?
-- -- ------------------------
-- --  0.65606954959579109457
-- -- (1 row)


-- SELECT COUNT(DISTINCT rc_id)
-- 	FROM short_counts_shp	
-- 	WHERE rc_id NOT IN (
-- 		SELECT rc_station
-- 			FROM short_count_speed
-- 		UNION
-- 		SELECT rc_station
-- 			FROM short_count_vehicle_classification
-- 		UNION
-- 		SELECT rc_station
-- 			FROM short_count_volume
-- 		UNION
-- 		SELECT rc || '_' || station
-- 			FROM continuous_vehicle_classification
-- 		UNION
-- 		SELECT rc || '_' || station
-- 			FROM continuous_volume
-- 	)
-- ;
-- 
-- --  count
-- -- -------
-- --  20449
-- -- (1 row)

-- SELECT COUNT(DISTINCT rc_id)
-- 	FROM short_counts_shp	
-- 	WHERE rc_id NOT IN (
-- 		SELECT rc_station
-- 			FROM short_count_speed
-- 		UNION
-- 		SELECT rc_station
-- 			FROM short_count_vehicle_classification
-- 		UNION
-- 		SELECT rc_station
-- 			FROM short_count_volume
-- 		UNION
-- 		SELECT rc || '_' || station
-- 			FROM continuous_vehicle_classification
-- 		UNION
-- 		SELECT rc || '_' || station
-- 			FROM continuous_volume
-- 		UNION
-- 		SELECT rc_station
--       FROM average_weekday_speed
-- 		UNION
-- 		SELECT rc_station
--       FROM average_weekday_vehicle_classification
-- 		UNION
-- 		SELECT rc_station
--       FROM average_weekday_volume
-- 	)
-- ;

--  count
-- -------
--  2895
-- (1 row)


-- SELECT 2895.0/31172.0;
-- 
-- -- ?column?
-- -- ------------------------
-- --  0.09287180803284999358
-- -- (1 row)


-- SELECT COUNT(DISTINCT rc_id)
-- 	FROM short_counts_shp	
-- 	WHERE rc_id NOT IN (
-- 		SELECT rc_station
--       FROM average_weekday_speed
-- 		UNION
-- 		SELECT rc_station
--       FROM average_weekday_vehicle_classification
-- 		UNION
-- 		SELECT rc_station
--       FROM average_weekday_volume
-- 	)
-- ;
-- 
-- --  count
-- -- -------
-- --   2896
-- -- (1 row)


-------------------------------------------------------


-- SELECT COUNT(DISTINCT rc || '_' || station)
-- 	FROM continuous_vehicle_classification
-- 	WHERE rc || '_' || station NOT IN (
-- 		SELECT DISTINCT rc_id
-- 			FROM continuous_counts_shp
-- 	)
-- ;
-- 
-- --  count
-- -- -------
-- --    1
-- -- (1 row)

-- SELECT COUNT(DISTINCT rc || '_' || station)
-- 	FROM continuous_vehicle_classification
-- ;
-- 
-- --  count
-- -- -------
-- --  89
-- -- (1 row)

-- SELECT 1.0/89.0
-- 
-- --  ?column?
-- -- ------------------------
-- --  0.01123595505617977528
-- -- (1 row)

-- SELECT COUNT(DISTINCT rc || '_' || station)
-- 	FROM continuous_volume
-- 	WHERE rc || '_' || station NOT IN (
-- 		SELECT DISTINCT rc_id
-- 			FROM continuous_counts_shp
-- 	)
-- ;
-- 
-- --  count
-- -- -------
-- --   1
-- -- (1 row)


-- SELECT COUNT(DISTINCT rc || '_' || station)
-- 	FROM continuous_volume
-- ;
-- 
-- --  count
-- -- -------
-- --   177
-- -- (1 row)

-- SELECT 1.0/177.0;
-- 
-- --        ?column?
-- -- ------------------------
-- --  0.00564971751412429379
-- -- (1 row)

-- (1 row)

-- SELECT COUNT(DISTINCT rc_id)
-- 	FROM continuous_counts_shp	
-- 	WHERE rc_id NOT IN (
-- 		SELECT rc || '_' || station
-- 			FROM continuous_vehicle_classification
-- 		UNION
-- 		SELECT rc || '_' || station
-- 			FROM continuous_volume
-- 	)
-- ;
-- 
-- --  count
-- -- -------
-- --  1
-- -- (1 row)


