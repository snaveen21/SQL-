-- To create Linked servers.

CREATE LOGIN lvmslkdsvr 
    WITH PASSWORD = 'leb-lvms01';
GO


EXEC master.dbo.sp_addlinkedserver @server = N'LEB-EDWFTDW02', @srvproduct=N'LEB-EDWFTDW02', @provider=N'SQLNCLI', @datasrc=N'LEB-EDWFTDW02'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'LEB-EDWFTDW02',@useself=N'True',@locallogin='lvmslkdsvr',@rmtuser='lvmslkdsvr',@rmtpassword='leb-lvms01'



EXEC master.dbo.sp_serveroption @server=N'LEB-EDWFTDW02', @optname=N'collation compatible', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'LEB-EDWFTDW02', @optname=N'data access', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'LEB-EDWFTDW02', @optname=N'dist', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'LEB-EDWFTDW02', @optname=N'pub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'LEB-EDWFTDW02', @optname=N'rpc', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'LEB-EDWFTDW02', @optname=N'rpc out', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'LEB-EDWFTDW02', @optname=N'sub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'LEB-EDWFTDW02', @optname=N'connect timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'LEB-EDWFTDW02', @optname=N'collation name', @optvalue=null
GO

EXEC master.dbo.sp_serveroption @server=N'LEB-EDWFTDW02', @optname=N'lazy schema validation', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'LEB-EDWFTDW02', @optname=N'query timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'LEB-EDWFTDW02', @optname=N'use remote collation', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'LEB-EDWFTDW02', @optname=N'remote proc transaction promotion', @optvalue=N'true'
GO