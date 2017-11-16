--drop view dbo.View_Success_Jobs

CREATE VIEW dbo.View_Failed_Jobs
    AS
SELECT   Job.instance_id
        ,SysJobs.job_id
        ,SysJobs.name as 'JOB_NAME'
        ,SysJobSteps.step_name as 'STEP_NAME'
        ,Job.run_status
        ,Job.sql_message_id
        ,Job.sql_severity
        ,Job.message
        ,Job.exec_date
        ,Job.run_duration
        ,Job.server
        ,SysJobSteps.output_file_name
    FROM    (SELECT Instance.instance_id
        ,DBSysJobHistory.job_id
        ,DBSysJobHistory.step_id
        ,DBSysJobHistory.sql_message_id
        ,DBSysJobHistory.sql_severity
        ,DBSysJobHistory.message
        ,(CASE DBSysJobHistory.run_status
            WHEN 0 THEN 'Failed'
            WHEN 1 THEN 'Succeeded'
            WHEN 2 THEN 'Retry'
            WHEN 3 THEN 'Canceled'
            WHEN 4 THEN 'In progress'
        END) as run_status
        ,((SUBSTRING(CAST(DBSysJobHistory.run_date AS VARCHAR(8)), 5, 2) + '/'
        + SUBSTRING(CAST(DBSysJobHistory.run_date AS VARCHAR(8)), 7, 2) + '/'
        + SUBSTRING(CAST(DBSysJobHistory.run_date AS VARCHAR(8)), 1, 4) + ' '
        + SUBSTRING((REPLICATE('0',6-LEN(CAST(DBSysJobHistory.run_time AS varchar)))
        + CAST(DBSysJobHistory.run_time AS VARCHAR)), 1, 2) + ':'
        + SUBSTRING((REPLICATE('0',6-LEN(CAST(DBSysJobHistory.run_time AS VARCHAR)))
        + CAST(DBSysJobHistory.run_time AS VARCHAR)), 3, 2) + ':'
        + SUBSTRING((REPLICATE('0',6-LEN(CAST(DBSysJobHistory.run_time as varchar)))
        + CAST(DBSysJobHistory.run_time AS VARCHAR)), 5, 2))) AS 'exec_date'
        ,DBSysJobHistory.run_duration
        ,DBSysJobHistory.retries_attempted
        ,DBSysJobHistory.server
        FROM msdb.dbo.sysjobhistory DBSysJobHistory
        JOIN (SELECT DBSysJobHistory.job_id
            ,DBSysJobHistory.step_id
            ,MAX(DBSysJobHistory.instance_id) as instance_id
            FROM msdb.dbo.sysjobhistory DBSysJobHistory
            GROUP BY DBSysJobHistory.job_id
            ,DBSysJobHistory.step_id
            ) AS Instance ON DBSysJobHistory.instance_id = Instance.instance_id
        WHERE DBSysJobHistory.run_status <> 1
        ) AS Job
    JOIN msdb.dbo.sysjobs SysJobs
       ON (Job.job_id = SysJobs.job_id)
    JOIN msdb.dbo.sysjobsteps SysJobSteps
       ON (Job.job_id = SysJobSteps.job_id AND Job.step_id = SysJobSteps.step_id)
    GO
    
    
-- All the Failed JOBs that failed.
    -- Select JOB_Name,STEP_NAME,run_status, Exec_Date as [Last Execution], SERVER, message as Error_MSG from View_Failed_Jobs
    --Select *from View_Failed_Jobs
    
-- All the Enabled Jobs in the Server That Failed.  

---- ****** USE THIS ****** ---- 

Select  A.JOB_Name, A.STEP_NAME,
(CASE B.Enabled
    WHEN 0 THEN 'DISABLED'
    WHEN 1 THEN 'ENABLED'
END) as JOBSchdule_Status, 
A.run_status, A.Exec_Date as [Last Execution], A.SERVER, A.message as Error_MSG
From View_Failed_Jobs A
Inner Join msdb.dbo.sysjobs B on A.job_id = B.job_id where B.enabled=1 --and A.JOB_NAME like 'qv%'
order by 5 desc

---- ****** USE THIS ****** ----     

189836

select top 10 * from dbo.View_Success_Jobs

