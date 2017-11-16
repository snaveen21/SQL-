
SELECT * 
FROM fn_trace_gettable
('C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\Log\log.trc', default);
GO




sp_who2


select @@SERVICENAME
#



-- check free space

EXEC master..xp_fixeddrives

--drive MB free

------- -----------

--C 0 <------------- HELP !!!!!

--F 115360

--G 253473

 

-- lets recycle the SQL Errorlog a few times to claim some space back

EXEC sp_cycle_errorlog WAITFOR DELAY '00:00:02'

GO

EXEC sp_cycle_errorlog WAITFOR DELAY '00:00:02'

GO

EXEC sp_cycle_errorlog WAITFOR DELAY '00:00:02'

GO

EXEC sp_cycle_errorlog WAITFOR DELAY '00:00:02'

GO

EXEC sp_cycle_errorlog WAITFOR DELAY '00:00:02'

GO

EXEC sp_cycle_errorlog WAITFOR DELAY '00:00:02'

GO

EXEC sp_cycle_errorlog

GO

-- check free space again

EXEC master..xp_fixeddrives

--drive MB free

------- -----------

--C 2500

--F 115360

--G 253477  