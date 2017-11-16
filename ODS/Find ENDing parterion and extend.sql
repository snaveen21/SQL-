


/*

select * from sys.partition_functions  --  65543
go

select * from sys.partitions


select top 1000 * from sys.partition_range_values --where function_id= 65547   -- >> BOUNDRY_ID  = 2
GO


Select distinct ps.Name AS PartitionScheme, pf.name AS PartitionFunction,fg.name AS FileGroupName, rv.value ,ps.function_id   AS PartitionFunctionValue
INTO #TEMP2
    from sys.indexes i  
    join sys.partitions p ON i.object_id=p.object_id AND i.index_id=p.index_id  
    join sys.partition_schemes ps on ps.data_space_id = i.data_space_id  
    join sys.partition_functions pf on pf.function_id = ps.function_id  
    left join sys.partition_range_values rv on rv.function_id = pf.function_id AND rv.boundary_id = p.partition_number
    join sys.allocation_units au  ON au.container_id = p.hobt_id   
    join sys.filegroups fg  ON fg.data_space_id = au.data_space_id  
    
SELECT * FROM #TEMP
GO
SELECT * FROM #TEMP2
GO


*/


--------------------- STEP 1

USE DEUTMOBVIEW_ARCHIVE
GO



SELECT  @@SERVERNAME AS SERVER , DB_NAME() AS DBNAME ,
A.NAME AS PARTION_FUNCTION,  C.NAME AS PARTITION_SCHEMA, A.FUNCTION_ID, MIN( B.BOUNDARY_ID ) AS MIN_BOUNDRY_ID  , MAX (B.BOUNDARY_ID )AS MAX_BOUNDRY_ID 
INTO #TEMP
FROM  sys.partition_functions  A JOIN  sys.partition_range_values B ON A.function_id = B.function_id , sys.partition_schemes c WHERE  A.function_id = c.function_id 
GROUP BY A.NAME, C.NAME,  A.FUNCTION_ID

ALTER TABLE #TEMP ADD    DATA_START    sql_variant  ,  DATA_END sql_variant 


UPDATE A SET A.DATA_END = B.VALUE FROM #TEMP A,  sys.partition_range_values B WHERE A.function_id = B.function_id AND A.MAX_BOUNDRY_ID = B.boundary_id
GO

UPDATE A SET A.DATA_START = B.VALUE FROM #TEMP A,  sys.partition_range_values B WHERE A.function_id = B.function_id AND A.MIN_BOUNDRY_ID = B.boundary_id
GO

SELECT * FROM #TEMP


-- DROP TABLE #TEMP2



ALTER TABLE #TEMP ADD  DATA_START_FILEGROUP   VARCHAR(100)  ,   DATA_END_FILEGROUP   VARCHAR(100)
GO

UPDATE A SET A.DATA_START_FILEGROUP = B.FileGroupName FROM #TEMP A, #TEMP2  B WHERE A.function_id = B.PartitionFunctionValue AND A.DATA_START = B.value AND A.DBNAME  =  DB_NAME() AND A.PARTION_FUNCTION = B.PartitionFunction
GO

UPDATE A SET A.DATA_END_FILEGROUP = B.FileGroupName FROM #TEMP A, #TEMP2  B WHERE A.function_id = B.PartitionFunctionValue AND A.DATA_END = B.value AND A.DBNAME  =  DB_NAME() AND A.PARTION_FUNCTION = B.PartitionFunction
GO

SELECT * FROM #TEMP



----------------------- STEP 2 : REST OF DATABASES 


USE DEUTMOBVIEW_ARCHIVE 
GO


INSERT INTO #TEMP 
( SERVER, DBNAME, PARTION_FUNCTION, PARTITION_SCHEMA , FUNCTION_ID, MIN_BOUNDRY_ID  ,   MAX_BOUNDRY_ID )
SELECT  @@SERVERNAME AS SERVER , DB_NAME() AS DBNAME ,
A.NAME AS PARTION_FUNCTION,  C.NAME AS PARTITION_SCHEMA, A.FUNCTION_ID, MIN( B.BOUNDARY_ID ) AS MIN_BOUNDRY_ID  , MAX (B.BOUNDARY_ID )AS MAX_BOUNDRY_ID 
FROM  sys.partition_functions  A JOIN  sys.partition_range_values B ON A.function_id = B.function_id , sys.partition_schemes c WHERE  A.function_id = c.function_id 
GROUP BY A.NAME, C.NAME,  A.FUNCTION_ID


UPDATE A SET A.DATA_END = B.VALUE FROM #TEMP A,  sys.partition_range_values B WHERE DBNAME = DB_NAME()  AND A.function_id = B.function_id AND A.MAX_BOUNDRY_ID = B.boundary_id
  
GO

UPDATE A SET A.DATA_START = B.VALUE FROM #TEMP A,  sys.partition_range_values B WHERE DBNAME = DB_NAME()  AND A.function_id = B.function_id AND A.MIN_BOUNDRY_ID = B.boundary_id
GO

SELECT * FROM #TEMP order by 9 
--where DATA_END like '2015%' 


select max(Charging_Timestamp) from Activesnapshot order by 2 desc

SELECT * FROM #TEMP2



INSERT INTO #TEMP2 
( PartitionScheme ,PartitionFunction      ,FileGroupName    ,value      ,PartitionFunctionValue)
Select distinct ps.Name AS PartitionScheme, pf.name AS PartitionFunction,fg.name AS FileGroupName, rv.value ,ps.function_id   AS PartitionFunctionValue
    from sys.indexes i  
    join sys.partitions p ON i.object_id=p.object_id AND i.index_id=p.index_id  
    join sys.partition_schemes ps on ps.data_space_id = i.data_space_id  
    join sys.partition_functions pf on pf.function_id = ps.function_id  
    left join sys.partition_range_values rv on rv.function_id = pf.function_id AND rv.boundary_id = p.partition_number
    join sys.allocation_units au  ON au.container_id = p.hobt_id   
    join sys.filegroups fg  ON fg.data_space_id = au.data_space_id  


SELECT * FROM #TEMP2

UPDATE A SET A.DATA_START_FILEGROUP = B.FileGroupName FROM #TEMP A, #TEMP2  B WHERE A.function_id = B.PartitionFunctionValue AND A.DATA_START = B.value AND A.DBNAME  =  DB_NAME() AND A.PARTION_FUNCTION = B.PartitionFunction
GO

UPDATE A SET A.DATA_END_FILEGROUP = B.FileGroupName FROM #TEMP A, #TEMP2  B WHERE A.function_id = B.PartitionFunctionValue AND A.DATA_END = B.value AND A.DBNAME  =  DB_NAME() AND A.PARTION_FUNCTION = B.PartitionFunction
GO

SELECT * FROM #TEMP

SELECT * FROM #TEMP2 WHERE PartitionFunctionValue = '65538' 
