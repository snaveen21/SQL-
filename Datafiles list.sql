SELECT DB_NAME([database_id])AS [Database Name], 
        [file_id], name, physical_name, type_desc, state_desc, 
        CONVERT( bigint, size/128.0) AS [Total Size in MB]
FROM sys.master_files WITH (NOLOCK)
where SUBSTRING(physical_name,1,3)='i:\' 
--and 
--physical_name like 'F:\pol%'
ORDER BY DB_NAME([database_id]) OPTION (RECOMPILE);



SELECT DB_NAME([database_id])AS [Database Name], 
        [file_id], name, physical_name, type_desc, state_desc, 
        CONVERT( bigint, size/128.0) AS [Total Size in MB]
FROM sys.master_files WITH (NOLOCK)
where SUBSTRING(physical_name,1,3)='i:\' 
--and 
--physical_name like 'F:\pol%'
ORDER BY 7  desc OPTION (RECOMPILE);