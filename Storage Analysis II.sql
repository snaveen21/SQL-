
EXEC DNKView..sp_helpfile;




------------------------------Data file size---------------------------- 
if exists (select * from tempdb.sys.all_objects where name like '%#dbsize%') 
drop table #dbsize 
create table #dbsize 
(Dbname sysname,dbstatus varchar(50),Recovery_Model varchar(40) default ('NA'), file_Size_MB decimal(30,2)default (0),Space_Used_MB decimal(30,2)default (0),Free_Space_MB decimal(30,2) default (0)) 
go 
  
insert into #dbsize(Dbname,dbstatus,Recovery_Model,file_Size_MB,Space_Used_MB,Free_Space_MB) 
exec sp_msforeachdb 
'use [?]; 
  select DB_NAME() AS DbName, 
    CONVERT(varchar(20),DatabasePropertyEx(''?'',''Status'')) ,  
    CONVERT(varchar(20),DatabasePropertyEx(''?'',''Recovery'')),  
sum(size)/128.0 AS File_Size_MB, 
sum(CAST(FILEPROPERTY(name, ''SpaceUsed'') AS INT))/128.0 as Space_Used_MB, 
SUM( size)/128.0 - sum(CAST(FILEPROPERTY(name,''SpaceUsed'') AS INT))/128.0 AS Free_Space_MB  
from sys.database_files  where type=0 group by type' 
  
  
  select * from #dbsize order by 4
  
  
go 
  
-------------------log size-------------------------------------- 
  if exists (select * from tempdb.sys.all_objects where name like '#logsize%') 
drop table #logsize 
create table #logsize 
(Dbname sysname, Log_File_Size_MB decimal(38,2)default (0),log_Space_Used_MB decimal(30,2)default (0),log_Free_Space_MB decimal(30,2)default (0)) 
go 
  
insert into #logsize(Dbname,Log_File_Size_MB,log_Space_Used_MB,log_Free_Space_MB) 
exec sp_msforeachdb 
'use [?]; 
  select DB_NAME() AS DbName, 
sum(size)/128.0 AS Log_File_Size_MB, 
sum(CAST(FILEPROPERTY(name, ''SpaceUsed'') AS INT))/128.0 as log_Space_Used_MB, 
SUM( size)/128.0 - sum(CAST(FILEPROPERTY(name,''SpaceUsed'') AS INT))/128.0 AS log_Free_Space_MB  
from sys.database_files  where type=1 group by type' 
  
    select * from #logsize order by 2 desc
go 
--------------------------------database free size 
  if exists (select * from tempdb.sys.all_objects where name like '%#dbfreesize%') 
drop table #dbfreesize 
create table #dbfreesize 
(name sysname, 
database_size varchar(50), 
Freespace varchar(50)default (0.00)) 
  
insert into #dbfreesize(name,database_size,Freespace) 
exec sp_msforeachdb 
'use [?];SELECT database_name = db_name() 
    ,database_size = ltrim(str((convert(DECIMAL(15, 2), dbsize) + convert(DECIMAL(15, 2), logsize)) * 8192 / 1048576, 15, 2) + ''MB'') 
    ,''unallocated space'' = ltrim(str(( 
                CASE  
                    WHEN dbsize >= reservedpages 
                        THEN (convert(DECIMAL(15, 2), dbsize) - convert(DECIMAL(15, 2), reservedpages)) * 8192 / 1048576 
                    ELSE 0 
                    END 
                ), 15, 2) + '' MB'') 
FROM ( 
    SELECT dbsize = sum(convert(BIGINT, CASE  
                    WHEN type = 0 
                        THEN size 
                    ELSE 0 
                    END)) 
        ,logsize = sum(convert(BIGINT, CASE  
                    WHEN type <> 0 
                        THEN size 
                    ELSE 0 
                    END)) 
    FROM sys.database_files 
) AS files 
,( 
    SELECT reservedpages = sum(a.total_pages) 
        ,usedpages = sum(a.used_pages) 
        ,pages = sum(CASE  
                WHEN it.internal_type IN ( 
                        202 
                        ,204 
                        ,211 
                        ,212 
                        ,213 
                        ,214 
                        ,215 
                        ,216 
                        ) 
                    THEN 0 
                WHEN a.type <> 1 
                    THEN a.used_pages 
                WHEN p.index_id < 2 
                    THEN a.data_pages 
                ELSE 0 
                END) 
    FROM sys.partitions p 
    INNER JOIN sys.allocation_units a 
        ON p.partition_id = a.container_id 
    LEFT JOIN sys.internal_tables it 
        ON p.object_id = it.object_id 
) AS partitions' 



select * from #dbfreesize order by 3 desc
----------------------------------- 
  
  
  
if exists (select * from tempdb.sys.all_objects where name like '%#alldbstate%') 
drop table #alldbstate  
create table #alldbstate  
(dbname sysname, 
DBstatus varchar(55), 
R_model Varchar(30)) 
   
--select * from sys.master_files 
  
insert into #alldbstate (dbname,DBstatus,R_model) 
select name,CONVERT(varchar(20),DATABASEPROPERTYEX(name,'status')),recovery_model_desc from sys.databases 
--select * from #dbsize 
  
insert into #dbsize(Dbname,dbstatus,Recovery_Model) 
select dbname,dbstatus,R_model from #alldbstate where DBstatus <> 'online' 
  
insert into #logsize(Dbname) 
select dbname from #alldbstate where DBstatus <> 'online' 
  
insert into #dbfreesize(name) 
select dbname from #alldbstate where DBstatus <> 'online' 
  

