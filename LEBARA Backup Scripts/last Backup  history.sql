-------------- backup timings 1
select * from t_databases 
--update t_databases set 
--Location='\\Leb-nas018\dba\Databases\LBR-AWSDB004'


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
--and type = 'D'
order by a.backup_start_date desc 


/*
D = Database
I = Differential database
L = Log
F = File or filegroup
G =Differential file
P = Partial
Q = Differential partial
*/



select database_name, backup_start_date,backup_finish_date , 
case  type when  'I' then 'Differential' when  'D' then 'FULL'  else 'Other' end Type, 
left(physical_device_name,len(physical_device_name) -(CHARINDEX('\', REVERSE(physical_device_name)))+1) Location, 
Datename(weekday, backup_finish_date ) Day, 
datediff ( HH, backup_start_date , 
backup_finish_date)Hours , 
backup_size/1028/1028 Size 
from msdb..backupset a, msdb..backupmediafamily b 
where a.media_set_id = b.media_set_id 
-- and database_name = 'Bi_backup_clean'  -- >>  choose required database if required 
--and type = 'I'  -- >>  choose backup types as required ( D = Database/ I = Differential database/ L = Log/ F = File or filegroup/ G =Differential file/ P = Partial/ Q = Differential partial )
order by a.backup_start_date desc




SELECT physical_device_name, LEN(REPLACE(physical_device_name, '\', '')) FROM msdb..backupmediafamily

SELECT physical_device_name, LEN(physical_device_name) - LEN(REPLACE(physical_device_name, '\', '')) FROM msdb..backupmediafamily

SELECT physical_device_name, left(physical_device_name,len(physical_device_name) -(CHARINDEX('\', REVERSE(physical_device_name)))+1) FROM msdb..backupmediafamily

SELECT physical_device_name, (LEN(physical_device_name) - LEN(REPLACE(physical_device_name, '\',' ')))/LEN('physical_device_name')
from msdb..backupmediafamily

SELECT (CHARINDEX('/', physical_device_name, (length(physical_device_name)) from msdb..backupmediafamily
GO


create function
as

select len(physical_device_name) from  msdb..backupmediafamily


-- sp_who2 active
 --select * from sys.dm_exec_requests where session_id = 236 
 
 select  * from msdb..backupmediafamily 

   

-------------- backup timings

select  database_name, 
        [uncompressed_size] = backup_size/1024/1024,
        [compressed_size] = compressed_backup_size/1024/1024, 
        backup_start_date, 
        backup_finish_date, 
        datediff(s,backup_start_date,backup_finish_date) as [TimeTaken(s)]
from    msdb..backupset b 
where   type = 'L' -- for log backups
order by b.backup_start_date desc


SELECT DATENAME(year, '12:10:30.123')
    ,DATENAME(month, '12:10:30.123')
    ,DATENAME(day, '12:10:30.123')
    ,DATENAME(dayofyear, '12:10:30.123')
SELECT DATENAME(weekday, GETDATE());



--select * from msdb..backupset 

--------------------------------Restore Database

--select * from msdb..restorehistory


declare @filepath nvarchar(1000) 

SELECT @filepath = cast(value as nvarchar(1000)) FROM [fn_trace_getinfo](NULL) 
WHERE [property] = 2 and traceid=1 

SELECT * 
FROM [fn_trace_gettable](@filepath, DEFAULT) F5 
INNER JOIN  
( 
    SELECT F4.EventSequence MainSequence,  
         MAX(F3.EventSequence) MaxEventSequence, F3.TransactionID 
    FROM [fn_trace_gettable](@filepath, DEFAULT) F3 
    INNER JOIN  
    ( 
        SELECT F2.EventSequence, MIN(TransactionID) as TransactionID 
        FROM [fn_trace_gettable](@filepath, DEFAULT) F1 
        INNER JOIN  
        ( 
            SELECT DatabaseID, SPID, StartTime, ClientProcessID, EventSequence 
            FROM [fn_trace_gettable](@filepath, DEFAULT) 
            WHERE upper(convert(nvarchar(max), TextData)) 
                LIKE 'RESTORE DATABASE%'  
        ) F2 ON (F1.DatabaseID = F2.DatabaseID OR F2.DatabaseID IS NULL) 
                   AND F1.SPID = F2.SPID  
                   AND F1.ClientProcessID = F2.ClientProcessID  
                   AND F1.StartTime > F2.StartTime 
        GROUP BY F2.EventSequence 
    ) F4 ON F3.TransactionID = F4.TransactionID  
    GROUP BY F3.TransactionID, F4.EventSequence 
) F6 ON F5.EventSequence = F6.MainSequence  
    OR F5.EventSequence = F6.MaxEventSequence 
ORDER BY F5.StartTime 


-----------DMV to check the database restore stats
select 
d.name
,percent_complete
,dateadd(second,estimated_completion_time/1000, getdate())
, Getdate() as now
,datediff(minute, start_time
, getdate()) as running
, estimated_completion_time/1000/60 as togo
,start_time
, command 
from sys.dm_exec_requests req
inner join sys.sysdatabases d on d.dbid = req.database_id
where 
req.command LIKE '%RESTORE%'



