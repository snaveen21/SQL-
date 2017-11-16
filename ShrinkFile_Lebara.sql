select db_name(), name, 
size*8.0*1024/(1024*1024) as TotalMB,
fileproperty(name,'SpaceUsed')*8.0*1024/(1024*1024) as UsedMB,
size*8.0*1024/(1024*1024) - fileproperty(name,'SpaceUsed')*8.0*1024/(1024*1024) as FreeMB,
substring(upper(filename),1,1) as drive,
filename,filegroup_name(groupid)as Filegroup, 
case maxsize when -1 then 'Unrestrictred' when '0' then 'Restricted' else convert(varchar,(maxsize)*8.0*1024/(1024*1024)) end as maxsize_in_MB,
case growth when 0 then 'No Growth' else convert(varchar, (growth)*8.0*1024/(1024*1024)) end as growth_in_MB
from sysfiles where (status & 0x2) <> 0 and substring(upper(filename),1,1)='V'
--and filename like 'H:\ODS2\GBR_ARC\DATA\%'
--and name like '%index%'
order by 5 desc


-- Shrink only the MB value must not go below Used MBs
dbcc shrinkfile(CDR2014_09,61000)
--4647.062500000000

-- limit the file group
--USE [master]
--GO
--ALTER DATABASE [ESPView] MODIFY FILE ( NAME = N'Med_tables_Stg', MAXSIZE = 89088000KB )

--GO
Select DB_NAME(),O.name,I.rows From Sys.sysobjects O (nolock)
Join sys.sysindexes i (nolock) on o.id=i.id
where i.indid in (0,1) and o.xtype='u'
order by 3 desc

sp_spaceused CustomData --44GB
sp_spaceused MessageStates --123GB
sp_spaceused MessageEvents --11GB
sp_spaceused Messages --9GB
sp_spaceused ResubmitData --1GB

select top 10 * from CustomData
--truncate table CRMUpsellOffers_old
--Releases all free space at the end of the file to the operating system but does not perform any page movement inside the file. 
--The data file is shrunk only to the last allocated extent.
--DBCC SHRINKFILE (N'PRIMARY' , 0, TRUNCATEONLY)
--GO

--DBCC SHRINKFILE (N'Med_tables_Stg' , 99000)

-- Check the Disk
SELECT DISTINCT dovs.logical_volume_name AS LogicalName,
dovs.volume_mount_point AS Drive,
CONVERT(INT,dovs.available_bytes/1048576.0) AS FreeSpaceInMB,
CONVERT(INT,dovs.total_bytes/1048576.0) AS TotalSpaceInMB,
Convert(nvarchar,((dovs.available_bytes/1048576.0/1024.0)/(dovs.total_bytes/1024.0/1024.0/1024.0)) * 100)+'%' AS PercentageFree
FROM sys.master_files mf
CROSS APPLY sys.dm_os_volume_stats(mf.database_id, mf.FILE_ID) dovs
where Convert(INT,((dovs.available_bytes/1048576.0/1024.0)/(dovs.total_bytes/1024.0/1024.0/1024.0)) * 100) < '60'
ORDER BY PercentageFree Asc
GO


-----------------------------------------------------------------------------------


Select O.name,I.rows From Sys.sysobjects O (nolock)
Join sys.sysindexes i (nolock) on o.id=i.id
where i.indid in (0,1) and o.xtype='u'
order by 2 desc

sp_spaceused msisdn_life_cycle
-- Tables to Data File
SELECT
    OBJECT_NAME([si].[object_id]) AS [tablename]
    ,[ds].[name] AS [filegroupname]
    ,[df].[physical_name] AS [datafilename]
FROM [sys].[data_spaces] [ds]

    INNER JOIN [sys].[database_files] [df]
        ON [ds].[data_space_id] = [df].[data_space_id]

    INNER JOIN [sys].[indexes] [si]
        ON [si].[data_space_id] = [ds].[data_space_id]
            AND [si].[index_id] < 2

    INNER JOIN [sys].[objects] [so]
        ON [si].[object_id] = [so].[object_id]
WHERE
    [so].[type] = 'U'
    AND [so].[is_ms_shipped] = 0
    and OBJECT_NAME([si].[object_id]) like 'AMS_AUDITREPORT'
ORDER BY [tablename] ASC;

--------------------------------------------------------------------------------------
--Deprecated systable
Select  [Filename],
        Size,
        MaxSize,
        Growth
From    sys.sysfiles order by Size desc

--  Replacement system view
Select  physical_name,
        Size,
        max_size,
        growth
From    sys.database_files
GO
--30861.69


CHECKPOINT;
SELECT [Current LSN], [Operation] FROM fn_dblog (NULL, NULL);
GO
SELECT [Current LSN], [Operation], [Num Transactions], [Log Record]
FROM fn_dblog (NULL, NULL) WHERE [Operation] = 'LOP_XACT_CKPT';


sp_spaceused MED_REC_CDR_ERROR_NLD
sp_spaceused MED_MON_REC_CDR_ERROR_DNK
 sp_spaceused MED_MON_REC_CDR_ERROR_ESP






 
-- CREATE staging TABLE here


select top 10 * from [ESP_Main_Summary_2014_staging]
--drop table [ESP_CDR2014_staging]
 -------------------ESP_CDR2014_SCH [CDR2014_stg]

 select * from sys.partition_functions  --  65543
go

select * from sys.partitions



select top 1000 * from sys.partition_range_values where function_id= 65546   -- >> BOUNDRY_ID  = 2
GO





sp_spaceused [ESP_Main_Summary_2014]
go

sp_spaceused [ESP_Main_Summary_2014_stag]
GO

96287082 

---------------------------- switch [CDR2014_SCH]
ALTER TABLE MSISDN_LIFE_CYCLE SWITCH PARTITION 2 TO [MSISDN_LIFE_CYCLE_stg]
go 
sp_spaceused [MSISDN_LIFE_CYCLE_stg] 

select top 10 * from [MSISDN_LIFE_CYCLE_stg] order by charging_timestamp


sp_spaceused NLD_CDR2014_Staging
--truncate table [MSISDN_LIFE_CYCLE_stg]
--drop table [MSISDN_LIFE_CYCLE_stg]

dbcc shrinkfile(Med_tables_Stg,86000)
select * from GBR_Main_Summary_2013
