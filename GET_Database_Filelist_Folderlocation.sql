
--------------------------- Find all the Filegroup and freespace avaialbilty

DECLARE @database_id int 
DECLARE @database_name sysname 
DECLARE @sql_string nvarchar(2000) 
DECLARE @file_size TABLE 
    ( 
    [database_name] [sysname] NULL, 
    [groupid] [smallint] NULL, 
    [groupname] sysname NULL, 
    [fileid] [smallint] NULL, 
    [file_size] [decimal](12, 2) NULL, 
    [space_used] [decimal](12, 2) NULL, 
    [free_space] [decimal](12, 2) NULL, 
    [name] [sysname] NOT NULL, 
    [filename] [nvarchar](260) NOT NULL 
    )


	--select *  FROM sys.databases 


SELECT TOP 1 @database_id = database_id 
    ,@database_name = name
--select  database_id, name
FROM sys.databases 
WHERE database_id > 0  and  name <> 'test_logshipping'
ORDER BY database_id

WHILE @database_name IS NOT NULL 
BEGIN

    SET @sql_string = 'USE ' + QUOTENAME(@database_name) + CHAR(10) 
    SET @sql_string = @sql_string + 'SELECT 
                                        DB_NAME() 
                                        ,sysfilegroups.groupid 
                                        ,sysfilegroups.groupname 
                                        ,fileid 
                                        ,convert(decimal(12,2),round(sysfiles.size/128.000,2)) as file_size 
                                        ,convert(decimal(12,2),round(fileproperty(sysfiles.name,''SpaceUsed'')/128.000,2)) as space_used 
                                        ,convert(decimal(12,2),round((sysfiles.size-fileproperty(sysfiles.name,''SpaceUsed''))/128.000,2)) as free_space 
                                        ,sysfiles.name 
                                        ,sysfiles.filename 
                                    FROM sys.sysfiles 
                                    LEFT OUTER JOIN sys.sysfilegroups 
                                        ON sysfiles.groupid = sysfilegroups.groupid'

    INSERT INTO @file_size 
        EXEC sp_executesql @sql_string   

    --Grab next database 
    SET @database_name = NULL 
    SELECT TOP 1 @database_id = database_id 
        ,@database_name = name 
    FROM sys.databases 
    WHERE database_id > @database_id and  name <> 'test_logshipping'
    ORDER BY database_id 
END

--File Sizes 
SELECT database_name, ISNULL(groupname,'TLOG') Filegroup , name Filename, file_size, space_used, free_space, filename ,  fileid, groupid
FROM @file_size

--File Group Sizes 
SELECT database_name, ISNULL(groupname,'TLOG') groupname, SUM(file_size) as file_size, SUM(space_used) as space_used, SUM(free_space) as free_space 
, groupid
FROM @file_size 
GROUP BY database_name, groupid, groupname


/*



Create Table #temp
(
    DatabaseName sysname,
    Name sysname,
    physical_name nvarchar(500),
    size decimal (18,2),
    FreeSpace decimal (18,2)
)   
Exec sp_msforeachdb '
Use [?];
Insert Into #temp (DatabaseName, Name, physical_name, Size, FreeSpace)
    Select DB_NAME() AS [DatabaseName], Name,  physical_name,
    Cast(Cast(Round(cast(size as decimal) * 8.0/1024.0,2) as decimal(18,2)) as nvarchar) Size,
    Cast(Cast(Round(cast(size as decimal) * 8.0/1024.0,2) as decimal(18,2)) -
        Cast(FILEPROPERTY(name, ''SpaceUsed'') * 8.0/1024.0 as decimal(18,2)) as nvarchar) As FreeSpace
    From sys.database_files
	order by ( Cast(Cast(Round(cast(size as decimal) * 8.0/1024.0,2) as decimal(18,2)) -
        Cast(FILEPROPERTY(name, ''SpaceUsed'') * 8.0/1024.0 as decimal(18,2)) as nvarchar)) desc
'
Select * From #temp
drop table #temp

*/