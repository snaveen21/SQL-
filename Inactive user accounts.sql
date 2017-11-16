/**************************************************
*** Script to find unused logins
*** Author: GlutenFreeSQL
*****************************************************/
DECLARE @DBLogins TABLE
(
UserName sysname,
UserSid varbinary(85)
)
INSERT INTO @DBLogins
EXEC sp_msforeachdb 'USE ? SELECT [name], sid from sys.database_principals WHERE type &lt;&gt; ''R'' '
 
use master
select name
from syslogins
where [name] not in(
select distinct UserName
from @DBLogins
)
and [sid] not in(
select distinct UserSid
from @DBLogins
WHERE UserSid is not null
)
and sysadmin &lt;&gt; 1
and hasaccess = 1
 
/*
--Check for jobs owned by user before deleting any
select distinct SUSER_SNAME(owner_sid)
from msdb.dbo.sysjobs
 
select SUSER_SNAME(owner_sid), *
from msdb.dbo.sysjobs
WHERE SUSER_SNAME(owner_sid) &lt;&gt; 'sa'
*/










/**************************************************
*** Script to find orphaned database users
*** Author: GlutenFreeSQL
*****************************************************/
 
--drop table #DBUsers
DECLARE @DBUsers TABLE
(
DatabaseName sysname,
UserName sysname
)
INSERT @DBUsers
EXEC sp_msforeachdb 'USE ?
select DB_NAME(), name
from sysusers
where islogin = 1
and hasdbaccess = 1
and DB_NAME() not in(''msdb'', ''master'', ''tempdb'')
and [name] COLLATE DATABASE_DEFAULT not in(
   select name from master.dbo.syslogins
)
and [sid] not in(
   select [sid] from master.dbo.syslogins
)
and [name] not in(
   select distinct SCHEMA_NAME(schema_id) from sys.objects
)'
 
select * from @DBUsers
order by DatabaseName, UserName

