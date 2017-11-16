
--Check there should be no msdb user


select ecp.spid, db.name as dbname,hostname,[program_name], ecp.cmd, ecp.blocked as blockedby, loginame,[text], waitresource,ecp.status, datediff(second, login_time,last_batch)Duration_sec

            from sys.sysprocesses ecp

            left join sys.sysdatabases db on ecp.dbid = db.dbid

            CROSS APPLY sys.dm_exec_sql_text(ecp.sql_handle) AS q

            --where db.name like 'ms%'
            --where ecp.blocked in( '70','87') or SPID in (70,87)

            order by ecp.blocked desc, 1
            
use master 

ALTER DATABASE [msdb]
SET SINGLE_USER
WITH ROLLBACK IMMEDIATE;

ALTER DATABASE [msdb] SET ENABLE_BROKER;

ALTER DATABASE [msdb]
SET MULTI_USER;
GO





is_broker_enabled

select * from  sys.databases


USE master
GO
sp_configure 'show advanced options',1
GO
RECONFIGURE WITH OVERRIDE
GO
sp_configure 'Database Mail XPs',1
GO
RECONFIGURE 
GO


SELECT is_broker_enabled FROM sys.databases WHERE name = 'msdb'

EXECUTE dbo.sysmail_help_status_sp
EXECUTE dbo.sysmail_start_sp

SELECT is_broker_enabled FROM sys.databases WHERE name = 'msdb'



