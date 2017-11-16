-- DBA Quries

-- List all the Views in the Database.
/**********************************************************************************************************************/

SELECT * FROM sys.views
SELECT [Name] FROM [sys].[objects] WHERE [type] = 'V'
SELECT [Name] FROM [dbo].[sysobjects] WHERE [xtype] = 'V'

-- Find views if its indexed or indexable
SELECT SCHEMA_NAME(schema_id) AS schema_name
,name AS view_name
,OBJECTPROPERTYEX(OBJECT_ID,'IsIndexed') AS IsIndexed
,OBJECTPROPERTYEX(OBJECT_ID,'IsIndexable') AS IsIndexable
FROM sys.views


-- Refresh the View
sp_refreshview  'v_Voucher_Customer'

/**********************************************************************************************************************/

-- Create Linked servers
/**********************************************************************************************************************/


--In Query Editor, enter the following Transact-SQL command to link to an instance of SQL Server named SRVR002\ACCTG:
USE [master]
GO
EXEC master.dbo.sp_addlinkedserver 
    @server = N'SRVR002\ACCTG', 
    @srvproduct=N'SQL Server' ;
GO

--Execute the following code to configure the linked server to use the domain credentials of the login that is using the linked server.
EXEC master.dbo.sp_addlinkedsrvlogin 
    @rmtsrvname = N'SRVR002\ACCTG', 
    @locallogin = NULL , 
    @useself = N'True' ;
GO



SELECT DISTINCT so.name,so.type_desc,idx.type_desc
FROM sys.indexes idx INNER JOIN sys.objects so ON idx.object_id = so.object_id
INNER JOIN sys.partitions p ON idx.object_id = p.object_id AND idx.index_id = p.index_id
LEFT OUTER JOIN sys.dm_db_index_usage_stats ius ON idx.object_id = ius.object_id AND idx.index_id = ius.index_id 
WHERE idx.type_desc = 'HEAP' AND COALESCE(ius.user_seeks, ius.user_scans, ius.user_lookups, ius.user_updates) IS NOT NULL
AND so.type <> 'S'
order by so.name

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


/**********************************************************************************************************************/

-- Locked Transactions:Use sys.dm_tran_locks to find requests waiting for an exclusive lock
/**********************************************************************************************************************/
select resource_type,db_name(resource_database_id),
resource_associated_entity_id,
request_mode,request_type,
request_status
from sys.dm_tran_locks

/**********************************************************************************************************************/

--Who made DDL table changes on the database.
/**********************************************************************************************************************/
select e.name as eventclass,
t.loginname,
t.spid,
t.starttime,
t.textdata,
t.objectid,
t.objectname,
t.databasename,
t.hostname,
t.ntusername,
t.ntdomainname,
t.clientprocessid,
t.applicationname,
t.error
FROM sys.fn_trace_gettable(CONVERT(VARCHAR(150), ( SELECT TOP 1f.[value]
FROM sys.fn_trace_getinfo(NULL) f WHERE f.property = 2)), DEFAULT) T
inner join sys.trace_events e on t.eventclass = e.trace_event_id
where eventclass=164

/**********************************************************************************************************************/

--Current queries executing on SQL Server
/**********************************************************************************************************************/
SELECT
r.session_id,
s.TEXT,
r.[status],
r.blocking_session_id,
r.cpu_time,
r.total_elapsed_time
FROM sys.dm_exec_requests r
CROSS APPLY sys.dm_exec_sql_text(sql_handle) AS s
/**********************************************************************************************************************/

--Restore Database Estimated Finish Time
/**********************************************************************************************************************/

