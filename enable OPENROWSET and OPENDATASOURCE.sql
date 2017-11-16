-- How to enable OPENROWSET and OPENDATASOURCE

sp_configure "show advanced options",1
reconfigure
sp_configure "Ad Hoc Distributed Queries",1
reconfigure

SELECT *FROM OPENDATASOURCE('SQLNCLI','Data Source=LEB-ODSMSSQL1;Integrated Security=SSPI').master.sys.master_files 
