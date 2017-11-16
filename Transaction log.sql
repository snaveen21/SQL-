---- Backing up transaction log 

DBCC SQLPERF(LOGSPACE)

--Firstly, what is log_reuse_wait_desc? It’s a field in sys.databases that you can use to determine why the transaction log isn’t clearing (a.k.a truncating) correctly
--http://www.sqlskills.com/blogs/paul/why-is-log_reuse_wait_desc-saying-log_backup-after-doing-a-log-backup/
--https://technet.microsoft.com/en-us/magazine/2009.02.logging.aspx
Select name as DBNAME, log_reuse_wait_desc from sys.databases


-----------
USE master
exec SP_AdDumpdevice 'Disk','TLogBackup','C:\DBName_Log.bak'
BACKUP LOG DATABASEName TO TLogBackup
-----------


DBCC SQLPERF(LOGSPACE)

--Firstly, what is log_reuse_wait_desc? It’s a field in sys.databases that you can use to determine why the transaction log isn’t clearing (a.k.a truncating) correctly
--http://www.sqlskills.com/blogs/paul/why-is-log_reuse_wait_desc-saying-log_backup-after-doing-a-log-backup/
--https://technet.microsoft.com/en-us/magazine/2009.02.logging.aspx
Select name as DBNAME, log_reuse_wait_desc from sys.databases
