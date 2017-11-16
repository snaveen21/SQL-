DECLARE @ResultCode	INT

EXEC @ResultCode = [master].[dbo].[xp_ss_backup] 
	@database = N'ESPView', 
	@filename = N'\\Leb-odsmssql2\backup2\Leb-odsmssql2\LEB-ODSMSSQL2_ESPView_Full_Copy_Only_20131003.safe', 
	@backupdescription = N'LEB-ODSMSSQL2_ESPView_Full_Copy_Only_20131003', 
	@backupname = N'LEB-ODSMSSQL2_ESPView_Full_Copy_Only_20131003', 
	@compressionlevel = N'ispeed', 
	@copyonly = N'1', 
	@server = N'leb-odsmssql2', 
	@instancename = N'odsmssql2'

IF(@ResultCode != 0)
	RAISERROR('One or more operations failed to complete.', 16, 1);

