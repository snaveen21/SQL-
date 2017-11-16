
-- Applies to SQLsafe Lite xp_ss_verify version 6.0.0.0
-- This sample file contains T-SQL that calls the SQLsafe verify XSP
-- It also lists the various required and optional parameters for the XSP
-- If executed, this script will perform a verify (restore verify only) of the pubs database from the backup archive located at c:\pubs.safe
-- This script can be customized by modifying the required parameter variables or optional values below

DECLARE @DatabaseName             nvarchar(255)
DECLARE @ArchivePathAndFilename   varchar(255)
DECLARE @Debug                    int
DECLARE @BackupSet                int
DECLARE @WindowsUsername          nvarchar(255)
DECLARE @EncryptedWindowsPassword nvarchar(255)
DECLARE @EncryptedRestorePassword nvarchar(255)
DECLARE @NoStatus                 int
DECLARE @ContinueAfterError       int
DECLARE @Returncode               int
DECLARE @InstanceName             nvarchar(255)
DECLARE @BackupFile				  nvarchar(255)

SET @DatabaseName           = 'pubs'
SET @ArchivePathAndFilename = 'c:\pubs.safe'
SET @Debug                  = 1

EXEC @Returncode = [master].[dbo].[xp_ss_verify] 

		-- *************** Required parameters ***************

		-- Name of database to backup.
		@database = @DatabaseName,

		-- Archive path and filename (where backup set is located).
		@filename = @ArchivePathAndFilename,
		
		
		-- *************** Common Options ***************	

		-- The backup set to restore (1 based).
		@backupset = @BackupSet,		

		-- Not required if instance is local.
		@instancename = @InstanceName,
			

		-- *************** Security Options ***************

		-- The Widnows user that will be used to read the backup archive file on the remote server.
		@windowsusername = @WindowsUsername,

		-- The password for the Windows user specified in the @windowsusername.
		@encryptedwindowspassword = @EncryptedWindowsPassword,

		-- *************** Encryption Options ***************		

		-- SQLsafe Lite cannot encrypt backups but it can restore them.
		@encryptedrestorepassword = @EncryptedRestorePassword,


		-- *************** Advanced Options ***************		

		-- Additional backup archive files (when restoring from stripes).
		@backupfile = @BackupFile,
		
		-- Instructs SQL Server to continue the operation despite encountering errors such as invalid checksums (SQL Server 2005 Only).  Allowed values {0|1}. 
		@continueaftererror = @ContinueAfterError,

		-- Toggles display of the command line arguments which can be used to invoke SQLsafeCMD from the command line. Allowed values {0|1}.
		@debug = @Debug,

		-- Prevents status messages from being cached or sent to the Repository. Allowed values {0|1}.
		@nostatus = @NoStatus		
		

IF @Returncode != 0
	BEGIN
		RAISERROR
		('Verify failure of database %s.', 16, 1, @DatabaseName)
	END

