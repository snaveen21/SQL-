USE [msdb]
GO

IF  EXISTS (SELECT name FROM msdb.dbo.sysoperators WHERE name = N'DBA')
EXEC msdb.dbo.sp_delete_operator @name=N'DBA'
GO

USE [msdb]
GO

EXEC msdb.dbo.sp_add_operator @name=N'DBA', 
		@enabled=1, 
		@weekday_pager_start_time=80000, 
		@weekday_pager_end_time=180000, 
		@saturday_pager_start_time=80000, 
		@saturday_pager_end_time=180000, 
		@sunday_pager_start_time=80000, 
		@sunday_pager_end_time=180000, 
		@pager_days=127, 
		@email_address=N'DBA@lebara.com', 
		@category_name=N'[Uncategorized]', 
		@netsend_address=N'DBA@Lebara.com'
GO


USE [msdb]
GO


IF  EXISTS (SELECT job_id FROM msdb.dbo.sysjobs_view WHERE name = N'DBA_Daily_DbBackup_Log')
EXEC msdb.dbo.sp_delete_job @job_name=N'DBA_Daily_DbBackup_Log', @delete_unused_schedule=1
GO

USE [msdb]
GO


DECLARE @jobId BINARY(16)
EXEC  msdb.dbo.sp_add_job @job_name=N'DBA_Daily_DbBackup_Log', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_netsend=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@description=N'Created by DBA team on 20140821 ', 
		@category_name=N'Database Maintenance', 
		@owner_login_name=N'GBR\SQLDBA_SERVICE', @job_id = @jobId OUTPUT
select @jobId
GO
EXEC msdb.dbo.sp_add_jobserver @job_name=N'DBA_Daily_DbBackup_Log', @server_name = N'LEB-ODSMSSQL2\ODSMSSQL2'
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_add_jobstep @job_name=N'DBA_Daily_DbBackup_Log', @step_name=N'DBA_Daily_DbBackup_Log', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_fail_action=2, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'Declare @tableHTML   NVARCHAR(MAX) ;
 



