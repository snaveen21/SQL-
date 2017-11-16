

-- Get Last Restart time

SELECT
name,crdate 
FROM
sysdatabases 
WHERE name in (
'FRAView_CDR_2011_Q3_Q4',
'FRAView_CDR_2011_Q3_Q4',
'FRAView_CDR_2012_Q1',
'FRAView_CDR_2012_Q1',
'DNKViewV2',
'GBRView_Repl',
'GBRView_Repl',
'ATMTopup',
'ATMTopup',
'SalesReport',
'SalesReport',
'SalesReportvT_old',
'SalesReportvT_old',
'AUS_Main_Summary_2011',
'AUS_Main_Summary_2011',
'FRATTD_Snapshot_2012',
'GBRView',
'DNKVIEWV2_New'
)

go


-- Datafiles location for all DB
SELECT DB_NAME([database_id])AS [Database Name], 
        [file_id], name, physical_name, type_desc, state_desc, 
        CONVERT( bigint, size/128.0) AS [Total Size in MB]
FROM sys.master_files WITH (NOLOCK)
where SUBSTRING(physical_name,1,3)='F:\' 
--and 
--physical_name like 'F:\pol%'
ORDER BY 7  desc OPTION (RECOMPILE);



-- get last db access time (Null = no access since last reboot)

SELECT name, last_access =(select X1= max(LA.xx)
from ( select xx =
max(last_user_seek)
where max(last_user_seek)is not null
union all
select xx = max(last_user_scan)
where max(last_user_scan)is not null
union all
select xx = max(last_user_lookup)
where max(last_user_lookup) is not null
union all
select xx =max(last_user_update)
where max(last_user_update) is not null) LA)
FROM master.dbo.sysdatabases sd 
left outer join sys.dm_db_index_usage_stats s 
on sd.dbid= s.database_id 
group by sd.name