Select  A.JOB_Name, A.STEP_NAME,
(CASE B.Enabled
    WHEN 0 THEN 'DISABLED'
    WHEN 1 THEN 'ENABLED'
END) as JOBSchdule_Status, 
A.run_status, A.Exec_Date as [Last Execution], A.SERVER, A.message as Error_MSG
From View_Success_Jobs A
Inner Join msdb.dbo.sysjobs B on A.job_id = B.job_id where B.enabled=1



Select  A.JOB_Name, A.STEP_NAME,
(CASE B.Enabled
    WHEN 0 THEN 'DISABLED'
    WHEN 1 THEN 'ENABLED'
END) as JOBSchdule_Status, 
A.run_status, A.Exec_Date as [Last Execution], A.SERVER, A.message as Error_MSG
From View_Failed_Jobs A
Inner Join msdb.dbo.sysjobs B on A.job_id = B.job_id where B.enabled=1




    
-- All the Enabled Jobs in the Server.    
Select A.job_id, B.name,b.enabled, 
last_outcome_message,*
From msdb.dbo.SysJobServers A
Inner Join msdb.dbo.sysjobs B on A.job_id = B.job_id where B.enabled=1



declare @chkCMDShell as sql_variant
select @chkCMDShell = value from sys.configurations where name = 'xp_cmdshell'
if @chkCMDShell = 0
begin
 EXEC sp_configure 'xp_cmdshell', 1
 RECONFIGURE;
end
else
begin
 Print 'xp_cmdshell is already enabled'
end


declare @svrName varchar(255)
declare @sql varchar(400)
--by default it will take the current server name, we can the set the server name as well
set @svrName = @@SERVERNAME
set @sql = 'powershell.exe -c "Get-WmiObject -ComputerName ' + QUOTENAME(@svrName,'''') + ' -Class Win32_Volume -Filter ''DriveType = 3'' | select name,capacity,freespace | foreach{$_.name+''|''+$_.capacity/1048576+''%''+$_.freespace/1048576+''*''}"'
--creating a temporary table
CREATE TABLE #output
(line varchar(255))
--inserting disk name, total space and free space value in to temporary table
insert #output
EXEC xp_cmdshell @sql
--script to retrieve the values in MB from PS Script output
select rtrim(ltrim(SUBSTRING(line,1,CHARINDEX('|',line) -1))) as drivename
      ,round(cast(rtrim(ltrim(SUBSTRING(line,CHARINDEX('|',line)+1,
      (CHARINDEX('%',line) -1)-CHARINDEX('|',line)) )) as Float),0) as 'capacity(MB)'
      ,round(cast(rtrim(ltrim(SUBSTRING(line,CHARINDEX('%',line)+1,
      (CHARINDEX('*',line) -1)-CHARINDEX('%',line)) )) as Float),0) as 'freespace(MB)'
from #output
where line like '[A-Z][:]%'
order by drivename
--script to retrieve the values in GB from PS Script output
select rtrim(ltrim(SUBSTRING(line,1,CHARINDEX('|',line) -1))) as drivename
      ,round(cast(rtrim(ltrim(SUBSTRING(line,CHARINDEX('|',line)+1,
      (CHARINDEX('%',line) -1)-CHARINDEX('|',line)) )) as Float)/1024,0) as 'capacity(GB)'
      ,round(cast(rtrim(ltrim(SUBSTRING(line,CHARINDEX('%',line)+1,
      (CHARINDEX('*',line) -1)-CHARINDEX('%',line)) )) as Float) /1024 ,0)as 'freespace(GB)'
from #output
where line like '[A-Z][:]%'
order by drivename
--script to drop the temporary table
drop table #output


-- disable all the JOBs enabled


use msdb


USE MSDB;
GO
select *
FROM MSDB.dbo.sysjobs J
 JOIN MSDB.dbo.syscategories C
ON J.category_id = C.category_id and J.enabled=1
--WHERE 
--WHERE C.[Name] = 'Database Maintenance';
GO


select * from syscategories order by 1


select *  from dbo.sysjobs  nolock where enabled=1 and job_id in (
select job_id from historyjob_status where enabled=1)

update dbo.sysjobs  set enabled=0  where enabled=1 and job_id in (
select job_id from historyjob_status where enabled=1)


-- Reenable all the jobs that are enabled before.

DBSysJobHistory