
SELECT IS_SRVROLEMEMBER('sysadmin');

SELECT * FROM fn_my_permissions(NULL, 'SERVER');

-- Currently connected to the DB
SELECT @@ServerName AS server
 ,NAME AS dbname
 ,COUNT(STATUS) AS number_of_connections
 ,GETDATE() AS timestamp
FROM sys.databases sd
LEFT JOIN sysprocesses sp ON sd.database_id = sp.dbid
WHERE database_id NOT BETWEEN 1 AND 4
GROUP BY NAME


SELECT @@ServerName AS SERVER
 ,NAME
 ,login_time
 ,last_batch
 ,getdate() AS DATE
 ,STATUS
 ,hostname
 ,program_name
 ,nt_username
 ,loginame
FROM sys.databases d
LEFT JOIN sysprocesses sp ON d.database_id = sp.dbid
WHERE database_id NOT BETWEEN 0
  AND 4
 AND loginame IS NOT NULL
        
----- To check if the MSSQLSERVER is running or not.

sc query MSSQLSERVER   

------------------------------------------------------------------------------- 
-- Last Read /Write of the DB 
-- To Find UNSUED Databases
-------------------------------------------------------------------------------      
       
select  * from sys.dm_db_index_usage_stats
--
WITH agg AS
(
   SELECT
       max(last_user_seek) last_user_seek,
       max(last_user_scan) last_user_scan,
       max(last_user_lookup) last_user_lookup,
       max(last_user_update) last_user_update,
       sd.name dbname
   FROM
       sys.dm_db_index_usage_stats, master..sysdatabases sd
   WHERE
     database_id = sd.dbid group by sd.name
)
SELECT
   dbname,
   last_read = MAX(last_read),
   last_write = MAX(last_write)
FROM
(
   SELECT dbname, last_user_seek, NULL FROM agg
   UNION ALL
   SELECT dbname, last_user_scan, NULL FROM agg
   UNION ALL
   SELECT dbname, last_user_lookup, NULL FROM agg
   UNION ALL
   SELECT dbname, NULL, last_user_update FROM agg
) AS x (dbname, last_read, last_write)
GROUP BY
   dbname
ORDER BY 1;



Select database_id ,DB_NAME(database_id) as db ,max(last_user_seek) as last_user_seek ,max(last_user_scan) as last_user_scan ,max(last_user_update) as last_user_update from sys.dm_db_index_usage_stats group by database_id ,DB_NAME(database_id)

-- To find about the DB Create date and other details.
select * from SYS.databases


------------------------------------------------------------------------------- 
-- Size of the DBs 
------------------------------------------------------------------------------- 

with fs
as
(
    select database_id, type, size * 8.0 / 1024/1024 size
    from sys.master_files 
)
select 
    name,Create_Date,
    (select sum(size) from fs where type = 0 and fs.database_id = db.database_id) DataFileSizeGB,
    (select sum(size) from fs where type = 1 and fs.database_id = db.database_id) LogFileSizeGB
from sys.databases db 
Order by 3



select db_name(io.database_id) as database_name,
	mf.physical_name as file_name,
	io.* 
from sys.dm_io_virtual_file_stats(NULL, NULL) io
join sys.master_files mf on mf.database_id = io.database_id 
	and mf.file_id = io.file_id
order by (io.num_of_bytes_read + io.num_of_bytes_written) desc;

------------------------------------------------------------------------------- 
-- Size of the DBs  END
------------------------------------------------------------------------------- 



------------------------------------------------------------------------------- 
-- SQL Agent Job Activity 
------------------------------------------------------------------------------- 

USE MSDB
SELECT name AS [Job Name]
         ,CONVERT(VARCHAR,DATEADD(S,(run_time/10000)*60*60 /* hours */  
          +((run_time - (run_time/10000) * 10000)/100) * 60 /* mins */  
          + (run_time - (run_time/100) * 100)  /* secs */
           ,CONVERT(DATETIME,RTRIM(run_date),113)),100) AS [Time Run]
         ,CASE WHEN enabled=1 THEN 'Enabled'  
               ELSE 'Disabled'  
          END [Job Status]
         ,CASE WHEN SJH.run_status=0 THEN 'Failed'
                     WHEN SJH.run_status=1 THEN 'Succeeded'
                     WHEN SJH.run_status=2 THEN 'Retry'
                     WHEN SJH.run_status=3 THEN 'Cancelled'
               ELSE 'Unknown'  
          END [Job Outcome]
FROM   sysjobhistory SJH  
JOIN   sysjobs SJ  
ON     SJH.job_id=sj.job_id  
WHERE  step_id=0  
AND    DATEADD(S,  
  (run_time/10000)*60*60 /* hours */  
  +((run_time - (run_time/10000) * 10000)/100) * 60 /* mins */  
  + (run_time - (run_time/100) * 100)  /* secs */,  
  CONVERT(DATETIME,RTRIM(run_date),113)) >= DATEADD(d,-1,GetDate())  
