

*****************************************
STEP 1: UNINSTALL PREVIOUSLY DEPLOYED DLL
*****************************************

If there is a previous install of the SQLsafe XSPs, you must uninstall the stored procedures and unload the SQL Server memory.

To uninstall the SQLsafe XSPs:

1. Use Query Analyzer or SQL Server Management studio to connect to the target SQL Server instance as a member of the sysadmin role.

2. Unload the DLL from memory using the following T-SQL script:

                                USE [master]   
                                DBCC SQLSafe_ExtendedStoredProc (free)
                GO

   If this step fails, stop and restart the SQL Server service, and then execute the script again.

3. Drop the extended stored procedure(s) using the following T-SQL script:

EXEC sp_dropextendedproc 'xp_ss_backup'
EXEC sp_dropextendedproc 'xp_ss_restore'
EXEC sp_dropextendedproc 'xp_ss_verify'
EXEC sp_dropextendedproc 'xp_ss_list'
EXEC sp_dropextendedproc 'xp_ss_listfiles'
EXEC sp_dropextendedproc 'xp_ss_objectlist'
EXEC sp_dropextendedproc 'xp_ss_objectrestore'
EXEC sp_dropextendedproc 'xp_ss_extract'
EXEC sp_dropextendedproc 'xp_ss_browse'
EXEC sp_dropextendedproc 'xp_ss_restoreheaderonly'
EXEC sp_dropextendedproc 'xp_ss_restorefilelistonly'
EXEC sp_dropextendedproc 'xp_ss_expire'
GO

If any of the extended stored procedures did not already exist on this server, you may receive a message like the one below.  Since these did not exist, this message is harmless and can be ignored.

Msg 3701, Level 11, State 5, Procedure sp_dropextendedproc, Line 16 Cannot drop the procedure 'xp_ss_backup', because it does not exist or you do not have permission.

4. Locate and delete any copies of the file "SQLsafe_ExtendedStoredProc.dll" from the program files directories of your SQL Server instance.  The default location of this file is C:\Program Files\Microsoft SQL Server\MSSQL\MSSQL\Binn\SQLsafe_ExtendedStoredProc.dll.

5. Repeat the steps above for any additional instances on this server.


********************************
STEP 2: INSTALL the SQLsafe XSPs
********************************

1. Locate the appropriate DLL for your SQL Server in the SQLsafe program files directory; by default SQLsafe installs to c:\program files\idera\sqlsafe\.  There are four different XSP DLL files to choose from:

*SQLsafe_ExtendedStoredProc.dll - This file should be used on 32 bit SQL Server versions 2000 and later *SQLsafe_ExtendedStoredProc70.dll - This file should be used on 32 bit SQL Server 7 only *SQLsafe_ExtendedStoredProc-IA64.dll - This file should be used on itanium 64 bit SQL Server versions 2000 and later *SQLsafe_ExtendedStoredProc-x64.dll - This file should be used on x64 SQL Server versions 2005 and later

2. Once you have located the correct file, copy it to the appropriate location for your SQL Server:

* <SQLserver instance install path>\MSSQL$<SQLServerInstanceName>\Binn folder on each named instance
* <SQLserver default install path>\MSSQL\Binn folder on the default instance

By default, the install path is C:\Program Files\Microsoft SQL Server.

3. Rename the copied file to "SQLsafe_ExtendedStoredProc.dll" if necessary to match the scripts in the next section.

4. Repeat the steps above for any additional instances on this server.


************************************************
STEP 3: RUN THE SQLsafe XSPs REGISTRATION SCRIPT
************************************************

The following script registers the latest version of the SQLsafe XSPs with SQL Server. 

USE [master]
GO
EXEC sp_addextendedproc 'xp_ss_backup',        'SQLSafe_ExtendedStoredProc.dll'
EXEC sp_addextendedproc 'xp_ss_restore',       'SQLSafe_ExtendedStoredProc.dll'
EXEC sp_addextendedproc 'xp_ss_verify',        'SQLSafe_ExtendedStoredProc.dll'
EXEC sp_addextendedproc 'xp_ss_list',          'SQLSafe_ExtendedStoredProc.dll'
EXEC sp_addextendedproc 'xp_ss_listfiles',     'SQLSafe_ExtendedStoredProc.dll'
EXEC sp_addextendedproc 'xp_ss_objectlist',    'SQLSafe_ExtendedStoredProc.dll'
EXEC sp_addextendedproc 'xp_ss_objectrestore', 'SQLSafe_ExtendedStoredProc.dll'
EXEC sp_addextendedproc 'xp_ss_extract',       'SQLSafe_ExtendedStoredProc.dll'
EXEC sp_addextendedproc 'xp_ss_browse',        'SQLSafe_ExtendedStoredProc.dll'
EXEC sp_addextendedproc 'xp_ss_restoreheaderonly', 'SQLSafe_ExtendedStoredProc.dll'
EXEC sp_addextendedproc 'xp_ss_restorefilelistonly', 'SQLSafe_ExtendedStoredProc.dll'
EXEC sp_addextendedproc 'xp_ss_expire', 'SQLSafe_ExtendedStoredProc.dll'

*********************************
STEP 4: GRANT EXECUTE PERMISSIONS
*********************************

Use the following script to grant a user the ability to backup and restore data using these two extended stored procedures. You can add this script to the SQLsafe XSPs registration script, or execute it separately. When you execute this script, replace [mydomain\jsmith] with the domain and logon name of the appropriate user account. 

GRANT EXEC ON [master].[dbo].[xp_ss_backup]        TO [mydomain\jsmith]
GRANT EXEC ON [master].[dbo].[xp_ss_restore]       TO [mydomain\jsmith] 
GRANT EXEC ON [master].[dbo].[xp_ss_verify]        TO [mydomain\jsmith]
GRANT EXEC ON [master].[dbo].[xp_ss_list]          TO [mydomain\jsmith]
GRANT EXEC ON [master].[dbo].[xp_ss_listfiles]     TO [mydomain\jsmith]
GRANT EXEC ON [master].[dbo].[xp_ss_objectlist]    TO [mydomain\jsmith] 
GRANT EXEC ON [master].[dbo].[xp_ss_objectrestore] TO [mydomain\jsmith]
GRANT EXEC ON [master].[dbo].[xp_ss_extract]       TO [mydomain\jsmith]
GRANT EXEC ON [master].[dbo].[xp_ss_browse]        TO [mydomain\jsmith]
GRANT EXEC ON [master].[dbo].[xp_ss_restoreheaderonly] TO [mydomain\jsmith] GRANT EXEC ON [master].[dbo].[xp_ss_restorefilelistonly] TO [mydomain\jsmith] GRANT EXEC ON [master].[dbo].[xp_ss_expire] TO [mydomain\jsmith]

**********************
USING the SQLsafe XSPs
**********************

For examples of how to use the extended stored procedure, review the files in your XSPsamples directory (default location is C:\Program Files\Idera\SQLsafe\XSPsamples).

   

I look forward to hearing from you regarding the outcome and assisting further if necessary.
