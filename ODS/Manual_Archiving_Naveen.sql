
-- Give the table name and find the Boundries/Partetion number and filegroups
--STEP 1: Find which partetion need to go.
--truncate table dbo.CDR_GPRS_0
DECLARE @TableName NVARCHAR(200) = N'dbo.CDR_GPRS_0'
 
SELECT SCHEMA_NAME(o.schema_id) + '.' + OBJECT_NAME(i.object_id) AS [object]
     , p.partition_number AS [p#]
     , fg.name AS [filegroup]
     , p.rows
     , au.total_pages AS pages
     , CASE boundary_value_on_right
       WHEN 1 THEN 'less than'
       ELSE 'less than or equal to' END as comparison
     , rv.value
     , CONVERT (VARCHAR(6), CONVERT (INT, SUBSTRING (au.first_page, 6, 1) +
       SUBSTRING (au.first_page, 5, 1))) + ':' + CONVERT (VARCHAR(20),
       CONVERT (INT, SUBSTRING (au.first_page, 4, 1) +
       SUBSTRING (au.first_page, 3, 1) + SUBSTRING (au.first_page, 2, 1) +
       SUBSTRING (au.first_page, 1, 1))) AS first_page
FROM sys.partitions p
INNER JOIN sys.indexes i
     ON p.object_id = i.object_id
AND p.index_id = i.index_id
INNER JOIN sys.objects o
     ON p.object_id = o.object_id
INNER JOIN sys.system_internals_allocation_units au
     ON p.partition_id = au.container_id
INNER JOIN sys.partition_schemes ps
     ON ps.data_space_id = i.data_space_id
INNER JOIN sys.partition_functions f
     ON f.function_id = ps.function_id
INNER JOIN sys.destination_data_spaces dds
     ON dds.partition_scheme_id = ps.data_space_id
     AND dds.destination_id = p.partition_number
INNER JOIN sys.filegroups fg
     ON dds.data_space_id = fg.data_space_id
LEFT OUTER JOIN sys.partition_range_values rv
     ON f.function_id = rv.function_id
     AND p.partition_number = rv.boundary_id
WHERE i.index_id < 2
     AND o.object_id = OBJECT_ID(@TableName)
     order by 2;



-- STEP 2: Create a staging table in the same file group




---------------------------- CHECK DATA SPPLIT

 SELECT CONVERT(VARCHAR(7), CHARGING_TIMESTAMP, 121) MM ,  COUNT(*) CNT  FROM  [dbo].CDR2014 (NOLOCK)
GROUP BY CONVERT(VARCHAR(7), CHARGING_TIMESTAMP, 121)
GO

 
-- CREATE staging TABLE here


select top 10 * from MSISDN_LIFE_CYCLE
--drop table [ESP_CDR2014_staging]
 -------------------ESP_CDR2014_SCH

select * from sys.partition_functions  --  65543
go
select * from sys.partitions
select top 1000 * from sys.partition_range_values where function_id= 65550   -- >> BOUNDRY_ID  = 2
GO


sp_spaceused [NLD_Main_Summary_2012_201405]
GO






--STEP 3: switch partetion to the staging table.
ALTER TABLE CDR2014 SWITCH PARTITION 10 TO CDR2014_stg 
go

drop table [CDR2014_stg]
dbcc shrinkfile(CDR2014_09,1)

-- STEP 4: BCP Out the data
BCP "select * from NLDView.dbo.NLD_Main_Summary_2012_201408 (nolock)" queryout \\192.168.0.58\backup\Archive_Files\2014\8\LEB-ODSMSSQL1\NLD\Main_Summary\NLDView_NLD_Main_Summary_2012_201408_20150827.txt -o \\192.168.0.58\backup\Archive_Files\2014\8\LEB-ODSMSSQL1\NLD\Main_Summary\NLDView_NLD_Main_Summary_2012_201408_20150827_log.txt -c -T -S LEB-ODSMSSQL1\ODSMSSQL1


2764000
9991745    


select top 10 * from [CDR2014] order by charging_timestamp

-- STEP 5: Truncate Drop and Shrink file group.
sp_spaceused NLD_Main_Summary_2012_201407
--truncate table cdr_0_201501
--drop table [CDR2014_stg]

dbcc shrinkfile(NLDVIEW_MAIN_SUMMARY_NEW_201408,1)