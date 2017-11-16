SELECT o.name objectname,i.name indexname, partition_id, partition_number, [rows] 
FROM sys.partitions p 
INNER JOIN sys.objects o ON o.object_id=p.object_id 
INNER JOIN sys.indexes i ON i.object_id=p.object_id and p.index_id=i.index_id 
WHERE o.name like 'CDR_GSM_0'
and [rows] >0
--and partition_number = 21


SELECT o.name objectname,i.name indexname, partition_id, partition_number, [rows] 
FROM sys.partitions p 
INNER JOIN sys.objects o ON o.object_id=p.object_id 
INNER JOIN sys.indexes i ON i.object_id=p.object_id and p.index_id=i.index_id 
WHERE o.name like 'CDR_GPRS_0'
and [rows] >0
--and partition_number = 21

sp_spaceused CDR_GPRS_0
--90031486 


select top 1000 * from sys.partition_range_values where function_id= 65540   -- >> BOUNDRY_ID  = 2
GO


 select * from sys.partition_functions  --  65543
go

select * from sys.partitions  where PARTITION_ID='72057594073055232'

select * from sys.partitions  where PARTITION_number='29'



select top 1000 * from sys.partition_range_values where function_id= 65540   -- >> BOUNDRY_ID  = 2
GO