ORDER BY name,run_date,run_time  

select * into  #tmp from exec msdb.dbo.sp_help_job

SELECT * INTO #tmp FROM OPENROWSET('SQLNCLI', 'Server=(local)\SQL2008;Trusted_Connection=yes;', 'EXEC msdb.dbo.sp_help_job')


exec msdb.dbo.sp_help_job @execution_status=4

-- Find the Offline DBs
SELECT
'DB_NAME' = db.name,
'FILE_NAME' = mf.name,
'FILE_TYPE' = mf.type_desc,
'FILE_PATH' = mf.physical_name
FROM
sys.databases db
INNER JOIN sys.master_files mf
ON db.database_id = mf.database_id
WHERE
db.state = 6 -- OFFLINE


-- To find the List of DBs that is least used.
-- We are getting that from databases have few pages in the buffer pool


select db.name, COUNT(*) As page_count
from sys.databases db LEFT JOIN sys.dm_os_buffer_descriptors bd ON db.database_id = bd.database_id
group by db.database_id, db.name
order by page_count 

-- look at the index usage stats for each database
SELECT db.name, 
(SELECT MAX(T) AS last_access FROM (SELECT MAX(last_user_lookup) AS T UNION ALL SELECT MAX(last_user_seek) UNION ALL SELECT MAX(last_user_scan) UNION ALL SELECT MAX(last_user_update)) d) last_access
FROM sys.databases db 
LEFT JOIN sys.dm_db_index_usage_stats iu ON db.database_id = iu.database_id
GROUP BY db.database_id, db.name
ORDER BY last_access 

 -- Get list of possibly unused SPs (SQL 2008 only)
    SELECT p.name AS 'SP Name'        -- Get list of all SPs in the current database
    FROM sys.procedures AS p
    WHERE p.is_ms_shipped = 0

    EXCEPT

    SELECT p.name AS 'SP Name'        -- Get list of all SPs from the current database 
    FROM sys.procedures AS p          -- that are in the procedure cache
    INNER JOIN sys.dm_exec_procedure_stats AS qs
    ON p.object_id = qs.object_id
    WHERE p.is_ms_shipped = 0;
    
-- Unused Tables.  

sp_tables 
    
    SELECT 
  t.name AS 'Table', t.Create_Date,
  t.Modify_Date,
  SUM(i.user_seeks + i.user_scans + i.user_lookups + i.user_updates) 
    AS 'Total accesses',
  SUM(i.user_seeks) AS 'Seeks',
  SUM(i.user_scans) AS 'Scans',
  SUM(i.user_lookups) AS 'Lookups',
  SUM(i.user_updates) AS 'Updates'
    
  
FROM 
  sys.dm_db_index_usage_stats i RIGHT OUTER JOIN 
    sys.tables t ON (t.object_id = i.object_id)
GROUP BY 
  i.object_id, 
  t.name,
  t.Create_Date,
  t.Modify_Date
ORDER BY [Total accesses] DESC


   
    SELECT 
  t.name AS 'Table', t.Create_Date,
  t.Modify_Date,
  SUM(i.user_seeks + i.user_scans + i.user_lookups + i.user_updates) 
    AS 'Total accesses',
  SUM(i.user_seeks) AS 'Seeks',
  SUM(i.user_scans) AS 'Scans',
  MAX(i.last_user_scan) as 'Last_Scan',
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
ORDER BY 7,9,3

select * from sys.dm_db_index_usage_stats
select * from sys.tables

-- File group
sp_helpfilegroup
select object_name(id) AS TableName, * from dbo.sysindexes where groupid = 1




-- Size taken for each Table :Table Size.
SELECT 
 t.NAME AS TableName,
 i.name AS indexName,
 SUM(p.rows) AS RowCounts,
 SUM(a.total_pages) AS TotalPages, 
 SUM(a.used_pages) AS UsedPages, 
 SUM(a.data_pages) AS DataPages,
 (SUM(a.total_pages) * 8) / 1024 AS TotalSpaceMB, 
 (SUM(a.used_pages) * 8) / 1024 AS UsedSpaceMB, 
 (SUM(a.data_pages) * 8) / 1024 AS DataSpaceMB
FROM 
 sys.tables t
INNER JOIN  
 sys.indexes i ON t.OBJECT_ID = i.object_id
INNER JOIN 
 sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id
INNER JOIN 
 sys.allocation_units a ON p.partition_id = a.container_id
WHERE 
 t.NAME NOT LIKE 'dt%' AND
 i.OBJECT_ID > 255 AND  
 i.index_id <= 1
GROUP BY 
 t.NAME, i.object_id, i.index_id, i.name 
ORDER BY 
 OBJECT_NAME(i.object_id) 
 
 
 
 

--- Worst performing quries 

