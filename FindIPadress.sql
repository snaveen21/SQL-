
-- SQL and OS Version information for current instance  (Query 1) (Version Info)
SELECT SERVERPROPERTY ('MachineName') AS [Server Name], @@VERSION AS [SQL Server and OS Version Info];

-- Find IP
SELECT SERVERPROPERTY('ComputerNamePhysicalNetBIOS') [Machine Name]
   ,SERVERPROPERTY('InstanceName') AS [Instance Name]
   ,LOCAL_NET_ADDRESS AS [IP Address Of SQL Server]
   ,CLIENT_NET_ADDRESS AS [IP Address Of Client]
 FROM SYS.DM_EXEC_CONNECTIONS 
 WHERE SESSION_ID = @@SPID
 
 -- Find DBs from a Server
 
 with fs
as
(
    select database_id, type, size * 8.0 / 1024 size
    from sys.master_files
)
select 
    name,'',
    (select sum(size) from fs where type = 0 and fs.database_id = db.database_id) DataFileSizeMB,
    db.create_date,
    (select sum(size) from fs where type = 1 and fs.database_id = db.database_id) LogFileSizeMB
from sys.databases db
where name not in ('Master','tempdb','model','msdb','reportServer','ReportServerTempDB') 
 
 
 SELECT *
FROM master..sysdatabases
Microsoft SQL Server 2014 - 12.0.2000.8 (X64)