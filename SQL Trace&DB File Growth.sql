--To enable the default trace:

EXEC sp_configure 'show advanced options', 1;
GO
RECONFIGURE;
GO
EXEC sp_configure 'default trace enabled', 1;
GO
RECONFIGURE;
GO
EXEC sp_configure 'show advanced options', 0;
GO
RECONFIGURE;
GO

--To disable the default trace:

EXEC sp_configure 'show advanced options', 1;
GO
RECONFIGURE;
GO
EXEC sp_configure 'default trace enabled', 0;
GO
RECONFIGURE;
GO
EXEC sp_configure 'show advanced options', 0;
GO
RECONFIGURE;
GO

--To check whether the default trace is ON (1), or OFF (0):

EXEC sp_configure 'show advanced options', 1;
GO
RECONFIGURE;
GO
EXEC sp_configure 'default trace enabled';
GO
EXEC sp_configure 'show advanced options', 0;
GO
RECONFIGURE;
GO

--You can get additional information for all traces in the instance of SQL Server:

SELECT * FROM :: fn_trace_getinfo(default)
/*
This will give you a list of all of the traces that are running on the server.

The property of the trace as represented by the following integers:

1 – Trace Options (@options in sp_trace_create)
2 – FileName
3 – MaxSize
4 – StopTime
5 – Current Trace status (1 = On and 0 = Off)*/



-- Which data file is growing.

select distinct
    ei.eventid,
    e.name
from sys.fn_trace_geteventinfo(1) ei
inner join sys.trace_events e
on e.trace_event_id = ei.eventid
where name like '%grow%';

eventid	name
92	Data File Auto Grow
93	Log File Auto Grow

exec sp_configure 'default trace enabled',1;
go

select *
from sys.fn_trace_getinfo(1);

select
    te.name as event_name,
    tr.DatabaseName,
    tr.FileName,
    tr.StartTime,
    tr.EndTime
from sys.fn_trace_gettable('H:\ODS2\SYSTEM\MSSQL\Log\log_7956.trc', 0) tr
inner join sys.trace_events te
on tr.EventClass = te.trace_event_id
where tr.EventClass in (92, 93)
order by EndTime;

