
 -------------------------------------------------- SQL server Memory -----------------------------------
 SELECT 
    DB_NAME(database_id) AS [Database Name]
    ,CAST(COUNT(*) * 8/1024.0 AS DECIMAL (10,2))  AS [Cached Size (MB)]
FROM sys.dm_os_buffer_descriptors WITH (NOLOCK)
WHERE database_id not in (1,3,4) -- system databases
AND database_id <> 32767 -- ResourceDB
GROUP BY DB_NAME(database_id)
ORDER BY [Cached Size (MB)] DESC OPTION (RECOMPILE);

select 
    name
    ,sum(pages_allocated_count)/128.0 [Cache Size (MB)]
from sys.dm_os_memory_cache_entries
where pages_allocated_count > 0
group by name
order by sum(pages_allocated_count) desc

 /*
	 This metric measures how much the plan cache is being used. A high percentage here means 
	 that your SQL Server is not building a new plan for every query it is executing so 
	 is working effectively and efficiently. A low percentage here means that for some reason, 
	 the SQL Server is doing more work than it needs to. This metric needs to be considered 
	 alongside the Plan cache reuse metric which looks at the spread of plan reuse through your cache.
	 
	 
 */
 WITH    cte1
          AS ( SELECT [dopc].[object_name] ,
                    [dopc].[instance_name] ,
                    [dopc].[counter_name] ,
                    [dopc].[cntr_value] ,
                    [dopc].[cntr_type] ,
                    ROW_NUMBER() OVER ( PARTITION BY [dopc].[object_name], [dopc].[instance_name] ORDER BY [dopc].[counter_name] ) AS r_n
                FROM [sys].[dm_os_performance_counters] AS dopc
                WHERE [dopc].[counter_name] LIKE '%Cache Hit Ratio%'
                    AND ( [dopc].[object_name] LIKE '%Plan Cache%'
                          OR [dopc].[object_name] LIKE '%Buffer Cache%'
                        )
                    AND [dopc].[instance_name] LIKE '%_Total%'
             )
    SELECT CONVERT(DECIMAL(16, 2), ( [c].[cntr_value] * 1.0 / [c1].[cntr_value] ) * 100.0) AS [hit_pct]
        FROM [cte1] AS c
            INNER JOIN [cte1] AS c1
                ON c.[object_name] = c1.[object_name]
                   AND c.[instance_name] = c1.[instance_name]
        WHERE [c].[r_n] = 1
            AND [c1].[r_n] = 2;

 
 SELECT type as 'plan cache store', buckets_count 
FROM sys.dm_os_memory_cache_hash_tables 
WHERE type IN ('CACHESTORE_OBJCP', 'CACHESTORE_SQLCP',
'CACHESTORE_PHDR', 'CACHESTORE_XPROC');
 

 
 SELECT * FROM sys.dm_os_memory_clerks ORDER BY (single_pages_kb + multi_pages_kb + awe_allocated_kb) desc
 
 ------------------------------------------------------------------------------------------------------------
 --find out how big buffer pool is and determine percentage used by each database

DECLARE @total_buffer INT;
SELECT @total_buffer = cntr_value   FROM sys.dm_os_performance_counters
WHERE RTRIM([object_name]) LIKE '%Buffer Manager'   AND counter_name = 'Total Pages';
;WITH src AS(   SELECT        database_id, db_buffer_pages = COUNT_BIG(*) 
FROM sys.dm_os_buffer_descriptors       --WHERE database_id BETWEEN 5 AND 32766       
GROUP BY database_id)SELECT   [db_name] = CASE [database_id] WHEN 32767        THEN 'Resource DB'        ELSE DB_NAME([database_id]) END,   db_buffer_pages,   db_buffer_MB = db_buffer_pages / 128,   db_buffer_percent = CONVERT(DECIMAL(6,3),        db_buffer_pages * 100.0 / @total_buffer)
FROM src
ORDER BY db_buffer_MB DESC;


--then drill down into memory used by objects in database of your choice

USE VoucherIN_LIVE; --db_with_most_memory

WITH src AS(   SELECT       [Object] = o.name,       [Type] = o.type_desc,       [Index] = COALESCE(i.name, ''),       [Index_Type] = i.type_desc,       p.[object_id],       p.index_id,       au.allocation_unit_id   
FROM       sys.partitions AS p   INNER JOIN       sys.allocation_units AS au       ON p.hobt_id = au.container_id   INNER JOIN       sys.objects AS o       ON p.[object_id] = o.[object_id]   INNER JOIN       sys.indexes AS i       ON o.[object_id] = i.[object_id]       AND p.index_id = i.index_id   WHERE       au.[type] IN (1,2,3)       AND o.is_ms_shipped = 0)
SELECT   src.[Object],   src.[Type],   src.[Index],   src.Index_Type,   buffer_pages = COUNT_BIG(b.page_id),   buffer_mb = COUNT_BIG(b.page_id) / 128
FROM   src
INNER JOIN   sys.dm_os_buffer_descriptors AS b  
 ON src.allocation_unit_id = b.allocation_unit_id
