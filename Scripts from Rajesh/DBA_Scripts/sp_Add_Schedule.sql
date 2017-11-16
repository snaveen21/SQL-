USE msdb ;
GO

EXEC sp_add_schedule
    @schedule_name = N'monthly_08' ,
    @freq_type = 16,
    @freq_interval = 8,
    @freq_recurrence_factor = 1,
    @active_start_time = 013500 ;
GO

EXEC sp_add_schedule
    @schedule_name = N'monthly_15_7days' ,
    @freq_type = 16,
    @freq_interval = 15,
    @freq_recurrence_factor = 1,
    @active_start_time = 013500 ;
GO

EXEC sp_add_schedule
    @schedule_name = N'monthly_22' ,
    @freq_type = 16,
    @freq_interval = 22,
    @freq_recurrence_factor = 1,
    @active_start_time = 013500 ;
GO

EXEC sp_add_schedule
    @schedule_name = N'monthly_29' ,
    @freq_type = 16,
    @freq_interval = 29,
    @freq_recurrence_factor = 1,
    @active_start_time = 013500 ;
GO

------------------------------1st of every March (for non-leap years only)--------------------------

EXEC sp_add_schedule
    @schedule_name = N'monthly_01_7days' ,
    @freq_type = 16,
    @freq_interval = 1,
    @freq_recurrence_factor = 12,
    @active_start_time = 013500,
    @active_start_date = 20140210
GO

EXEC sp_attach_schedule @job_name = N'DBA_DEUTTD_SNAPSHOT_REC_CDR_Archive_Auto', @schedule_name = N'monthly_01_7days'


--------------------------------------------------------------------------------------------------------


EXEC sp_attach_schedule @job_name = N'test', @schedule_name = N'monthly_8'


USE msdb ;
GO


EXEC sp_add_schedule
    @schedule_name = N'monthly_16_0135' ,
    @freq_type = 16,
    @freq_interval = 16,
    @freq_recurrence_factor = 1,
    @active_start_time = 013500 ;
GO

EXEC sp_add_schedule
    @schedule_name = N'monthly_17_0135' ,
    @freq_type = 16,
    @freq_interval = 17,
    @freq_recurrence_factor = 1,
    @active_start_time = 013500 ;
GO

EXEC sp_add_schedule
    @schedule_name = N'monthly_18_0135' ,
    @freq_type = 16,
    @freq_interval = 18,
    @freq_recurrence_factor = 1,
    @active_start_time = 013500 ;
GO


---------------Jobs using particular schedule--------------------------

select j.name Job_Name, ss.name Schedule_Name from sysjobs j inner join sysjobschedules sj
on j.job_id = sj.job_id 
inner join sysschedules ss 
on sj.schedule_id = ss.schedule_id 
where ss.name = 'monthly_15_7days'  -- schedule name


------------------------One Time Schedule----------------------------------

EXEC sp_add_schedule
    @schedule_name = N'24_May_0135' ,
    @freq_type = 4,
    @freq_interval = 1,
    @active_start_date = 20130523,
    @active_end_date = 20130524,
    @active_start_time = 013500 ;
GO

EXEC sp_attach_schedule @job_name = N'DBA_FRATTD_FRA_LANG_Archive', @schedule_name = N'24_May_0135'
EXEC sp_attach_schedule @job_name = N'DBA_GBRTTD_GBR_LANG_Archive', @schedule_name = N'24_May_0135'
EXEC sp_attach_schedule @job_name = N'DBA_NLDTTD_NLD_LANG_Archive', @schedule_name = N'24_May_0135'



-------------------------------Removes an association between a schedule and a job-----------------------------------

USE msdb
GO

EXEC dbo.sp_detach_schedule
    @job_name = 'test_1',
    @schedule_name = 'monthly_01_7days' ;
GO