-- Query output in HTML format
SET @tableHTML =
    N''<H1> Daily SQL - LEB-ODSMSSQL2\ODSMSSQL2  </H1>'' +
    N''<table border="1">'' +
    N''<tr><th>Machine Name</th><th>Database name</th>'' +
    N''<th>backup start date</th><th>Backup finish date</th>'' +
    N''<th>Days since last</th><th>Backup Size MB</th>'' +
    N''<th>Backup Type</th></tr>'' +
    CAST ( ( SELECT td = machine_name, '''',
			td = Database_Name, '''',
			td = CONVERT (SmallDateTime, MAX(Backup_start_Date)) , '''',
			td = CONVERT (SmallDateTime, MAX(Backup_Finish_Date)) , '''',
			td = DATEDIFF(d, MAx(Backup_Finish_Date), GETDATE ()) , '''',
			td = CONVERT (decimal(30), MAX (backup_size  / 1024 /1024)), '''',
			td = case when type = ''D'' then ''FULL'' when type = ''i'' then ''Diff'' when type = ''L'' then ''LOG'' else ''OTHER'' end,''''
              FROM msdb.dbo.backupset
              WHERE machine_name= @@servername and (backup_start_date >= GETDATE() - 1)
              group by machine_name,database_name, type
              ORDER BY 3 desc
              FOR XML PATH(''tr''), TYPE 
    ) AS NVARCHAR(MAX) ) +
    N''</table>'' ;

    
 -- Sending mail   
   EXEC msdb.dbo.sp_send_dbmail
    @profile_name = ''DBA'',
    @recipients=''dba@lebara.com'',
    @subject = ''Daily SQL - LEB-ODSMSSQL2\ODSMSSQL2 '',
    @body = @tableHTML,
    @body_format = ''HTML'';', 
		@database_name=N'DBMONITOR', 
		@flags=0
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_update_job @job_name=N'DBA_Daily_DbBackup_Log', 
		@enabled=1, 
		@start_step_id=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_netsend=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@description=N'Created by DBA team on 20140821 
', 
		@category_name=N'Database Maintenance', 
		@owner_login_name=N'DBA', 
		@notify_email_operator_name=N'', 
		@notify_netsend_operator_name=N'', 
		@notify_page_operator_name=N''
GO
USE [msdb]
GO
DECLARE @schedule_id int
EXEC msdb.dbo.sp_add_jobschedule @job_name=N'DBA_Daily_DbBackup_Log', @name=N'DBA_Daily_DbBackup_Log', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20120509, 
		@active_end_date=99991231, 
		@active_start_time=84500, 
		@active_end_time=235959, @schedule_id = @schedule_id OUTPUT
select @schedule_id
GO


waitfor delay '00:00:02' 


USE [msdb]
GO


IF  EXISTS (SELECT job_id FROM msdb.dbo.sysjobs_view WHERE name = N'DBA_DB_Backup_COMP_FULL_Weekly')
EXEC msdb.dbo.sp_delete_job @job_name=N'DBA_DB_Backup_COMP_FULL_Weekly', @delete_unused_schedule=1
GO

USE [msdb]
GO
DECLARE @jobId BINARY(16)
EXEC  msdb.dbo.sp_add_job @job_name=N'DBA_DB_Backup_COMP_FULL_Weekly', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_netsend=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@description=N'DBA_DB_Backup_COMP_FULL_Weekly  --- Friday', 
		@category_name=N'Database Maintenance', 
		@owner_login_name=N'GBR\SQLDBA_SERVICE', @job_id = @jobId OUTPUT
select @jobId
GO
EXEC msdb.dbo.sp_add_jobserver @job_name=N'DBA_DB_Backup_COMP_FULL_Weekly', @server_name = N'LEB-ODSMSSQL2\ODSMSSQL2'
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_add_jobstep @job_name=N'DBA_DB_Backup_COMP_FULL_Weekly', @step_name=N'DBA_DB_Backup_COMP_FULL', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_fail_action=2, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'DBA_DB_Backup_COMP_FULL', 
		@database_name=N'DBMONITOR', 
		@flags=0
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_update_job @job_name=N'DBA_DB_Backup_COMP_FULL_Weekly', 
		@enabled=1, 
		@start_step_id=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_netsend=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@description=N'DBA_DB_Backup_COMP_FULL_Weekly  --- Friday', 
		@category_name=N'Database Maintenance', 
		@owner_login_name=N'GBR\SQLDBA_SERVICE', 
		@notify_email_operator_name=N'', 
		@notify_netsend_operator_name=N'', 
		@notify_page_operator_name=N''
GO
USE [msdb]
GO
DECLARE @schedule_id int
EXEC msdb.dbo.sp_add_jobschedule @job_name=N'DBA_DB_Backup_COMP_FULL_Weekly', @name=N'DBA_DB_Backup_COMP_FULL', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=64, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20120514, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959, @schedule_id = @schedule_id OUTPUT
select @schedule_id
GO


waitfor delay '00:00:02' 


USE [msdb]
GO


IF  EXISTS (SELECT job_id FROM msdb.dbo.sysjobs_view WHERE name = N'DBA_DB_Backup_COMP_DIFF_Daily')
EXEC msdb.dbo.sp_delete_job @job_name=N'DBA_DB_Backup_COMP_DIFF_Daily', @delete_unused_schedule=1
GO

USE [msdb]
GO
DECLARE @jobId BINARY(16)
EXEC  msdb.dbo.sp_add_job @job_name=N'DBA_DB_Backup_COMP_DIFF_Daily', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_netsend=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@description=N'DBA_DB_Backup_COMP_DIFF_Daily - except saturday', 
		@category_name=N'Database Maintenance', 
		@owner_login_name=N'GBR\SQLDBA_SERVICE', @job_id = @jobId OUTPUT
select @jobId
GO
EXEC msdb.dbo.sp_add_jobserver @job_name=N'DBA_DB_Backup_COMP_DIFF_Daily', @server_name = N'LEB-ODSMSSQL2\ODSMSSQL2'
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_add_jobstep @job_name=N'DBA_DB_Backup_COMP_DIFF_Daily', @step_name=N'DBA_DB_Backup_COMP_DIFF', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_fail_action=2, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'exec DBA_DB_Backup_COMP_DIFF', 
		@database_name=N'DBMONITOR', 
		@flags=0
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_update_job @job_name=N'DBA_DB_Backup_COMP_DIFF_Daily', 
		@enabled=1, 
		@start_step_id=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_netsend=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@description=N'DBA_DB_Backup_COMP_DIFF_Daily - except saturday', 
		@category_name=N'Database Maintenance', 
		@owner_login_name=N'GBR\SQLDBA_SERVICE', 
		@notify_email_operator_name=N'', 
		@notify_netsend_operator_name=N'', 
		@notify_page_operator_name=N''
GO
USE [msdb]
GO
DECLARE @schedule_id int
EXEC msdb.dbo.sp_add_jobschedule @job_name=N'DBA_DB_Backup_COMP_DIFF_Daily', @name=N'DBA_DB_Backup_COMP_DIFF', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=63, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20120514, 
		@active_end_date=99991231, 
		@active_start_time=10000, 
		@active_end_time=235959, @schedule_id = @schedule_id OUTPUT
select @schedule_id
GO




waitfor delay '00:00:02' 


USE [msdb]
GO


IF  EXISTS (SELECT job_id FROM msdb.dbo.sysjobs_view WHERE name = N'DBA_DB_Backup_SQL_FULL_Weekly')
EXEC msdb.dbo.sp_delete_job @job_name=N'DBA_DB_Backup_SQL_FULL_Weekly', @delete_unused_schedule=1
GO



USE [msdb]
GO
DECLARE @jobId BINARY(16)
EXEC  msdb.dbo.sp_add_job @job_name=N'DBA_DB_Backup_SQL_FULL_Weekly', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_netsend=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@description=N'DBA_DB_Backup_SQL_FULL_Weekly  --  Friday', 
		@category_name=N'Database Maintenance', 
		@owner_login_name=N'GBR\SQLDBA_SERVICE', 
		@notify_email_operator_name=N'DBA', @job_id = @jobId OUTPUT
select @jobId
GO
EXEC msdb.dbo.sp_add_jobserver @job_name=N'DBA_DB_Backup_SQL_FULL_Weekly', @server_name = N'LEB-ODSMSSQL2\ODSMSSQL2'
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_add_jobstep @job_name=N'DBA_DB_Backup_SQL_FULL_Weekly', @step_name=N'DBA_DB_Backup_SQL_FULL_Weekly', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_fail_action=2, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'exec DBA_DB_Backup_SQL_FULL', 
		@database_name=N'DBMONITOR', 
		@flags=0
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_update_job @job_name=N'DBA_DB_Backup_SQL_FULL_Weekly', 
		@enabled=1, 
		@start_step_id=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_netsend=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@description=N'DBA_DB_Backup_SQL_FULL_Weekly  --  Friday', 
		@category_name=N'Database Maintenance', 
		@owner_login_name=N'GBR\SQLDBA_SERVICE', 
		@notify_email_operator_name=N'DBA', 
		@notify_netsend_operator_name=N'', 
		@notify_page_operator_name=N''
GO
USE [msdb]
GO
DECLARE @schedule_id int
EXEC msdb.dbo.sp_add_jobschedule @job_name=N'DBA_DB_Backup_SQL_FULL_Weekly', @name=N'DBA_DB_Backup_SQL_FULL_Weekly', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=32, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20120514, 
		@active_end_date=99991231, 
		@active_start_time=200500, 
		@active_end_time=235959, @schedule_id = @schedule_id OUTPUT
select @schedule_id
GO


waitfor delay '00:00:02' 



USE [msdb]
GO


IF  EXISTS (SELECT job_id FROM msdb.dbo.sysjobs_view WHERE name = N'DBA_DB_Backup_SQL_DIFF_Daily')
EXEC msdb.dbo.sp_delete_job @job_name=N'DBA_DB_Backup_SQL_DIFF_Daily', @delete_unused_schedule=1
GO


USE [msdb]
GO
DECLARE @jobId BINARY(16)
EXEC  msdb.dbo.sp_add_job @job_name=N'DBA_DB_Backup_SQL_DIFF_Daily', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_netsend=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@description=N'DBA_DB_Backup_SQL_DIFF_Daily - except Friday', 
		@category_name=N'Database Maintenance', 
		@owner_login_name=N'GBR\SQLDBA_SERVICE', 
		@notify_email_operator_name=N'DBA', @job_id = @jobId OUTPUT
select @jobId
GO
EXEC msdb.dbo.sp_add_jobserver @job_name=N'DBA_DB_Backup_SQL_DIFF_Daily', @server_name = N'LEB-ODSMSSQL2\ODSMSSQL2'
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_add_jobstep @job_name=N'DBA_DB_Backup_SQL_DIFF_Daily', @step_name=N'DBA_DB_Backup_SQL_DIFF', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_fail_action=2, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'exec DBA_DB_Backup_SQL_DIFF', 
		@database_name=N'DBMONITOR', 
		@flags=0
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_update_job @job_name=N'DBA_DB_Backup_SQL_DIFF_Daily', 
		@enabled=1, 
		@start_step_id=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_netsend=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@description=N'DBA_DB_Backup_SQL_DIFF_Daily - except Friday', 
		@category_name=N'Database Maintenance', 
		@owner_login_name=N'GBR\SQLDBA_SERVICE', 
		@notify_email_operator_name=N'DBA', 
		@notify_netsend_operator_name=N'', 
		@notify_page_operator_name=N''
GO
USE [msdb]
GO
DECLARE @schedule_id int
EXEC msdb.dbo.sp_add_jobschedule @job_name=N'DBA_DB_Backup_SQL_DIFF_Daily', @name=N'DBA_DB_Backup_SQL_DIFF', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=95, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20120514, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959, @schedule_id = @schedule_id OUTPUT
select @schedule_id
GO



waitfor delay '00:00:02' 




USE [msdb]
GO


IF  EXISTS (SELECT job_id FROM msdb.dbo.sysjobs_view WHERE name = N'DBA_DB_Backup_IDERA_DIFF_Daily')
EXEC msdb.dbo.sp_delete_job @job_name=N'DBA_DB_Backup_IDERA_DIFF_Daily', @delete_unused_schedule=1
GO


USE [msdb]
GO
DECLARE @jobId BINARY(16)
EXEC  msdb.dbo.sp_add_job @job_name=N'DBA_DB_Backup_IDERA_DIFF_Daily', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_netsend=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@description=N'DBA_DB_Backup_IDERA_DIFF_Daily  --  mon- friday', 
		@category_name=N'Database Maintenance', 
		@owner_login_name=N'GBR\SQLDBA_SERVICE', @job_id = @jobId OUTPUT
select @jobId
GO
EXEC msdb.dbo.sp_add_jobserver @job_name=N'DBA_DB_Backup_IDERA_DIFF_Daily', @server_name = N'LEB-ODSMSSQL2\ODSMSSQL2'
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_add_jobstep @job_name=N'DBA_DB_Backup_IDERA_DIFF_Daily', @step_name=N'DBA_DB_Backup_IDERA_DIFF', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_fail_action=2, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'DBA_DB_Backup_IDERA_DIFF', 
		@database_name=N'DBMONITOR', 
		@flags=0
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_update_job @job_name=N'DBA_DB_Backup_IDERA_DIFF_Daily', 
		@enabled=1, 
		@start_step_id=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_netsend=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@description=N'DBA_DB_Backup_IDERA_DIFF_Daily  --  mon- friday', 
		@category_name=N'Database Maintenance', 
		@owner_login_name=N'GBR\SQLDBA_SERVICE', 
		@notify_email_operator_name=N'', 
		@notify_netsend_operator_name=N'', 
		@notify_page_operator_name=N''
GO
USE [msdb]
GO
DECLARE @schedule_id int
EXEC msdb.dbo.sp_add_jobschedule @job_name=N'DBA_DB_Backup_IDERA_DIFF_Daily', @name=N'DBA_DB_Backup_IDERA_DIFF', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=63, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20120513, 
		@active_end_date=99991231, 
		@active_start_time=200500, 
		@active_end_time=235959, @schedule_id = @schedule_id OUTPUT
select @schedule_id
GO



waitfor delay '00:00:02' 

USE [msdb]
GO


IF  EXISTS (SELECT job_id FROM msdb.dbo.sysjobs_view WHERE name = N'DBA_DB_Backup_IDERA_FULL_Weekly')
EXEC msdb.dbo.sp_delete_job @job_name=N'DBA_DB_Backup_IDERA_FULL_Weekly', @delete_unused_schedule=1
GO



USE [msdb]
GO
DECLARE @jobId BINARY(16)
EXEC  msdb.dbo.sp_add_job @job_name=N'DBA_DB_Backup_IDERA_FULL_Weekly', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_netsend=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@description=N'DBA_DB_Backup_IDERA_FULL_Weekly _ saturday', 
		@category_name=N'Database Maintenance', 
		@owner_login_name=N'GBR\SQLDBA_SERVICE', @job_id = @jobId OUTPUT
select @jobId
GO
EXEC msdb.dbo.sp_add_jobserver @job_name=N'DBA_DB_Backup_IDERA_FULL_Weekly', @server_name = N'LEB-ODSMSSQL2\ODSMSSQL2'

GO
USE [msdb]
GO
EXEC msdb.dbo.sp_add_jobstep @job_name=N'DBA_DB_Backup_IDERA_FULL_Weekly', @step_name=N'DBA_DB_Backup_IDERA_FULL', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_fail_action=2, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'exec DBA_DB_Backup_IDERA_FULL', 
		@database_name=N'dbmonitor', 
		@flags=0
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_update_job @job_name=N'DBA_DB_Backup_IDERA_FULL_Weekly', 
		@enabled=1, 
		@start_step_id=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_netsend=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@description=N'DBA_DB_Backup_IDERA_FULL_Weekly _ saturday', 
		@category_name=N'Database Maintenance', 
		@owner_login_name=N'GBR\SQLDBA_SERVICE', 
		@notify_email_operator_name=N'', 
		@notify_netsend_operator_name=N'', 
		@notify_page_operator_name=N''
GO
USE [msdb]
GO
DECLARE @schedule_id int
EXEC msdb.dbo.sp_add_jobschedule @job_name=N'DBA_DB_Backup_IDERA_FULL_Weekly', @name=N'DBA_DB_Backup_IDERA_FULL', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=64, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20120512, 
		@active_end_date=99991231, 
		@active_start_time=213000, 
		@active_end_time=235959, @schedule_id = @schedule_id OUTPUT
select @schedule_id
GO
