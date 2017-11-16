 -- KPMG AUDIT: Logins: Use this query


Select loginname,name,denylogin,isntname,hasaccess from sys.syslogins

-- BEGIN

 SELECT loginname,name,createdate,IsDisabled = CASE hasaccess
	WHEN '1' THEN 'Enabled'
	WHEN '0' THEN 'Disabled'
END, 
'Individual NT Login' LoginType 
FROM syslogins WHERE isntgroup = 0 AND isntname = 1  
UNION 
SELECT loginname,name,createdate,IsDisabled = CASE hasaccess
	WHEN '1' THEN 'Enabled'
	WHEN '0' THEN 'Disabled'
END,
'Individual SQL Login' LoginType 
FROM syslogins WHERE isntgroup = 0 AND isntname = 0  
UNION ALL 
-- Get Group logins 
SELECT loginname,name,createdate,IsDisabled = CASE hasaccess
	WHEN '1' THEN 'Enabled'
	WHEN '0' THEN 'Disabled'
END,'NT Group Login' LoginType 
FROM syslogins WHERE isntgroup = 1  

-- END



leb-nttextwiz01

Select name,createdate
/*,denylogin = CASE denylogin
	WHEN '1' THEN 'NT/Group AccessDenyed'
END*/
,isntname = CASE isntname
	WHEN '1' THEN 'NT/Group Login'
	WHEN '0' THEN 'SQL Server Login'
END

,IsDisabled = CASE hasaccess
	WHEN '1' THEN 'Enabled'
	WHEN '0' THEN 'Disabled'
END
 from sys.syslogins where name='GBR\John.OPearce'
 
 go
 
 Select name,createdate
,denylogin = CASE denylogin
	WHEN '1' THEN 'NT/Group AccessDenyed'
END
,isntname = CASE isntname
	WHEN '1' THEN 'NT/Group Login'
	WHEN '0' THEN 'SQL Server Login'
END

,IsDisabled = CASE hasaccess
	WHEN '1' THEN 'Enabled'
	WHEN '0' THEN 'Disabled'
END
 from sys.syslogins where name='GBR\John.OPearce'
 
 go
  select * from  sys.syslogins where name='GBR\John.OPearce'





ALTER LOGIN [GBR\Chris.Wedgwood]DISABLE 
go

/****** Object:  Login [GBR\John.OPearce]    Script Date: 11/07/2014 10:06:35 ******/
IF  EXISTS (SELECT * FROM sys.server_principals WHERE name = N'GBR\John.OPearce')
DROP LOGIN [GBR\John.OPearce]
GO




GBR\John.OPearce
GBR\Vijay.Bollineni

GBR\Alex.Quinn
GBR\Dean.Johnston
GBR\Dinesh.Kumar
GBR\Gautham.Subramanian
GBR\Kamalika.Basu
GBR\Michelle.Spilling
GBR\Prashant.Babu
GBR\Shubhojit.Banerjee
GBR\Srinivas.Cheva
GBR\Subhankar.B
GBR\zafar.abbas
GBR\Ysmael.Mendoza
GBR\S.Shivakumar
GBR\Prashant.Jaiswal
GBR\Rajesh.Khandapu
GBR\Vishal.Adwant
GBR\Maksym.Kozhukhar
GBR\Radha.Krishnan




ALTER LOGIN [GBR\Radha.Krishnan]DISABLE 






ALTER LOGIN [GBR\John.OPearce]DISABLE 
ALTER LOGIN [GBR\Vijay.Bollineni]DISABLE 
ALTER LOGIN [GBR\Alex.Quinn]DISABLE 
ALTER LOGIN [GBR\Dean.Johnston]DISABLE 
ALTER LOGIN [GBR\Dinesh.Kumar]DISABLE 
ALTER LOGIN [GBR\Gautham.Subramanian]DISABLE 
ALTER LOGIN [GBR\Kamalika.Basu]DISABLE 
ALTER LOGIN [GBR\Michelle.Spilling]DISABLE 
ALTER LOGIN [GBR\Prashant.Babu]DISABLE 
ALTER LOGIN [GBR\Shubhojit.Banerjee]DISABLE 
ALTER LOGIN [GBR\Srinivas.Cheva]DISABLE 
ALTER LOGIN [GBR\Subhankar.B]DISABLE 
--ALTER LOGIN [GBR\zafar.abbas]DISABLE 
ALTER LOGIN [GBR\Ysmael.Mendoza]DISABLE 
ALTER LOGIN [GBR\S.Shivakumar]DISABLE 
ALTER LOGIN [GBR\Prashant.Jaiswal]DISABLE 
ALTER LOGIN [GBR\Rajesh.Khandapu]DISABLE 
ALTER LOGIN [GBR\Vishal.Adwant]DISABLE 
ALTER LOGIN [GBR\Maksym.Kozhukhar]DISABLE 
ALTER LOGIN [GBR\Radha.Krishnan]DISABLE 



  select * from  sys.syslogins where name='GBR\Radha.Krishnan'
ALTER LOGIN [GBR\Radha.Krishnan]ENABLE 
--ALTER LOGIN [GBR\Radha.Krishnan]DISABLE


select name, is_disabled from sys.sql_logins where is_disabled=1 order by 1

select * from sys.syslogins sl
join 
sys.sql_logins sql
 on sl.sid=sql.sid
where is_disabled=1