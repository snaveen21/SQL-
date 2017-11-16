--USE [DBMONITOR]
--GO

--/****** Object:  StoredProcedure [dbo].[GetAllTableSizes]    Script Date: 01/21/2014 11:16:24 ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO


 
--      --sp_helpdb
      
----sp_tables        
        
--CREATE PROCEDURE [dbo].[GetAllTableSizes]        
--AS        
/*        
    Obtains spaced used data for ALL user tables in the database        
*/        
DECLARE @TableName VARCHAR(100)  
declare @insquery varchar(500)  --For storing values in the cursor        
declare @TABLE_SCHEMA varchar(50)
        
--Cursor to get the name of all user tables from the sysobjects listing        
DECLARE tableCursor CURSOR        
FOR 

        
select [name], [TABLE_SCHEMA]       
from dbo.sysobjects so
inner join information_schema.tables sc 
ON so.name = sc.TABLE_NAME
where  OBJECTPROPERTY(id, N'IsUserTable') = 1  and xtype = 'U' and  name in 
(SELECT distinct o.[name] --, o.[type], i.[name], i.[index_id], f.[name]
FROM sys.indexes i
INNER JOIN sys.filegroups f
ON i.data_space_id = f.data_space_id
INNER JOIN sys.all_objects o
ON i.[object_id] = o.[object_id]
WHERE i.data_space_id = f.data_space_id
AND f.name in ('TEMP_BI_201209', 'TEMP_BI_201208'))


  
FOR READ ONLY        
        
--A procedure level temp table to store the results        
CREATE TABLE #TempTable        
(        
    tableName varchar(100),        
    numberofRows varchar(100),        
    reservedSize varchar(50),        
    dataSize varchar(50),        
    indexSize varchar(50),        
    unusedSize varchar(50)        
)        
        
--Open the cursor        
OPEN tableCursor        
        
--Get the first table name from the cursor        
FETCH NEXT FROM tableCursor INTO @TableName, @TABLE_SCHEMA        
        
--Loop until the cursor was not able to fetch        
WHILE (@@Fetch_Status >= 0)        
BEGIN        
    --Dump the results of the sp_spaceused query to the temp table        
    set @insquery = 'INSERT  #TempTable        
EXEC sp_spaceused ''['+@TABLE_SCHEMA+'].['+@TableName+']'''

--print (@insquery)
exec (@insquery)     
                      
                
    --Get the next table name        
    FETCH NEXT FROM tableCursor INTO @TableName, @TABLE_SCHEMA         
END        
        
--Get rid of the cursor        
CLOSE tableCursor        
DEALLOCATE tableCursor        
        
alter table #TempTable add createdDate  datetime        
        
select so.name, su.name name_schema, so.crdate createdDate        
into #temp2        
from sysobjects so join sysusers su on so.uid = su.uid        
where su.name <> 'sys' and  OBJECTPROPERTY(so.id, N'IsUserTable') = 1        
order by so.crdate        
        
-- select * from sysobjects        
        
update  A set a.createdDate = b.createdDate         
from #TempTable A , #temp2 b         
where a.tableName  COLLATE DATABASE_DEFAULT  = b.name COLLATE DATABASE_DEFAULT         
                
        
--Select all records so we can use the reults        
      
--insert into dbmonitor.dbo.DBA_TableClean_Med_TableList ([Database] ,tableName,numberofRows,reservedSize,dataSize,indexSize,unusedSize,createdDate )      
select  db_name() as [Database] ,tableName, numberofRows
, cast(replace(reservedSize , 'KB','') as Int) reservedSizeKB
, cast(replace(dataSize , 'KB','')as Int) DataSizeKB
, cast(replace(indexSize , 'KB','')as Int) indexSizeKB
, cast(replace(unusedSize , 'KB','')as Int) unusedSizeKB, createdDate   
--INTO #TempTableFINAL
FROM #TempTable      
order by replace(reservedSize  , 'KB','') 

--SELECT * FROM #TempTableFINAL


--SELECT db_name() as [Database] , *  into dbmonitor.dbo.tabledatalist FROM #TempTable      
        
--  use DBMONITOR      
--  go      
        
-- CREATE TABLE DBA_Tabledatalist        
--(   [Database] varchar(500),        
--    tableName varchar(100),        
--    numberofRows varchar(100),        
--    reservedSize varchar(50),        
--    dataSize varchar(50),        
--    indexSize varchar(50),        
--    unusedSize varchar(50),       
--     createdDate  datetime ,      
--     Owner varchar(255)      
--)       
      
-- select * from dbmonitor.dbo.DBA_Tabledatalist 
--select * from dbmonitor.dbo.DBA_TableClean_Med_TableList

 
       
--Final cleanup!        
DROP TABLE #TempTable        
--DROP TABLE #TempTableFINAL 
--DROP TABLE #temp2  
DROP TABLE #temp2 




--GO


