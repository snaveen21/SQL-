-------------------------------------------------------- Job Stats -------------------------------------------------------- 

---------------

use msdb
go
select 'FAILED' as Status, cast(sj.name as varchar(100)) as "Job Name",
       cast(sjs.step_id as varchar(5)) as "Step ID",
       cast(sjs.step_name as varchar(30)) as "Step Name",
       cast(REPLACE(CONVERT(varchar,convert(datetime,convert(varchar,sjh.run_date)),102),'.','-')+' '+SUBSTRING(RIGHT('000000'+CONVERT(varchar,sjh.run_time),6),1,2)+':'+SUBSTRING(RIGHT('000000'+CONVERT(varchar,sjh.run_time),6),3,2)+':'+SUBSTRING(RIGHT('000000'+CONVERT(varchar,sjh.run_time),6),5,2) as varchar(30)) 'Start Date Time',
       sjh.message as "Message"
from sysjobs sj
join sysjobsteps sjs 
 on sj.job_id = sjs.job_id
join sysjobhistory sjh 
 on sj.job_id = sjh.job_id and sjs.step_id = sjh.step_id
where sjh.run_status <> 1
  and cast(sjh.run_date as float)*1000000+sjh.run_time > 
      cast(convert(varchar(8), getdate()-1, 112) as float)*1000000+70000 --yesterday at 7am
union
select 'FAILED',cast(sj.name as varchar(100)) as "Job Name",
       'MAIN' as "Step ID",
       'MAIN' as "Step Name",
       cast(REPLACE(CONVERT(varchar,convert(datetime,convert(varchar,sjh.run_date)),102),'.','-')+' '+SUBSTRING(RIGHT('000000'+CONVERT(varchar,sjh.run_time),6),1,2)+':'+SUBSTRING(RIGHT('000000'+CONVERT(varchar,sjh.run_time),6),3,2)+':'+SUBSTRING(RIGHT('000000'+CONVERT(varchar,sjh.run_time),6),5,2) as varchar(30)) 'Start Date Time',
       sjh.message as "Message"
from sysjobs sj
join sysjobhistory sjh 
 on sj.job_id = sjh.job_id
where sjh.run_status <> 1 and sjh.step_id=0
  and cast(sjh.run_date as float)*1000000+sjh.run_time >
      cast(convert(varchar(8), getdate()-1, 112) as float)*1000000+70000 --yesterday at 7am
      
      
----------------


    
-- All the Failed JOBs that failed.
    -- Select JOB_Name,STEP_NAME,run_status, Exec_Date as [Last Execution], SERVER, message as Error_MSG from View_Failed_Jobs
    --Select *from View_Failed_Jobs
    
-- All the Enabled Jobs in the Server That Failed.  

---- ****** USE THIS ****** ---- 
Use master
go 

Select  A.JOB_Name, A.STEP_NAME,
(CASE B.Enabled
    WHEN 0 THEN 'DISABLED'
    WHEN 1 THEN 'ENABLED'
END) as JOBSchdule_Status, 
A.run_status, A.Exec_Date as [Last Execution], A.SERVER, A.message as Error_MSG
From View_Failed_Jobs A
Inner Join msdb.dbo.sysjobs B on A.job_id = B.job_id where B.enabled=1

---- ****** USE THIS ****** ----     



select top 10 * from dbo.View_Success_Jobs

Select  A.JOB_Name, A.STEP_NAME,
(CASE B.Enabled
    WHEN 0 THEN 'DISABLED'
    WHEN 1 THEN 'ENABLED'
END) as JOBSchdule_Status, 
A.run_status, A.Exec_Date as [Last Execution], A.SERVER, A.message as Error_MSG
From View_Success_Jobs A
Inner Join msdb.dbo.sysjobs B on A.job_id = B.job_id where B.enabled=1



Select  A.JOB_Name, A.STEP_NAME,
(CASE B.Enabled
    WHEN 0 THEN 'DISABLED'
    WHEN 1 THEN 'ENABLED'
END) as JOBSchdule_Status, 
A.run_status, A.Exec_Date as [Last Execution], A.SERVER, A.message as Error_MSG
From View_Failed_Jobs A
Inner Join msdb.dbo.sysjobs B on A.job_id = B.job_id where B.enabled=1



    
-- All the Enabled Jobs in the Server.    
Select A.job_id, B.name, 
last_outcome_message,*
From msdb.dbo.SysJobServers A
Inner Join msdb.dbo.sysjobs B on A.job_id = B.job_id where B.enabled=1



