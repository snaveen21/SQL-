use master
go
-- sp_who2 active
-- sp_helpdb DEUView

-- Applies to SQLsafe Lite xp_ss_backup 6.0.0.0
-- This sample file contains T-SQL that shows the available parameters for the SQLsafe Lite backup XSP 
-- It also lists the various required and optional parameters for the XSP
-- If executed, this script will perform a backup of the DBMONITOR database and write the backup archive to c:\DBMONITOR.BAK
-- This script can be customized by modifying the required parameter variables or optional values below
			
DECLARE @DatabaseName             nvarchar(255)
DECLARE @DatabaseName2            nvarchar(255)
DECLARE @BackupPathAndFilename    varchar(255)
DECLARE @TruncateOnly             int	
DECLARE @Debug                    int	
DECLARE @Description              nvarchar(1024)
DECLARE @BackupName               nvarchar(255)
DECLARE @BackupType               nvarchar(255)
DECLARE @File                     nvarchar(255)
DECLARE @FileGroup                nvarchar(255)
DECLARE @Overwrite                int	
DECLARE @InstanceName             nvarchar(255)
DECLARE @Exclude                  nvarchar(1024)
DECLARE @NoTruncate               int	
DECLARE @NoSkip                   int	
DECLARE @Verify                   int	
DECLARE @WindowsUsername          nvarchar(255)
DECLARE @EncryptedWindowsPassword nvarchar(255)
DECLARE @Delete                   nvarchar(20)
DECLARE @CopyOnly                 int	
DECLARE @CheckSum                 int	
DECLARE @ContinueAfterError       int	
DECLARE @ReadWriteFileGroups      int	
DECLARE @Returncode               int	
DECLARE @Verbose                  int	
DECLARE @VDBFlag                  nvarchar(20)
			
SET @DatabaseName          = 'LEBATEMP'	
SET @BackupPathAndFilename = '\\192.168.0.58\backup\Databases\LEB-ODSMSSQL2\Do_not_Delete_DBA\LEBATEMP_20111124.BAK' -- change 
SET @Debug                 = 1	
SET @Description           = 'This is a backup of BI_Backup'
SET @BackupName            = 'BI_Backup20111124' -- change 
SET @BackupType            = 'Full'	
			
EXEC @Returncode = [master].[dbo].[xp_ss_backup] @database = @DatabaseName,@filename = @BackupPathAndFilename ,@BackupType  = 'Full'	


		-- *************** Required parameters ***************
			
		-- Name of database to backup
		
			
		-- Backup path and filename (where backup should go).
		
			
IF @Returncode != 0	
	BEGIN		
		RAISERROR	
		('Backup failure of database %s.', 16, 1, @DatabaseName)
	END		