Select top 10 
    total_worker_time/execution_count AS Avg_CPU_Time
        ,execution_count
        ,total_elapsed_time/execution_count as AVG_Run_Time
        ,(SELECT
              SUBSTRING(text,statement_start_offset/2,(CASE
                                                           WHEN statement_end_offset = -1 THEN LEN(CONVERT(nvarchar(max), text)) * 2 
                                                           ELSE statement_end_offset 
                                                       END -statement_start_offset)/2
                       ) FROM sys.dm_exec_sql_text(sql_handle)
         ) AS query_text 
FROM sys.dm_exec_query_stats 

--pick your criteria

ORDER BY Avg_CPU_Time DESC
--ORDER BY AVG_Run_Time DESC
--ORDER BY execution_count DESC#




-----------------------------------------------------------------------------------------------------------------------------------------
-- Performance tuning
select * from sys.dm_OS_WAIT_STATS where wait_type like 'LCK_%'




------------------------------------------------------------------------------------------------------
-- Forcasting
-- Get Past Backup Sizes for last 12 months
SELECT
    [Database] = [database_name]
    , [Month] = DATEPART(month,[backup_start_date])
    , [Backup Size MB] = AVG([backup_size]/1024/1024)
    , [Compressed Backup Size MB] = AVG([compressed_backup_size]/1024/1024)
    , [Compression Ratio] = AVG([backup_size]/[compressed_backup_size])
FROM 
    msdb.dbo.backupset
WHERE 
    [database_name] = N'VOUCHERIN_LIVE'
AND [type] = 'D'
GROUP BY 
    [database_name]
    , DATEPART(mm, [backup_start_date]);
    


select * from 
    msdb.dbo.backupset
WHERE 
    [database_name] = N'VOUCHERIN_LIVE'
AND [type] = 'D'
order by backup_start_date




-- Get CPU Utilization History for last 144 minutes (in one minute intervals)
-- This version works with SQL Server 2008 and SQL Server 2008 R2 only
DECLARE @ts_now bigint = (SELECT cpu_ticks/(cpu_ticks/ms_ticks)FROM sys.dm_os_sys_info);

SELECT TOP(144) SQLProcessUtilization AS [SQL Server Process CPU Utilization],
               SystemIdle AS [System Idle Process],
               100 - SystemIdle - SQLProcessUtilization AS [Other Process CPU Utilization],
               DATEADD(ms, -1 * (@ts_now - [timestamp]), GETDATE()) AS [Event Time]
FROM (
                  SELECT record.value('(./Record/@id)[1]', 'int') AS record_id,
                                                record.value('(./Record/SchedulerMonitorEvent/SystemHealth/SystemIdle)[1]', 'int')
                                                AS [SystemIdle],
                                                record.value('(./Record/SchedulerMonitorEvent/SystemHealth/ProcessUtilization)[1]',
                                                'int')
                                                AS [SQLProcessUtilization], [timestamp]
                  FROM (
                                                SELECT [timestamp], CONVERT(xml, record) AS [record]
                                                FROM sys.dm_os_ring_buffers
                                                WHERE ring_buffer_type = N'RING_BUFFER_SCHEDULER_MONITOR'
                                                AND record LIKE N'%<SystemHealth>%') AS x
                  ) AS y
ORDER BY record_id DESC OPTION (RECOMPILE);


-- Get CPU Utilization History (SQL 2005 Only)
    DECLARE @ts_now bigint; 
    SELECT @ts_now = cpu_ticks / CONVERT(float, cpu_ticks_in_ms) FROM sys.dm_os_sys_info 

    SELECT TOP(10) SQLProcessUtilization AS [SQL Server Process CPU Utilization], 
                   SystemIdle AS [System Idle Process], 
                   100 - SystemIdle - SQLProcessUtilization AS [Other Process CPU Utilization], 
                   DATEADD(ms, -1 * (@ts_now - [timestamp]), GETDATE()) AS [Event Time] 
    FROM ( 
          SELECT record.value('(./Record/@id)[1]', 'int') AS record_id, 
                record.value('(./Record/SchedulerMonitorEvent/SystemHealth/SystemIdle)[1]', 'int') 
                AS [SystemIdle], 
                record.value('(./Record/SchedulerMonitorEvent/SystemHealth/ProcessUtilization)[1]', 
                'int') 
                AS [SQLProcessUtilization], [timestamp] 
          FROM ( 
                SELECT [timestamp], CONVERT(xml, record) AS [record] 
                FROM sys.dm_os_ring_buffers 
                WHERE ring_buffer_type = N'RING_BUFFER_SCHEDULER_MONITOR' 
                AND record LIKE '%<SystemHealth>%') AS x 
          ) AS y 
    ORDER BY record_id DESC;








select db.name, COUNT(*) As page_count
from sys.databases db LEFT JOIN sys.dm_os_buffer_descriptors bd ON db.database_id = bd.database_id
group by db.database_id, db.name
order by page_count 