-------------------------------------------------------- BACKUPs -------------------------------------------------------- 
-- SQLSERVER 2008
-- Look at recent Full backups for the current database (Query 51) (Recent Full Backups)
SELECT TOP (30) bs.server_name, bs.database_name AS [Database Name], 
CONVERT (BIGINT, bs.backup_size / 1048576 ) AS [Backup Size (MB)],
DATEDIFF (SECOND, bs.backup_start_date, bs.backup_finish_date) AS [Backup Elapsed Time (sec)],
bs.backup_finish_date AS [Backup Finish Date],bs.type as [BackupType]
FROM msdb.dbo.backupset AS bs WITH (NOLOCK)
WHERE DATEDIFF (SECOND, bs.backup_start_date, bs.backup_finish_date) > 0 
AND bs.backup_size > 0
--AND bs.type = 'D' -- Change to L if you want Log backups
AND database_name = DB_NAME(DB_ID())
ORDER BY bs.backup_finish_date DESC OPTION (RECOMPILE);



-- Are your backup sizes and times changing over time?
/*
Backup type. Can be:
D = Database
I = Differential database
L = Log
F = File or filegroup
G =Differential file
P = Partial
Q = Differential partial
Can be NULL.
*/

-- ******************************************* USE this to Get Lebara Backup  ***********************************
select database_name, backup_start_date,backup_finish_date , 
case  type when  'I' then 'Differential Database' when  'D' then 'FULL' when 'L' then 'Log' when 'F' then 'File or filegroup' when 'G' then 'Differential file'  else 'Other' end Type, 
left(physical_device_name,len(physical_device_name) -(CHARINDEX('\', REVERSE(physical_device_name)))+1) Location,
Datename(weekday, backup_finish_date ) Day, 
datediff ( HH, backup_start_date ,
backup_finish_date)Hours , 
backup_size/1028/1028 SizeinGB
from msdb..backupset a, msdb..backupmediafamily b
where a.media_set_id = b.media_set_id 
--and database_name = 'RAPOLTTD'  
and type = 'D'
order by a.backup_start_date desc 




-------------------------------------------------------- Storage -------------------------------------------------------- 

-- 2008 onwards  Storage percentage free.

SELECT DISTINCT dovs.logical_volume_name AS LogicalName,
dovs.volume_mount_point AS Drive,
CONVERT(INT,dovs.available_bytes/1048576.0) AS FreeSpaceInMB,
CONVERT(INT,dovs.total_bytes/1048576.0) AS TotalSpaceInMB,
Convert(nvarchar,((dovs.available_bytes/1048576.0/1024.0)/(dovs.total_bytes/1024.0/1024.0/1024.0)) * 100)+'%' AS PercentageFree
FROM sys.master_files mf
CROSS APPLY sys.dm_os_volume_stats(mf.database_id, mf.FILE_ID) dovs
where Convert(INT,((dovs.available_bytes/1048576.0/1024.0)/(dovs.total_bytes/1024.0/1024.0/1024.0)) * 100) < '60'
ORDER BY PercentageFree Asc
GO



--- 2005

declare @chkCMDShell as sql_variant
select @chkCMDShell = value from sys.configurations where name = 'xp_cmdshell'
if @chkCMDShell = 0
begin
 EXEC sp_configure 'xp_cmdshell', 1
 RECONFIGURE;
end
else
begin
 Print 'xp_cmdshell is already enabled'
end


declare @svrName varchar(255)
declare @sql varchar(400)
--by default it will take the current server name, we can the set the server name as well
set @svrName = @@SERVERNAME
set @sql = 'powershell.exe -c "Get-WmiObject -ComputerName ' + QUOTENAME(@svrName,'''') + ' -Class Win32_Volume -Filter ''DriveType = 3'' | select name,capacity,freespace | foreach{$_.name+''|''+$_.capacity/1048576+''%''+$_.freespace/1048576+''*''}"'
--creating a temporary table
CREATE TABLE #output
(line varchar(255))
--inserting disk name, total space and free space value in to temporary table
insert #output
EXEC xp_cmdshell @sql
--script to retrieve the values in MB from PS Script output
select rtrim(ltrim(SUBSTRING(line,1,CHARINDEX('|',line) -1))) as drivename
      ,round(cast(rtrim(ltrim(SUBSTRING(line,CHARINDEX('|',line)+1,
      (CHARINDEX('%',line) -1)-CHARINDEX('|',line)) )) as Float),0) as 'capacity(MB)'
      ,round(cast(rtrim(ltrim(SUBSTRING(line,CHARINDEX('%',line)+1,
      (CHARINDEX('*',line) -1)-CHARINDEX('%',line)) )) as Float),0) as 'freespace(MB)'
into #Output_percent from #output
where line like '[A-Z][:]%'
order by drivename
--script to retrieve the values in GB from PS Script output
select rtrim(ltrim(SUBSTRING(line,1,CHARINDEX('|',line) -1))) as drivename
      ,round(cast(rtrim(ltrim(SUBSTRING(line,CHARINDEX('|',line)+1,
      (CHARINDEX('%',line) -1)-CHARINDEX('|',line)) )) as Float)/1024,0) as 'capacity(GB)'
      ,round(cast(rtrim(ltrim(SUBSTRING(line,CHARINDEX('%',line)+1,
      (CHARINDEX('*',line) -1)-CHARINDEX('%',line)) )) as Float) /1024 ,0)as 'freespace(GB)'
from #output
where line like '[A-Z][:]%'
order by drivename

select drivename,[capacity(MB)],[freespace(MB)],round (((100/[capacity(MB)])*[freespace(MB)]),2,0) as [%free] from #Output_percent

--script to drop the temporary table
drop table #output
drop table #Output_percent

-------------------------------------------------------- CPU Utilization -------------------------------------------------------- 
--Get CPU Utilization History for last 144 minutes (in one minute intervals)
--- 2008 and after
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
    
    
    
    
-- Get CPU utilization by database (Query 18) (CPU Usage by Database)
WITH DB_CPU_Stats
AS
(SELECT DatabaseID, DB_Name(DatabaseID) AS [Database Name], SUM(total_worker_time) AS [CPU_Time_Ms]
 FROM sys.dm_exec_query_stats AS qs
 CROSS APPLY (SELECT CONVERT(int, value) AS [DatabaseID] 
              FROM sys.dm_exec_plan_attributes(qs.plan_handle)
              WHERE attribute = N'dbid') AS F_DB
 GROUP BY DatabaseID)
SELECT ROW_NUMBER() OVER(ORDER BY [CPU_Time_Ms] DESC) AS [CPU Rank],
       [Database Name], [CPU_Time_Ms] AS [CPU Time (ms)], 
       CAST([CPU_Time_Ms] * 1.0 / SUM([CPU_Time_Ms]) OVER() * 100.0 AS DECIMAL(5, 2)) AS [CPU Percent]
FROM DB_CPU_Stats
WHERE DatabaseID <> 32767 -- ResourceDB
ORDER BY [CPU Rank] OPTION (RECOMPILE);

--Logging_Bundles




-- Top Cached SPs By Total Worker time (SQL Server 2012). 
-- Worker time relates to CPU cost  (Query 44) (SP Worker Time)

SELECT TOP (25) 
  p.name AS [SP Name], 
  qs.total_worker_time AS [TotalWorkerTime], 
  qs.total_worker_time/qs.execution_count AS [AvgWorkerTime], 
  qs.execution_count, 
  ISNULL(qs.execution_count/DATEDIFF(Second, qs.cached_time, GETDATE()), 0) 
    AS [Calls/Second],
  qs.total_elapsed_time, 
  qs.total_elapsed_time/qs.execution_count AS [avg_elapsed_time], 
  qs.cached_time
FROM sys.procedures AS p WITH (NOLOCK)
INNER JOIN sys.dm_exec_procedure_stats AS qs WITH (NOLOCK)
ON p.[object_id] = qs.[object_id]
WHERE qs.database_id = DB_ID()
ORDER BY qs.total_worker_time DESC OPTION (RECOMPILE);



SELECT TOP (25)
    qs.sql_handle,
    qs.execution_count,
    qs.total_worker_time AS Total_CPU,
    total_CPU_inSeconds = --Converted from microseconds
    qs.total_worker_time/1000000,
    average_CPU_inSeconds = --Converted from microseconds
    (qs.total_worker_time/1000000) / qs.execution_count,
    qs.total_elapsed_time,
    total_elapsed_time_inSeconds = --Converted from microseconds
    qs.total_elapsed_time/1000000,
    st.text,
    qp.query_plan
FROM sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st
CROSS apply sys.dm_exec_query_plan (qs.plan_handle) AS qp
ORDER BY qs.total_worker_time DESC OPTION (RECOMPILE);


--To determine how many times a stored procedure in the cache has been executed

SELECT DB_NAME(st.dbid) DBName
      ,OBJECT_SCHEMA_NAME(st.objectid,dbid) SchemaName
      ,OBJECT_NAME(st.objectid,dbid) StoredProcedure
      ,max(cp.usecounts) Execution_count
 FROM sys.dm_exec_cached_plans cp
         CROSS APPLY sys.dm_exec_sql_text(cp.plan_handle) st
 where DB_NAME(st.dbid) is not null and cp.objtype = 'proc'
   group by cp.plan_handle, DB_NAME(st.dbid),
            OBJECT_SCHEMA_NAME(objectid,st.dbid), 
   OBJECT_NAME(objectid,st.dbid) 
 order by max(cp.usecounts) desc
 
 
 --Determining Which SP is using the Most CPU, I/O, or has the Longest Duration.
 
 SELECT DB_NAME(st.dbid) DBName
      ,OBJECT_SCHEMA_NAME(st.objectid,dbid) SchemaName
      ,OBJECT_NAME(st.objectid,dbid) StoredProcedure
      ,max(cp.usecounts) Execution_count
      ,sum(qs.total_worker_time) total_cpu_time
      ,sum(qs.total_worker_time) / (max(cp.usecounts) * 1.0)  avg_cpu_time
 
 FROM sys.dm_exec_cached_plans cp join sys.dm_exec_query_stats qs on cp.plan_handle = qs.plan_handle
      CROSS APPLY sys.dm_exec_sql_text(cp.plan_handle) st
 where DB_NAME(st.dbid) is not null and cp.objtype = 'proc'
 group by DB_NAME(st.dbid),OBJECT_SCHEMA_NAME(objectid,st.dbid), OBJECT_NAME(objectid,st.dbid) 
 order by sum(qs.total_worker_time) desc
 
 --To determine which SP has executed the most I/O requests you can run the following TSQL code
 SELECT DB_NAME(st.dbid) DBName
      ,OBJECT_SCHEMA_NAME(objectid,st.dbid) SchemaName
      ,OBJECT_NAME(objectid,st.dbid) StoredProcedure
      ,max(cp.usecounts) execution_count
      ,sum(qs.total_physical_reads + qs.total_logical_reads + qs.total_logical_writes) total_IO
      ,sum(qs.total_physical_reads + qs.total_logical_reads + qs.total_logical_writes) / (max(cp.usecounts)) avg_total_IO
      ,sum(qs.total_physical_reads) total_physical_reads
      ,sum(qs.total_physical_reads) / (max(cp.usecounts) * 1.0) avg_physical_read    
      ,sum(qs.total_logical_reads) total_logical_reads
      ,sum(qs.total_logical_reads) / (max(cp.usecounts) * 1.0) avg_logical_read  
      ,sum(qs.total_logical_writes) total_logical_writes
      ,sum(qs.total_logical_writes) / (max(cp.usecounts) * 1.0) avg_logical_writes  
 FROM sys.dm_exec_query_stats qs CROSS APPLY sys.dm_exec_sql_text(qs.plan_handle) st
   join sys.dm_exec_cached_plans cp on qs.plan_handle = cp.plan_handle
  where DB_NAME(st.dbid) is not null and cp.objtype = 'proc'
 group by DB_NAME(st.dbid),OBJECT_SCHEMA_NAME(objectid,st.dbid), OBJECT_NAME(objectid,st.dbid) 
 order by sum(qs.total_physical_reads + qs.total_logical_reads + qs.total_logical_writes) desc
 
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

 
 
 
 SELECT * FROM sys.dm_os_memory_clerks ORDER BY (single_pages_kb + multi_pages_kb + awe_allocated_kb) desc
 
 
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