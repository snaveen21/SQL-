

---------------------------- check the table and last usage date

select
t.name
,user_seeks
,user_scans
,user_lookups
,user_updates
,last_user_seek
,last_user_scan
,last_user_lookup
,last_user_update
from
sys.dm_db_ta_usage_stats i JOIN
sys.tables t ON (t.object_id = i.object_id)
where
database_id = db_id()


----------------------------------------------------------------

-- Tables not in use
-- Choose how many accesses of the table to allow
-- in your result set.
DECLARE @accesscount int
SET @accesscount = 0

SELECT DB_NAME(0) AS dbname,  
    t.name AS tablename,
    SUM(user_seeks) AS sum_user_seeks, 
    SUM(user_scans) AS sum_user_scans, 
    SUM(user_lookups) AS sum_user_lookups, 
    SUM(user_updates) AS sum_user_updates,
    MAX(last_user_seek) AS last_user_seek, 
    MAX(last_user_scan) AS last_user_scan, 
    MAX(last_user_lookup) AS last_user_lookup, 
    MAX(last_user_update) AS last_user_update
-- Limit to user tables. System tables
-- are not referenced in sys.tables.
FROM sys.tables t 
-- The stats table tracks all use of a table's indexes
-- The LEFT OUTER JOINS include tables for which no
-- statistics have been captured.
 LEFT OUTER JOIN sys.dm_db_index_usage_stats s
   ON s.object_id = t.object_id
 LEFT OUTER JOIN sys.indexes i 
  ON t.object_id = i.object_id
  AND s.index_id = i.index_id
-- Any update indicates use of the table.
-- Any seeks, scans or lookups indicate table use.
-- But system functions also can scan the data. 
-- Any activity means not a candidate
-- Treat NULL values as 0 for reporting purposes
WHERE COALESCE (user_updates,0) = 0 
 AND COALESCE (user_seeks + user_scans + user_lookups,0) <= @accesscount 
 AND COALESCE(s.database_id, DB_ID()) = DB_ID()
-- Aggregate all index counts for access to a table
GROUP BY DB_NAME(s.database_id), db_name(s.database_id), t.name
---- Order the results by database and table name
ORDER BY dbname, tablename


-------------------------------

select db_name(s.database_id) dbname, object_name(s.object_id) tablename,
i.name indexname, user_seeks, user_scans, user_lookups, user_updates,
CAST((user_seeks + user_scans + user_lookups) / (user_updates * 1.0) AS DECIMAL(5,1)) Read_Upd_Ratio, 
last_user_seek, last_user_scan, last_user_lookup, last_user_update
from sys.dm_db_index_usage_stats s
  join sys.indexes i on 
      s.object_id = i.object_id
      AND s.index_id = i.index_id
where  user_seeks + user_scans + user_lookups < user_updates
  and user_updates > 0
order by user_seeks + user_scans + user_lookups,Read_Upd_Ratio, user_updates desc



sp_spaceused activesnapshot






MED_MON_REC_CDR_ERROR_ESP_VIJAY
MED_MON_REC_CDR_ERROR_ESP_vv
MED_REC_CDR_ERROR_ESP_vv