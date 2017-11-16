SELECT j.name JobName,h.step_id Step_ID, h.step_name StepName, 
RunDate = CONVERT(CHAR(10), CAST(STR(h.run_date,8, 0) AS dateTIME), 126), 
STUFF(STUFF(RIGHT('000000' + CAST ( h.run_time AS VARCHAR(6 ) ) ,6),5,0,':'),3,0,':') RunTime, 
--h.run_duration StepDuration,
(((h.run_duration/10000)*3600)+((h.run_duration/100%100)*60)+(h.run_duration%100))/60 StepDuration_Mins,
case h.run_status when 0 then 'failed'
when 1 then 'Succeded' 
when 2 then 'Retry' 
when 3 then 'Cancelled' 
when 4 then 'In Progress' 
end as ExecutionStatus 
FROM sysjobhistory h inner join sysjobs j
ON j.job_id = h.job_id
where j.name = 'qvAUS' and 
--CONVERT(CHAR(10), CAST(STR(h.run_date,8, 0) AS dateTIME), 126) > CONVERT(char(10), GetDate(),126)
CONVERT(CHAR(10), CAST(STR(h.run_date,8, 0) AS dateTIME), 121) +' '+STUFF(STUFF(RIGHT('000000' + CAST ( h.run_time AS VARCHAR(6 ) ) ,6),5,0,':'),3,0,':') >  CONVERT( VARCHAR(10), GETdATE()-1, 121)+' 12:00:00.000'      
ORDER BY j.name, h.run_date, h.step_id
GO 
