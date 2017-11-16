
-- GET UNUSED INDEXES THAT DO **NOT** APPEAR IN THE INDEX USAGE STATS TABLE
DECLARE @dbid INT
SELECT @dbid = DB_ID(DB_NAME())

SELECT	Databases.Name AS [Database],
	Objects.NAME AS [Table],
	Indexes.NAME AS [Index],
	Indexes.INDEX_ID,
	PhysicalStats.page_count as [Page Count],
	CONVERT(decimal(18,2), PhysicalStats.page_count * 8 / 1024.0) AS [Total Index Size (MB)],
	CONVERT(decimal(18,2), PhysicalStats.avg_fragmentation_in_percent) AS [Fragmentation (%)]
FROM SYS.INDEXES Indexes
	INNER JOIN SYS.OBJECTS Objects ON Indexes.OBJECT_ID = Objects.OBJECT_ID
	LEFT JOIN sys.dm_db_index_physical_stats(@dbid, null, null, null, null) PhysicalStats
		ON PhysicalStats.object_id = Indexes.object_id 
                     AND PhysicalStats.index_id = indexes.index_id
	INNER JOIN sys.databases Databases
		ON Databases.database_id = PhysicalStats.database_id
WHERE Objects.type = 'U' -- Is User Table
	AND Indexes.is_primary_key = 0
	AND Indexes.INDEX_ID NOT IN (
			SELECT UsageStats.INDEX_ID
			FROM SYS.DM_DB_INDEX_USAGE_STATS UsageStats
			WHERE UsageStats.OBJECT_ID = Indexes.OBJECT_ID
				AND   Indexes.INDEX_ID = UsageStats.INDEX_ID
				AND   DATABASE_ID = @dbid)
ORDER BY PhysicalStats.page_count DESC,
	Objects.NAME,
        Indexes.INDEX_ID,
        Indexes.NAME ASC




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