select    
d.Dbname,d.dbstatus,d.Recovery_Model, 
(file_size_mb + log_file_size_mb) as DBsize, 
d.file_Size_MB,d.Space_Used_MB,d.Free_Space_MB, 
l.Log_File_Size_MB,log_Space_Used_MB,l.log_Free_Space_MB,fs.Freespace as DB_Freespace 
from #dbsize d join #logsize l  
on d.Dbname=l.Dbname join #dbfreesize fs  
on d.Dbname=fs.name 
order by 4 desc
 
 
 
 
 ---------------------------------------------------- DATA File Locations ------------------------------
 
SELECT
    --virtual file latency
    [ReadLatency] =
        CASE WHEN [num_of_reads] = 0
            THEN 0 ELSE ([io_stall_read_ms] / [num_of_reads]) END,
    [WriteLatency] =
        CASE WHEN [num_of_writes] = 0
            THEN 0 ELSE ([io_stall_write_ms] / [num_of_writes]) END,
    [Latency] =
        CASE WHEN ([num_of_reads] = 0 AND [num_of_writes] = 0)
            THEN 0 ELSE ([io_stall] / ([num_of_reads] + [num_of_writes])) END,
    --avg bytes per IOP
    [AvgBPerRead] =
        CASE WHEN [num_of_reads] = 0
            THEN 0 ELSE ([num_of_bytes_read] / [num_of_reads]) END,
    [AvgBPerWrite] =
        CASE WHEN [num_of_writes] = 0
            THEN 0 ELSE ([num_of_bytes_written] / [num_of_writes]) END,
    [AvgBPerTransfer] =
        CASE WHEN ([num_of_reads] = 0 AND [num_of_writes] = 0)
            THEN 0 ELSE
                (([num_of_bytes_read] + [num_of_bytes_written]) /
                ([num_of_reads] + [num_of_writes])) END,
    LEFT ([mf].[physical_name], 2) AS [Drive],
    DB_NAME ([vfs].[database_id]) AS [DB],
    --[vfs].*,
    [mf].[physical_name]
FROM
    sys.dm_io_virtual_file_stats (NULL,NULL) AS [vfs]
JOIN sys.master_files AS [mf]
    ON [vfs].[database_id] = [mf].[database_id]
    AND [vfs].[file_id] = [mf].[file_id]
 --WHERE LEFT ([mf].[physical_name], 2) ='I:'
 --and [vfs].[file_id] = 2 -- log files
-- ORDER BY [Latency] DESC
-- ORDER BY [ReadLatency] DESC
ORDER BY [WriteLatency] DESC;
GO
-------------------------------------------------------------------





-- Total Free Percent
SELECT DISTINCT dovs.logical_volume_name AS LogicalName,
dovs.volume_mount_point AS Drive,
CONVERT(INT,dovs.available_bytes/1048576.0) AS FreeSpaceInMB,
CONVERT(INT,dovs.total_bytes/1048576.0) AS TotalSpaceInMB,
Convert(nvarchar,((dovs.available_bytes/1048576.0/1024.0)/(dovs.total_bytes/1024.0/1024.0/1024.0)) * 100)+'%' AS PercentageFree
FROM sys.master_files mf
CROSS APPLY sys.dm_os_volume_stats(mf.database_id, mf.FILE_ID) dovs
ORDER BY PercentageFree Asc
GO



---- To Find the Phisical Files for Each DBs


SELECT name, physical_name AS current_file_location FROM sys.master_files




--- Check the DB size

SELECT [Database Name] = DB_NAME(database_id),
       [Type] = CASE WHEN Type_Desc = 'ROWS' THEN 'Data File(s)'
                     WHEN Type_Desc = 'LOG'  THEN 'Log File(s)'
                     ELSE Type_Desc END,
       [Size in MB] = CAST( ((SUM(Size)* 8) / 1024.0) AS DECIMAL(18,2) )
FROM   sys.master_files
--– Uncomment if you need to query for a particular database
--WHERE      database_id = DB_ID(‘Database Name’)
GROUP BY      GROUPING SETS
              (
                     (DB_NAME(database_id), Type_Desc),
                     (DB_NAME(database_id))
              )
--ORDER BY      DB_NAME(database_id), Type_Desc DESC
Order by 3 desc
GO



-- File Names and Paths for TempDB and all user databases in instance (Query 11) (Database Filenames and Paths)
SELECT DB_NAME([database_id]) AS [Database Name], 
       [file_id], name, physical_name, type_desc, state_desc,
	   is_percent_growth, growth,
	   CONVERT(bigint, growth/128.0) AS [Growth in MB], 
       CONVERT(bigint, size/128.0) AS [Total Size in MB]
FROM sys.master_files WITH (NOLOCK)
WHERE [database_id] > 4 
AND [database_id] <> 32767
OR [database_id] = 2
ORDER BY DB_NAME([database_id]) OPTION (RECOMPILE);

-- Things to look at:
-- Are data files and log files on different drives?
-- Is everything on the C: drive?
-- Is TempDB on dedicated drives?
-- Is there only one TempDB data file?
-- Are all of the TempDB data files the same size?
-- Are there multiple data files for user databases?
-- Is percent growth enabled for any files (which is bad)?





--  Get File Statistics
SELECT DB_NAME(vfs.DbId) DatabaseName, mf.name,
mf.physical_name, vfs.BytesRead, vfs.BytesWritten,
vfs.IoStallMS, vfs.IoStallReadMS, vfs.IoStallWriteMS,
vfs.NumberReads, vfs.NumberWrites,
(Size*8)/1024 Size_MB
FROM ::fn_virtualfilestats(NULL,NULL) vfs
INNER JOIN sys.master_files mf ON mf.database_id = vfs.DbId
AND mf.FILE_ID = vfs.FileId
GO