WHERE   b.database_id = DB_ID()
GROUP BY   src.[Object],   src.[Type],   src.[Index],   src.Index_Type
ORDER BY   buffer_pages DESC;

Voucher_Final
-- Top Cached SPs By Total Logical Reads (SQL 2008). Logical reads relate to memory pressure
-- This helps you find the most expensive cached stored procedures from a memory perspective
-- You should look at this if you see signs of memory pressure

SELECT TOP(25) p.name AS [SP Name], qs.total_logical_reads AS [TotalLogicalReads],
qs.total_logical_reads/qs.execution_count AS [AvgLogicalReads],qs.execution_count,
ISNULL(qs.execution_count/DATEDIFF(Second, qs.cached_time, GETDATE()), 0) AS [Calls/Second],
qs.total_elapsed_time, qs.total_elapsed_time/qs.execution_count
AS [avg_elapsed_time], qs.cached_time
FROM sys.procedures AS p
INNER JOIN sys.dm_exec_procedure_stats AS qs
ON p.[object_id] = qs.[object_id]
WHERE qs.database_id = DB_ID()
ORDER BY qs.total_logical_reads DESC;


-- This helps you find the most expensive cached stored procedures from a memory perspective
-- You should look at this if you see signs of memory pressure
-- Top Cached SPs By Total Physical Reads (SQL 2008). Physical reads relate to disk I/O pressure
SELECT TOP(25) p.name AS [SP Name],qs.total_physical_reads AS [TotalPhysicalReads],
qs.total_physical_reads/qs.execution_count AS [AvgPhysicalReads], qs.execution_count,
qs.total_logical_reads,qs.total_elapsed_time, qs.total_elapsed_time/qs.execution_count
AS [avg_elapsed_time], qs.cached_time
FROM sys.procedures AS p
INNER JOIN sys.dm_exec_procedure_stats AS qs
ON p.[object_id] = qs.[object_id]
WHERE qs.database_id = DB_ID()
ORDER BY qs.total_physical_reads, qs.total_logical_reads DESC;




/**********************************************************************************************************************/

--How to find the largest sql index and table size
/**********************************************************************************************************************/

--Step1:
CREATE TABLE #TableSpaceUsed
(
Table_name NVARCHAR(255),
Table_rows INT,
Reserved_KB VARCHAR(20),
Data_KB VARCHAR(20),
Index_Size_KB VARCHAR(20),
Unused_KB VARCHAR(20)
)

--Step2:
INSERT INTO #TableSpaceUsed
EXEC sp_msforeachtable 'sp_spaceused ''?'''


--Step3:
select * from #TableSpaceUsed order by Table_rows desc

--Step4:
SELECT Table_name,Table_Rows,
CONVERT(INT,SUBSTRING(Index_Size_KB,1,LEN(Index_Size_KB) -2)) as indexSizeKB,
CONVERT(INT,SUBSTRING(Data_KB,1,LEN(Data_KB) -2)) as dataKB,
CONVERT(INT,SUBSTRING(Reserved_KB,1,LEN(Reserved_KB) -2)) as reservedKB,
CONVERT(INT,SUBSTRING(Unused_KB,1,LEN(Unused_KB) -2)) as unusedKB
FROM #TableSpaceUsed
ORDER BY dataKB DESC

--Step5:
DROP TABLE #TableSpaceUsed


---------------------------------------------------------
/*
Best Practices:
~~~~~~~~~~~~~~~
We recommend that you follow these best practices.
The buffer pool extension size can be up to 32 times the value of max_server_memory for Enterprise editions, 
and up to 4 times for Standard edition. We recommend a ratio between the size of the physical memory (max_server_memory) 
and the size of the buffer pool extension of 1:16 or less. A lower ratio in the range of 1:4 to 1:8 may be optimal.
For information about setting the max_server_memory option, see Server Memory Server Configuration Options.
Test the buffer pool extension thoroughly before implementing in a production environment.
Once in production, avoid making configuration changes to the file or turning the feature off. These activities may have 
a negative impact on server performance because the buffer pool is significantly reduced in size when the feature is disabled. 
When disabled, the memory used to support the feature is not reclaimed until the instance of SQL Server is restarted. 
However, if the feature is re-enabled, the memory will be reused without restarting the instance.
https://msdn.microsoft.com/en-us/library/dn133176.aspx
*/
 sp_configure max_server_memory
 SELECT
(physical_memory_in_use_kb/1024) AS Memory_usedby_Sqlserver_MB,
(locked_page_allocations_kb/1024) AS Locked_pages_used_Sqlserver_MB,
(total_virtual_address_space_kb/1024) AS Total_VAS_in_MB,
process_physical_memory_low,
process_virtual_memory_low
FROM sys.dm_os_process_memory;


SELECT path, file_id, state, state_description, current_size_in_kb
FROM sys.dm_os_buffer_pool_extension_configuration;

SELECT COUNT(*) AS cached_pages_count
FROM sys.dm_os_buffer_descriptors
WHERE is_in_bpool_extension <> 0;