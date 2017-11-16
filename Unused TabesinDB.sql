--Method 1
-- Unused tables & indexes. Tables have index_id’s of either 0 = Heap table or 1 = Clustered Index

SELECT OBJECTNAME = OBJECT_NAME(I.OBJECT_ID), INDEXNAME = I.NAME, I.INDEX_ID

FROM SYS.INDEXES AS I

INNER JOIN SYS.OBJECTS AS O

ON I.OBJECT_ID = O.OBJECT_ID

WHERE OBJECTPROPERTY(O.OBJECT_ID,'IsUserTable') = 1

AND I.INDEX_ID

NOT IN (SELECT S.INDEX_ID

FROM SYS.DM_DB_INDEX_USAGE_STATS AS S

WHERE S.OBJECT_ID = I.OBJECT_ID

AND I.INDEX_ID = S.INDEX_ID

AND DATABASE_ID = DB_ID(db_name()))

ORDER BY OBJECTNAME, I.INDEX_ID, INDEXNAME ASC


-- Method 2
WITH LastActivity (ObjectID, LastAction) AS
    (
    SELECT OBJECT_ID AS TableName,
                last_user_seek AS LastAction
        FROM sys.dm_db_index_usage_stats u
        WHERE database_id = DB_ID(DB_NAME())
        UNION
    SELECT OBJECT_ID AS TableName,
                last_user_scan AS LastAction
        FROM sys.dm_db_index_usage_stats u
        WHERE database_id = DB_ID(DB_NAME())
        UNION
    SELECT OBJECT_ID AS TableName,
                last_user_lookup AS LastAction
        FROM sys.dm_db_index_usage_stats u
        WHERE database_id = DB_ID(DB_NAME())
    )
SELECT OBJECT_NAME(so.OBJECT_ID) AS TableName,
            MAX(la.LastAction) AS LastSelect
    FROM sys.objects so
            LEFT
            JOIN LastActivity la
            ON so.OBJECT_ID = la.ObjectID
    WHERE so.TYPE = 'U'
        AND so.OBJECT_ID > 100
    GROUP BY OBJECT_NAME(so.OBJECT_ID)
    ORDER BY 2
    
    
    sp_spaceused deletedCDR201201
    
    CDRExtPasses
CDRExtPassZ
deletedCDR201201
T_CDRTABLEINFO
T_TABLEINFO
Optin_0
TOPUPS201306
Topup_Prefix
    
    
    
    
    
    
--- Unused Tables
-- Method 3


    SELECT 
  t.name AS 'Table', t.Create_Date,
  t.Modify_Date,
  SUM(i.user_seeks + i.user_scans + i.user_lookups + i.user_updates) 
    AS 'Total accesses',
  SUM(i.user_seeks) AS 'Seeks',
  SUM(i.user_scans) AS 'Scans',
  SUM(i.user_lookups) AS 'Lookups',
  SUM(i.user_updates) AS 'Updates',
  MAX(i.last_user_update) as 'Last_Update'
FROM 
  sys.dm_db_index_usage_stats i RIGHT OUTER JOIN 
    sys.tables t ON (t.object_id = i.object_id)
GROUP BY 
  i.object_id, 
  t.name,
  t.Create_Date,
  t.Modify_Date
ORDER BY 8 

-- Method 4 unused tables
SELECT 
                OBJECT_NAME(i.[object_id]) AS [Table name] ,
                CASE WHEN i.name IS NULL THEN '<Unused table>' ELSE i.name END AS [Index name]
FROM 
                sys.indexes AS i
                INNER JOIN sys.objects AS o ON i.[object_id] = o.[object_id]
WHERE 
               i.index_id NOT IN ( 
               SELECT s.index_id
                FROM sys.dm_db_index_usage_stats AS s
                WHERE s.[object_id] = i.[object_id]
                AND i.index_id = s.index_id
                AND database_id = DB_ID() )
AND o.[type] = 'U'
ORDER BY OBJECT_NAME(i.[object_id]) ASC;





---- Unused Tables and Index
-- Method 4
-- Unused tables & indexes. Tables have index_id’s of either 0 = Heap table or 1 = Clustered Index

SELECT OBJECTNAME = OBJECT_NAME(I.OBJECT_ID), INDEXNAME = I.NAME, I.INDEX_ID

FROM SYS.INDEXES AS I

INNER JOIN SYS.OBJECTS AS O

ON I.OBJECT_ID = O.OBJECT_ID

WHERE OBJECTPROPERTY(O.OBJECT_ID,'IsUserTable') = 1

AND I.INDEX_ID

NOT IN (SELECT S.INDEX_ID

FROM SYS.DM_DB_INDEX_USAGE_STATS AS S

WHERE S.OBJECT_ID = I.OBJECT_ID

AND I.INDEX_ID = S.INDEX_ID

AND DATABASE_ID = DB_ID(db_name()))

ORDER BY OBJECTNAME, I.INDEX_ID, INDEXNAME ASC




CDR201405
GPRS_MMS_CDR201402
MSISDN_Balance
CDR201405
TOPUPS201307
Optin2013
TOPUPS_LIVE
BB_DataUsage
deletedCDR201201
Zone
Prod_Bundle_Types
CDRExtPasses				---
CDRExtPassZ					---
CDR_Types


select TOP 10 * from CDR201405 order by charging_timestamp desc

EXEC sp_spaceused N'dbo.CDR201405'; GO