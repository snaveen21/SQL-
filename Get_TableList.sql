      
DECLARE @TableName VARCHAR(100)    --For storing values in the cursor        
        
--Cursor to get the name of all user tables from the sysobjects listing        
DECLARE tableCursor CURSOR        
FOR         
select [name]        
from dbo.sysobjects         
where  OBJECTPROPERTY(id, N'IsUserTable') = 1        
FOR READ ONLY        

--drop table #TempTable        
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
FETCH NEXT FROM tableCursor INTO @TableName        
        
--Loop until the cursor was not able to fetch        
WHILE (@@Fetch_Status >= 0)        
BEGIN        
    --Dump the results of the sp_spaceused query to the temp table        
    INSERT  #TempTable        
        EXEC sp_spaceused @TableName        
                
    --Get the next table name        
    FETCH NEXT FROM tableCursor INTO @TableName        
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
      
select  db_name() as [Database] ,tableName, numberofRows
, cast(replace(reservedSize , 'KB','') as Int) reservedSizeKB
, cast(replace(dataSize , 'KB','')as Int) DataSizeKB
, cast(replace(indexSize , 'KB','')as Int) indexSizeKB
, cast(replace(unusedSize , 'KB','')as Int) unusedSizeKB, createdDate   
--INTO #TempTableFINAL
FROM #TempTable      
order by 4 desc --replace(reservedSize  , 'KB','') desc


       
--Final cleanup!        
DROP TABLE #TempTable        
--DROP TABLE #TempTableFINAL 
DROP TABLE #temp2  
--DROP TABLE #temp2 





