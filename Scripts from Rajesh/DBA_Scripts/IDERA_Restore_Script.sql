
/* ------------------- ...................................................................................................
 ------------------- ...................................................................................................
 ------------------- ...................................................................................................
  ------------------- .............................        RESTORE    .....................................................
   ------------------- ...................................................................................................
    ------------------- ...................................................................................................
*/------------------- ...................................................................................................

-- Applies to SQLsafe Lite xp_ss_restore 6.0.0.0
-- This sample file contains T-SQL that calls the SQLsafe restore XSP
-- It also lists the various required and optional parameters for the XSP
-- If executed, this script will perform a restore of the DBMONITOR database from the backup archive located at c:\DBMONITOR.BAK
-- This script can be customized by modifying the required parameter variables or optional values below
			
DECLARE @DatabaseName             nvarchar(255)
DECLARE @InstanceName             nvarchar(255)
DECLARE @ArchivePathAndFilename   varchar(255)
DECLARE @Debug                    int	
DECLARE @BackupSet                int	
DECLARE @DisconnectUsers          int	
DECLARE @WindowsUsername          nvarchar(255)
DECLARE @EncryptedWindowsPassword nvarchar(255)
DECLARE @EncryptedRestorePassword nvarchar(255)
DECLARE @NoStatus                 int	
DECLARE @WithMove                 nvarchar(1024)
DECLARE @Replace                  int	
DECLARE @RecoveryMode             nvarchar(10)
DECLARE @UndoFile                 nvarchar(1024)
DECLARE @StopAt                   nvarchar(255)
DECLARE @StopAtMark               nvarchar(255)
DECLARE @StopBeforeMark           nvarchar(255)
DECLARE @After                    nvarchar(255)
DECLARE @ContinueAfterError       int	
DECLARE @Returncode               int	
			
SET @DatabaseName           = 'DBMONITORRESTORE'
SET @ArchivePathAndFilename = 'c:\DBMONITOR.BAK'
SET @Debug                  = 1	
			
EXEC @Returncode = [master].[dbo].[xp_ss_restore] 
			
		-- *************** Required parameters ***************
			
		-- Name of database to backup.
		@database = @DatabaseName,			
		-- Archive path and filename (where backup set is located). 
		@filename = @ArchivePathAndFilename,
		-- The database logical filename to move to the physical target filename.
		-- '<logical_file_to_move> <physical_target_filename>', e.g., @withmove = 'data c:\newfile.ndf'.
		@withmove = 'dbmonitor	C:\dbmonitor\dbmonitor.mdf',
		@withmove ='dbmonitor_log	C:\dbmonitor\dbmonitor_log.ldf',
			
		-- If true (1), During restore, create the specified database and its related files even if another database already exists with the same name. Allowed values {0|1}.
		--@replace = 0  -- 0 means backup cannot replace
		--@replace = 1  -- 1 means backup will replace
			
IF @Returncode != 0	
	BEGIN		
		RAISERROR	
		('Restore failure of database %s.', 16, 1, @DatabaseName)
	END		

