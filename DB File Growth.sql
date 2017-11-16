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

exec sp_configure 'default trace disabled';
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

