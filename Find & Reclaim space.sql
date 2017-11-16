--
-- Author: Naveen

-- Description:
 
--Sproc to check data and log files sizes, usedspace and
--unused space
 
--Usage : To database size of a particular database
--
-- EXECUTE uspCheckDBSize
-- @dbname = <DatabaseName>
-- GO
--
--Usage : To database size of all databases
--
-- EXECUTE uspCheckDBSize
-- GO
--
--========================================================
--

 --========================================================
 
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[uspCheckDBSize]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[uspCheckDBSize]
GO
CREATE PROCEDURE uspCheckDBSize
 @dbname SYSNAME = NULL
AS
BEGIN
 DECLARE @cmd NVARCHAR(4000)
 
CREATE TABLE #dbsizes
 (
 DatabaseName SYSNAME,
 DBFileName SYSNAME,
 FileSizeMB NUMERIC(10,2),
 UsedSpaceMB NUMERIC(10,2),
 UnusedSpaceMB NUMERIC(10,2),
 FileType SYSNAME
 )
 IF @dbname IS NULL
 BEGIN
 SET @dbname='?'
 END
 
--&nbsp;
 
SET @cmd=N'USE '+@dbname+N';
 SELECT
 DB_NAME() AS [DatabaseName],
 [DBFileName] = ISNULL(a.name, ''*** Total size of the database ***''),
 [FileSizeMB] = CONVERT(NUMERIC(10, 2), SUM(ROUND(a.size / 128., 2))) ,
 [UsedSpaceMB] = CONVERT(NUMERIC(10, 2), SUM(ROUND(FILEPROPERTY(a.name,
 ''SpaceUsed'')
 / 128., 2))) ,
 [UnusedSpaceMB] = CONVERT(NUMERIC(10, 2), SUM(ROUND(( a.size
 - FILEPROPERTY(a.name,
 ''SpaceUsed'') )
 / 128., 2))) ,
 [Type] = CASE WHEN a.groupid IS NULL THEN '' ''
 WHEN a.groupid = 0 THEN ''Log''
 ELSE ''Data''
 END
 FROM sysfiles a
 GROUP BY groupid ,
 a.name
 WITH ROLLUP
 HAVING a.groupid IS NULL
 OR a.name IS NOT NULL
 ORDER BY CASE WHEN a.groupid IS NULL THEN 99
 WHEN a.groupid = 0 THEN 0
 ELSE 1
 END ,
 a.groupid ,
 CASE WHEN a.name IS NULL THEN 99
 ELSE 0
 END ,
 a.name'
 
 PRINT @CMD
 
IF @dbname = '?'
 BEGIN
 INSERT INTO #dbsizes
 EXECUTE sp_msforeachdb @CMD
 END
 ELSE
 BEGIN
 INSERT INTO #dbsizes
 EXECUTE sp_executesql @statement=@cmd
 END
 
SELECT * FROM #dbsizes
 
DROP TABLE #dbsizes
 
END
GO

/*
 EXECUTE uspCheckDBSize @dbname = GBRVIEW

 GO
 
 
 EDWFTD_REP -- Done
FRAVIEW
GBRVIEW
msdb
DNKVIEW
master
DBMONITOR
NLDVIEW
POLVIEW
DEUVIEW
ESPVIEW
tempdb
dbmonitorfromOds2
AUSVIEW
CRM
CHEVIEW
ReportServer
ReportServerTempDB
SpotlightPlaybackDatabase
 
 DROP procedure uspCheckDBSize*/
 
 
 
 
 
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
-- WHERE [vfs].[file_id] = 2 -- log files
-- ORDER BY [Latency] DESC
-- ORDER BY [ReadLatency] DESC
ORDER BY 7 DESC;
GO
