
   
   -- To cycle Trace logs
   execute sp_cycle_errorlog
   
   
   
   
   DBCC CHECKDB WITH EXTENDED_LOGICAL_CHECKS, DATA_PURITY, NO_INFOMSGS
   
DBCC TRACESTATUS();
GO

DBCC TRACEOFF


DBCC TRACESTATUS(-1)
GO


sp_trace_setstatus @status =status 

DBCC TRACEOFF

--SQL Server 2005 (onwards):
SELECT * FROM sys.traces
-- If status is running : 1=Running and 0=OFF






-- To check all the non default traces running.
use [master]

select T.id as [Id],
       case T.status when 0 then N'stopped' else N'running' end as [Status],
       T.path as [Path],
       case T.is_rowset when 0 then N'false' else N'true' end as [Rowset],
       case T.is_shutdown when 0 then N'disabled' else N'enabled' end as [Shutdown option],
       T.start_time as [Start],
       T.stop_time as [Stop]
from sys.traces as T
where T.is_default <> 1;
------------------------------------------------

--**********************************************************************************************
-- The following query can be used to close all non-default traces it also lists their locations.

use [master];

set nocount on;

declare @result table ([Path] nvarchar(260) not null);

declare trace cursor local fast_forward for select T.id, T.path
                                            from sys.traces as T
                                            where T.is_default != 1;
                                            
open trace;

declare @id int;
declare @path nvarchar(260);

fetch next from trace
  into @id, @path;
  
while @@fetch_status = 0
begin
   execute sp_trace_setstatus
     @traceid = @id,
     @status = 0;
     
   execute sp_trace_setstatus
     @traceid = @id,
     @status = 2;
     
   if (@path is not null)
   begin
     insert into @result([Path])
       values (@path);
   end;

       fetch next from trace
         into @id, @path;
end;

close trace;
deallocate trace;

select R.[Path] as [Path]
from @result as R;

----In general, the queries require view server state permission:

grant alter trace to [login name];






SELECT * FROM fn_trace_getinfo(default);

USE msdb
SELECT * FROM :: fn_trace_getinfo(default) 

dbcc checkdb(msdb)

-- Job history
use msdb
select  * from sysjobhistory



use msdb
SP_GET_SQLAGENT_PROPERTIES

-- To change AGENT Log path
USE MASTER
GO
EXEC msdb.dbo.sp_set_sqlagent_properties 
@errorlog_file=N'G:\Microsoft SQL Server\MSSQL.1\MSSQL\LOG\SQLAGENT.OUT'
GO



--- Agent XPs Server Configuration Option
sp_configure 'show advanced options', 1;
GO
RECONFIGURE;
GO
sp_configure 'Agent XPs', 1;
GO
RECONFIGURE
GO