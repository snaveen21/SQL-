--Method 1
SELECT source_code,last_execution_time
FROM sys.dm_exec_query_stats as stats
CROSS APPLY (
SELECT text as source_code
FROM sys.dm_exec_sql_text(sql_handle))
AS query_text
ORDER BY last_execution_time desc

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
    ORDER BY OBJECT_NAME(so.OBJECT_ID)
    
    
-- Method 3    
    USE <dbname>
GO

SELECT v.name [ViewName]
FROM sys.views v
WHERE v.is_ms_shipped = 0

EXCEPT SELECT o.Name [ViewName]
FROM master.sys.dm_exec_cached_plans p
CROSS APPLY sys.dm_exec_sql_text(p.plan_handle) t
INNER JOIN sys.objects o ON t.objectid = o.object_id
WHERE t.dbid = DB_ID()
GO