--- Use this good one .-


	select ecp.spid, db.name as dbname,hostname,[program_name], ecp.cmd, ecp.blocked as blockedby, loginame,[text], waitresource,ecp.status, datediff(second, login_time,last_batch)Duration_sec

    from sys.sysprocesses ecp

    left join sys.sysdatabases db on ecp.dbid = db.dbid

    CROSS APPLY sys.dm_exec_sql_text(ecp.sql_handle) AS q

    --where loginame like '%adm-nswaminathan%'
    --where ecp.blocked in( 80) or SPID in (80)
    --where DB.NAME IN ( 'RANLDTTD_201507', 'RAGBRTTD_201507', 'RAFRATTD_201507')
    order by ecp.blocked desc, 1

       
       
--Wait Resource


	select db_name(database_id),total_elapsed_time,wait_type,wait_time,p.query_plan,* 
from sys.dm_exec_requests d
  cross apply sys.dm_exec_query_plan(d.plan_handle) p
where session_id>=50
	and session_id<>@@spid
	and isnull(wait_type, '') not like 'PREEMPTIVE%'
	and isnull(wait_type, '') not like 'TRACEWRITE'
	and isnull(wait_type, '') not like 'WAITFOR'
	and database_id <> ISNULL(db_id('distribution'),0)
order by d.wait_time desc
       
       
       
            sp_spaceused cdr_tran_account_link_new
            kill 71
   
            
  sp_who2 325          
 -- Kill 62

-------------------------------
DBCC SQLPERF(logspace)
BACKUP LOG LDW_DWL_AUS WITH NO_LOG

DBCC OPENTRAN

DBCC LOGINFO

DUMP   TRANSACTION  LDW_DWL_AUS  WITH  NO_LOG  
BACKUP   LOG  LDW_DWL_AUS  WITH  NO_LOG  
DBCC  SHRINKDATABASE(LDW_DWL_AUS)  
-----
WITH [Blocking]
AS (SELECT w.[session_id]
   ,s.[original_login_name]
   ,s.[login_name]
   ,w.[wait_duration_ms]
   ,w.[wait_type]
   ,r.[status]
   ,r.[wait_resource]
   ,w.[resource_description]
   ,s.[program_name]
   ,w.[blocking_session_id]
   ,s.[host_name]
   ,r.[command]
   ,r.[percent_complete]
   ,r.[cpu_time]
   ,r.[total_elapsed_time]
   ,r.[reads]
   ,r.[writes]
   ,r.[logical_reads]
   ,r.[row_count]
   ,q.[text]
   ,q.[dbid]
   ,p.[query_plan]
   ,r.[plan_handle]
 FROM [sys].[dm_os_waiting_tasks] w
 INNER JOIN [sys].[dm_exec_sessions] s ON w.[session_id] = s.[session_id]
 INNER JOIN [sys].[dm_exec_requests] r ON s.[session_id] = r.[session_id]
 CROSS APPLY [sys].[dm_exec_sql_text](r.[plan_handle]) q
 CROSS APPLY [sys].[dm_exec_query_plan](r.[plan_handle]) p
 WHERE w.[session_id] > 50
  AND w.[wait_type] NOT IN ('DBMIRROR_DBM_EVENT'
      ,'ASYNC_NETWORK_IO'))
SELECT b.[session_id] AS [WaitingSessionID]
      ,b.[blocking_session_id] AS [BlockingSessionID]
      ,b.[login_name] AS [WaitingUserSessionLogin]
      ,s1.[login_name] AS [BlockingUserSessionLogin]
      ,b.[original_login_name] AS [WaitingUserConnectionLogin] 
      ,s1.[original_login_name] AS [BlockingSessionConnectionLogin]
      ,b.[wait_duration_ms] AS [WaitDuration]
      ,b.[wait_type] AS [WaitType]
      ,t.[request_mode] AS [WaitRequestMode]
      ,UPPER(b.[status]) AS [WaitingProcessStatus]
      ,UPPER(s1.[status]) AS [BlockingSessionStatus]
      ,b.[wait_resource] AS [WaitResource]
      ,t.[resource_type] AS [WaitResourceType]
      ,t.[resource_database_id] AS [WaitResourceDatabaseID]
      ,DB_NAME(t.[resource_database_id]) AS [WaitResourceDatabaseName]
      ,b.[resource_description] AS [WaitResourceDescription]
      ,b.[program_name] AS [WaitingSessionProgramName]
      ,s1.[program_name] AS [BlockingSessionProgramName]
      ,b.[host_name] AS [WaitingHost]
      ,s1.[host_name] AS [BlockingHost]
      ,b.[command] AS [WaitingCommandType]
      ,b.[text] AS [WaitingCommandText]
      ,b.[row_count] AS [WaitingCommandRowCount]
      ,b.[percent_complete] AS [WaitingCommandPercentComplete]
      ,b.[cpu_time] AS [WaitingCommandCPUTime]
      ,b.[total_elapsed_time] AS [WaitingCommandTotalElapsedTime]
      ,b.[reads] AS [WaitingCommandReads]
      ,b.[writes] AS [WaitingCommandWrites]
      ,b.[logical_reads] AS [WaitingCommandLogicalReads]
      ,b.[query_plan] AS [WaitingCommandQueryPlan]
      ,b.[plan_handle] AS [WaitingCommandPlanHandle]
FROM [Blocking] b
INNER JOIN [sys].[dm_exec_sessions] s1
ON b.[blocking_session_id] = s1.[session_id]
INNER JOIN [sys].[dm_tran_locks] t
ON t.[request_session_id] = b.[session_id]
WHERE t.[request_status] = 'WAIT'
GO


USE Master
GO
EXEC sp_who2
GO



-------------------- Kill running Job


            EXEC msdb.dbo.sp_help_job @Job_name = 'LDW_AUS_DWL_CRM-TELCO LOAD'
            
            KILL STATS JOB 325
            
            kill 325
            
             
             