USE [DBMONITOR]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DBA_DB_Backup_COMP_DIFF_Retention]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[DBA_DB_Backup_COMP_DIFF_Retention]
GO

USE [DBMONITOR]
GO

Create Procedure [dbo].[DBA_DB_Backup_COMP_DIFF_Retention] ( @Location varchar(max),@DBName varchar(max))      
As      
      
--Declare @Location varchar(100)  
--Declare @DBName varchar(100)   
--Set @Location ='\\192.168.0.49\backup\Databases\LEB-DB003\'      
--Set @DBName ='DBMONITOR'  
      
      
select top 6 * into #ToDelete from T_Date where Date< convert(varchar(20),GETDATE()-6,111)      
order by ID desc      
      
          
--select * from #ToDelete   
      
Declare @StartDate int      
Declare @EndDate int      
--Declare @DatabaseName varchar(200)      
--Set @DatabaseName ='DBTest'      
      
Select @StartDate=Min(id),@enddate=max(id) from #Todelete      
      
While (@StartDate <=@EndDate )      
Begin      
      
Declare @SQL varchar(max)      
Declare @Week int      
Declare @Date datetime      
      
      
select @Week=Week,@date=date from t_date where id=@startdate      
      
 Set @SQL ='EXEC xp_cmdshell ''del  '+ @Location+cast(year(getdate()) as varchar)+'Weekly\'+cast(@Week as varchar(2))+'\'+@DBName + replace(Convert(varchar(10),@Date,121) ,'-','')+'_COMP_DIFF.bak'''      
  
     
--select @SQL       
Exec (@SQL)      
      
set @StartDate =@StartDate +1      
      
End
GO

waitfor delay '00:00:02' 

USE [DBMONITOR]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DBA_DB_Backup_COMP_DIFF]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[DBA_DB_Backup_COMP_DIFF]
GO


USE [DBMONITOR]
GO


Create Procedure [dbo].[DBA_DB_Backup_COMP_DIFF]    
AS              
-- Declare Location and get location from the configuration table              
              
Declare @Location varchar(250),  @LocationDelete  varchar(250)      
Declare @strQuaryP varchar(250),@strFullBackup varchar(1000)      
            
              
Declare @IDENT INT, @sql varchar(1000), @DBNAME VARCHAR(200)                                
DECLARE @File varchar(512)                                  
              
SELECT @Location= location FROM Dbmonitor.dbo.t_databases (nolock)                            
Where backupstatus=1      
              
Set   @LocationDelete=@Location            
              
              
If ( DATEPART (dd,getdate()))=1              
              
Set @Location =@Location+cast(year(getdate()) as varchar)+'\Monthly\' + cast(datepart(MM,getdate()) as varchar(2))+'\'              
Else              
Set @Location =@Location+cast(year(getdate()) as varchar)+'\Weekly\'+ cast(datepart(wk,getdate()) as varchar(2))+'\'              
              
--Select @Location              
              
              
If object_id('tempdb.dbo.#fileExist') is not null                  
      Drop table #fileExist                  
create table #fileExist (                  
      fileExists int,                  
      fileIsDir int,                  
      parentDirExists int                  
      )                  
                        
Insert into #fileExist                  
Exec xp_fileexist @Location                  
              
Declare @Directory int                  
select @Directory=fileIsDir from #fileExist                  
                  
select @Directory                  
                  
If @Directory=0                   
                  
Select @strQuaryP='xp_cmdshell ''md '+@Location+''''                  
Exec  (@strQuaryP)                  
                  
If @Directory=1                  
Print  'Directory Exists'                  
                       
                  
waitfor delay '00:00:02'                            
              
select @IDENT=min([database_id]) from SYS.DATABASES WHERE [database_id] > 0 AND                                   
NAME  COLLATE DATABASE_DEFAULT IN (SELECT Dbname FROM dbmonitor.dbo.[T_Databases](NOLOCK) WHERE BackupStatus = 1 and Dbname <> 'master')  --('DNKView', 'NLDView', 'GBRView','CHEView','AUSView','ESPView')                                  
while @IDENT is not null                                   
Begin                                  
SELECT @DBNAME = NAME FROM SYS.DATABASES WHERE [database_id] = @IDENT                        
              
-- Delete old files              
EXEC DBA_DB_Backup_COMP_DIFF_Retention @LocationDelete,@DBName              
               
--select @LocationDelete,@DBName            
                        
/*Change disk location here as required*/                                  
--Select @strFullBackup = 'SET QUOTED_IDENTIFIER OFF BACKUP DATABASE ' + @DBNAME + ' TO Disk="'+@Location +''+@DBNAME +''+Replace(Convert(char(10),Getdate(),121),'-','')+'.Bak'+'" WITH NOINIT,NOREWIND, NOUNLOAD,DESCRIPTION= N''Data_backup_'+Replace(Replace(Convert(char(13),Getdate(),121),'-',''),' ','_')+''',NAME=N''Data_backup_'+Replace(Replace(Convert(char(13),Getdate(),121),'-',''),' ','_') +''''                              
          
--Select @strFullBackup = 'SET QUOTED_IDENTIFIER OFF EXEC [master].[dbo].[xp_ss_backup] @database=''' + @DBNAME + ''',@filename= '''+@Location +''+@DBNAME +''+Replace(Convert(char(10),Getdate(),121),'-','')+'.Bak'''+',@backuptype=''Full'' ,@desc= N''backup_'+Replace(Replace(Convert(char(13),Getdate(),121),'-',''),' ','_')+''''                                       
Select @strFullBackup = 'SET QUOTED_IDENTIFIER OFF BACKUP DATABASE ['+ @DBNAME +'] TO Disk="'+@Location +''+@DBNAME +''+Replace(Convert(char(10),Getdate(),121),'-','')+'_COMP_DIFF.Bak'+'"  WITH  DIFFERENTIAL , NOINIT,NOREWIND, NOUNLOAD, COMPRESSION,DESCRIPTION= N''Data_backup_COMP_DIFF_'+Replace(Replace(Convert(char(13),Getdate(),121),'-',''),' ','_')+''',NAME=N''Data_backup_'+Replace(Replace(Convert(char(13),Getdate(),121),'-',''),' ','_') +''''                                

--BACKUP DATABASE [DBMONITOR] TO  DISK = N'\\192.168.0.58\backup\dbmonitor.bak' WITH NOFORMAT, NOINIT,  NAME = N'DBMONITOR-Full Database Backup', SKIP, NOREWIND, NOUNLOAD, COMPRESSION,  STATS = 10
--GO
        
select (@strFullBackup)                          
Exec  (@strFullBackup)                         
                           
                                 
SELECT @IDENT=min([database_id]) from SYS.DATABASES WHERE [database_id] > 0 and [database_id]>@IDENT AND NAME COLLATE DATABASE_DEFAULT IN (SELECT Dbname FROM dbmonitor.dbo.[T_Databases](NOLOCK) WHERE BackupStatus  = 1 )                                  
end                           
   
-- Delete history               

GO

waitfor delay '00:00:02' 


USE [DBMONITOR]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DBA_DB_Backup_COMP_FULL_Retention]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[DBA_DB_Backup_COMP_FULL_Retention]
GO


USE [DBMONITOR]
GO


Create Procedure [dbo].[DBA_DB_Backup_COMP_FULL_Retention] ( @Location varchar(max),@DBName varchar(max))      
As      
      
--Declare @Location varchar(100)  
--Declare @DBName varchar(100)   
  
--Set @Location ='\\192.168.0.49\backup\Databases\LEB-DB003\'      
  
--Set @DBName ='DBMONITOR'  
      
      
select top 6 * into #ToDelete from T_Date where Date< convert(varchar(20),GETDATE()-6,111)      
order by ID desc      

select  top 6 *   from T_Date
      
          
--select * from #ToDelete   
      
Declare @StartDate int      
Declare @EndDate int      
--Declare @DatabaseName varchar(200)      
--Set @DatabaseName ='DBTest'      
      
Select @StartDate=Min(id),@enddate=max(id) from #Todelete      
      
While (@StartDate <=@EndDate )      
Begin      
      
Declare @SQL varchar(max)      
Declare @Week int      
Declare @Date datetime      
      
      
select @Week=Week,@date=date from t_date where id=@startdate      
      
 Set @SQL ='EXEC xp_cmdshell ''del  '+ @Location+cast(year(getdate()) as varchar)+'\Weekly\'+cast(@Week as varchar(2))+'\'+@DBName + replace(Convert(varchar(10),@Date,121) ,'-','')+'_COMP_FULL.Bak'''      
  
     
--select @SQL       
Exec (@SQL)      
      
set @StartDate =@StartDate +1      
      
End

GO

waitfor delay '00:00:02' 


USE [DBMONITOR]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DBA_DB_Backup_COMP_FULL]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[DBA_DB_Backup_COMP_FULL]
GO

USE [DBMONITOR]
GO


Create Procedure [dbo].[DBA_DB_Backup_COMP_FULL]    
AS              
-- Declare Location and get location from the configuration table              
              
Declare @Location varchar(250),  @LocationDelete  varchar(250)      
Declare @strQuaryP varchar(250), @strFullBackup varchar(1000)      
            
              
Declare @IDENT INT, @sql varchar(1000), @DBNAME VARCHAR(200)                                
DECLARE @File varchar(512)                                  
              
SELECT @Location= location FROM Dbmonitor.dbo.t_databases (nolock)                            
Where backupstatus=1      
              
Set   @LocationDelete=@Location            
              
              
If ( DATEPART (dd,getdate()))=1              
              
Set @Location =@Location+cast(year(getdate()) as varchar)+'\Monthly\' + cast(datepart(MM,getdate()) as varchar(2))+'\'              
Else              
Set @Location =@Location+cast(year(getdate()) as varchar)+'\Weekly\'+ cast(datepart(wk,getdate()) as varchar(2))+'\'              
              
--Select @Location              
              
              
If object_id('tempdb.dbo.#fileExist') is not null                  
      Drop table #fileExist                  
create table #fileExist (                  
      fileExists int,                  
      fileIsDir int,                  
      parentDirExists int                  
      )                  
                        
Insert into #fileExist                  
Exec xp_fileexist @Location                  
              
Declare @Directory int                  
select @Directory=fileIsDir from #fileExist                  
                  
select @Directory                  
                  
If @Directory=0                   
                  
Select @strQuaryP='xp_cmdshell ''md '+@Location+''''                  
Exec  (@strQuaryP)                  
                  
If @Directory=1                  
Print  'Directory Exists'                  
                       
                  
waitfor delay '00:00:02'                            
              
select @IDENT=min([database_id]) from SYS.DATABASES WHERE [database_id] > 0 AND                                   
NAME  COLLATE DATABASE_DEFAULT IN (SELECT Dbname FROM dbmonitor.dbo.[T_Databases](NOLOCK) WHERE BackupStatus = 1 )  --('DNKView', 'NLDView', 'GBRView','CHEView','AUSView','ESPView')                                  
while @IDENT is not null                                  
Begin                                  
SELECT @DBNAME = NAME FROM SYS.DATABASES WHERE [database_id] = @IDENT                        
              
-- Delete old files              
EXEC DBA_DB_Backup_COMP_FULL_Retention @LocationDelete,@DBName              
               
--select @LocationDelete,@DBName            
                        
/*Change disk location here as required*/                                  
--Select @strFullBackup = 'SET QUOTED_IDENTIFIER OFF BACKUP DATABASE ' + @DBNAME + ' TO Disk="'+@Location +''+@DBNAME +''+Replace(Convert(char(10),Getdate(),121),'-','')+'.Bak'+'" WITH NOINIT,NOREWIND, NOUNLOAD,DESCRIPTION= N''Data_backup_'+Replace(Replace(Convert(char(13),Getdate(),121),'-',''),' ','_')+''',NAME=N''Data_backup_'+Replace(Replace(Convert(char(13),Getdate(),121),'-',''),' ','_') +''''                              
          
--Select @strFullBackup = 'SET QUOTED_IDENTIFIER OFF EXEC [master].[dbo].[xp_ss_backup] @database=''' + @DBNAME + ''',@filename= '''+@Location +''+@DBNAME +''+Replace(Convert(char(10),Getdate(),121),'-','')+'.Bak'''+',@backuptype=''Full'' ,@desc= N''backup_'+Replace(Replace(Convert(char(13),Getdate(),121),'-',''),' ','_')+''''                                       
Select @strFullBackup = 'SET QUOTED_IDENTIFIER OFF BACKUP DATABASE ['+ @DBNAME +'] TO Disk="'+@Location +''+@DBNAME +''+Replace(Convert(char(10),Getdate(),121),'-','')+'_COMP_FULL.Bak'+'" WITH NOINIT,NOREWIND, NOUNLOAD, COMPRESSION,DESCRIPTION= N''Data_backup_COMP_FULL_'+Replace(Replace(Convert(char(13),Getdate(),121),'-',''),' ','_')+''',NAME=N''Data_backup_'+Replace(Replace(Convert(char(13),Getdate(),121),'-',''),' ','_') +''''                                

--BACKUP DATABASE [DBMONITOR] TO  DISK = N'\\192.168.0.58\backup\dbmonitor.bak' WITH NOFORMAT, NOINIT,  NAME = N'DBMONITOR-Full Database Backup', SKIP, NOREWIND, NOUNLOAD, COMPRESSION,  STATS = 10
--GO
        
select (@strFullBackup)                          
Exec  (@strFullBackup)                         
                           
                                 
SELECT @IDENT=min([database_id]) from SYS.DATABASES WHERE [database_id] > 0 and [database_id]>@IDENT AND NAME  COLLATE DATABASE_DEFAULT  IN (SELECT Dbname FROM dbmonitor.dbo.[T_Databases](NOLOCK) WHERE BackupStatus=1)                                  
end                           
               
-- Delete history               

GO


waitfor delay '00:00:02' 

USE [DBMONITOR]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DBA_DB_Backup_IDERA_DIFF_Retention]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[DBA_DB_Backup_IDERA_DIFF_Retention]
GO


USE [DBMONITOR]
GO


CREATE Procedure [dbo].[DBA_DB_Backup_IDERA_DIFF_Retention] ( @Location varchar(max),@DBName varchar(max))      
As      
      
--Declare @Location varchar(100)  
--Declare @DBName varchar(100)   
--Set @Location ='\\192.168.0.49\backup\Databases\LEB-DB003\'      
--Set @DBName ='DBMONITOR'  
      
      
select top 6 * into #ToDelete from T_Date where Date< convert(varchar(20),GETDATE()-6,111)      
order by ID desc      
      
          
--select * from #ToDelete   
      
Declare @StartDate int      
Declare @EndDate int      
--Declare @DatabaseName varchar(200)      
--Set @DatabaseName ='DBTest'      
      
Select @StartDate=Min(id),@enddate=max(id) from #Todelete      
      
While (@StartDate <=@EndDate )      
Begin      
      
Declare @SQL varchar(max)      
Declare @Week int      
Declare @Date datetime      
      
      
select @Week=Week,@date=date from t_date where id=@startdate      
      
 Set @SQL ='EXEC xp_cmdshell ''del  '+ @Location+cast(year(getdate()) as varchar) +'Weekly\'+cast(@Week as varchar(2))+'\'+@DBName + replace(Convert(varchar(10),@Date,121) ,'-','')+'_IDERA_DIFF.bak'''      
  
     
--select @SQL       
Exec (@SQL)      
      
set @StartDate =@StartDate +1      
      
End
go

waitfor delay '00:00:02' 



USE [DBMONITOR]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DBA_DB_Backup_IDERA_DIFF]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[DBA_DB_Backup_IDERA_DIFF]
GO


USE [DBMONITOR]
GO


CREATE Procedure [dbo].[DBA_DB_Backup_IDERA_DIFF]    
AS              
-- Declare Location and get location from the configuration table              
              
Declare @Location varchar(250),  @LocationDelete  varchar(250)      
Declare @strQuaryP varchar(250),@strFullBackup varchar(1000)      
            
              
Declare @IDENT INT, @sql varchar(1000), @DBNAME VARCHAR(200)                                
DECLARE @File varchar(512)                                  
              
SELECT @Location= location FROM Dbmonitor.dbo.t_databases (nolock)                            
Where backupstatus=1      
              
Set   @LocationDelete=@Location            
              
              
If ( DATEPART (dd,getdate()))=1              
              
Set @Location =@Location+cast(year(getdate()) as varchar)+'\Monthly\' + cast(datepart(MM,getdate()) as varchar(2))+'\'              
Else              
Set @Location =@Location+cast(year(getdate()) as varchar)+'\Weekly\'+ cast(datepart(wk,getdate()) as varchar(2))+'\'              
              
--Select @Location              
              
              
If object_id('tempdb.dbo.#fileExist') is not null                  
      Drop table #fileExist                  
create table #fileExist (                  
      fileExists int,                  
      fileIsDir int,                  
      parentDirExists int                  
      )                  
                        
Insert into #fileExist                  
Exec xp_fileexist @Location                  
              
Declare @Directory int                  
select @Directory=fileIsDir from #fileExist                  
                  
select @Directory                  
                  
If @Directory=0                   
                  
Select @strQuaryP='xp_cmdshell ''md '+@Location+''''                  
Exec  (@strQuaryP)                  
                  
If @Directory=1                  
Print  'Directory Exists'                  
                       
                  
waitfor delay '00:00:02'                            
              
select @IDENT=min([database_id]) from SYS.DATABASES WHERE [database_id] > 0 AND                                   
NAME  COLLATE DATABASE_DEFAULT  IN (SELECT Dbname FROM dbmonitor.dbo.[T_Databases](NOLOCK) WHERE BackupStatus = 1  AND Dbname <> 'MASTER')  
while @IDENT is not null                                  
Begin                                  
SELECT @DBNAME = NAME FROM SYS.DATABASES WHERE [database_id] = @IDENT                        
              
-- Delete old files              
EXEC [DBA_DB_Backup_IDERA_DIFF_Retention] @LocationDelete,@DBName              
               
--select @LocationDelete,@DBName            
                        
/*Change disk location here as required*/                                  
--Select @strFullBackup = 'SET QUOTED_IDENTIFIER OFF BACKUP DATABASE ' + @DBNAME + ' TO Disk="'+@Location +''+@DBNAME +''+Replace(Convert(char(10),Getdate(),121),'-','')+'.Bak'+'" WITH NOINIT,NOREWIND, NOUNLOAD,DESCRIPTION= N''Data_backup_'+Replace(Replace(Convert(char(13),Getdate(),121),'-',''),' ','_')+''',NAME=N''Data_backup_'+Replace(Replace(Convert(char(13),Getdate(),121),'-',''),' ','_') +''''                                      
Select @strFullBackup = 'SET QUOTED_IDENTIFIER OFF EXEC [master].[dbo].[xp_ss_backup] @database=''' + @DBNAME + ''',@filename= '''+@Location +''+@DBNAME +''+Replace(Convert(char(10),Getdate(),121),'-','')+'_IDERA_DIFF.Bak'''+',@backuptype=''Differential'' ,@desc= N''backup_'+Replace(Replace(Convert(char(13),Getdate(),121),'-',''),' ','_')+''''                                       
--Select @strFullBackup = 'SET QUOTED_IDENTIFIER OFF BACKUP DATABASE ['+ @DBNAME +'] TO Disk="'+@Location +''+@DBNAME +''+Replace(Convert(char(10),Getdate(),121),'-','')+'_FULL_COMP.Bak'+'" WITH NOINIT,NOREWIND, NOUNLOAD, COMPRESSION,DESCRIPTION= N''Data_backup_FULL_COMP_'+Replace(Replace(Convert(char(13),Getdate(),121),'-',''),' ','_')+''',NAME=N''Data_backup_'+Replace(Replace(Convert(char(13),Getdate(),121),'-',''),' ','_') +''''                                
--BACKUP DATABASE [DBMONITOR] TO  DISK = N'\\192.168.0.58\backup\dbmonitor.bak' WITH NOFORMAT, NOINIT,  NAME = N'DBMONITOR-Full Database Backup', SKIP, NOREWIND, NOUNLOAD, COMPRESSION,  STATS = 10
--GO
        
select (@strFullBackup)                          
Exec  (@strFullBackup)                         
                           
                                 
SELECT @IDENT=min([database_id]) from SYS.DATABASES WHERE [database_id] > 0 and [database_id]>@IDENT AND NAME  COLLATE DATABASE_DEFAULT  IN (SELECT Dbname FROM dbmonitor.dbo.[T_Databases](NOLOCK) WHERE BackupStatus=1)                                  
end                           
             
-- Delete history               
GO




waitfor delay '00:00:02' 


USE [DBMONITOR]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DBA_DB_Backup_IDERA_FULL_Retention]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[DBA_DB_Backup_IDERA_FULL_Retention]
GO

USE [DBMONITOR]
GO

CREATE Procedure [dbo].[DBA_DB_Backup_IDERA_FULL_Retention] ( @Location varchar(max),@DBName varchar(max))      
As      
      
--Declare @Location varchar(100)  
--Declare @DBName varchar(100)   
--Set @Location ='\\192.168.0.49\backup\Databases\LEB-DB003\'      
--Set @DBName ='DBMONITOR'  
      
      
select top 6 * into #ToDelete from T_Date where Date< convert(varchar(20),GETDATE()-20,111)      
order by ID desc      

--select * from #ToDelete   
      
Declare @StartDate int      
Declare @EndDate int      
--Declare @DatabaseName varchar(200)      
--Set @DatabaseName ='DBTest'      
      
Select @StartDate=Min(id),@enddate=max(id) from #Todelete      
      
While (@StartDate <=@EndDate )      
Begin      
      
Declare @SQL varchar(max)      
Declare @Week int      
Declare @Date datetime      
      
      
select @Week=Week,@date=date from t_date where id=@startdate      
      
 Set @SQL ='EXEC xp_cmdshell ''del  '+ @Location+cast(year(getdate()) as varchar)+'\Weekly\'+cast(@Week as varchar(2))+'\'+@DBName + replace(Convert(varchar(10),@Date,121) ,'-','')+'_IDERA_FULL.Bak'''      
     
--select @SQL       
Exec (@SQL)      
      
set @StartDate =@StartDate +1      
      
End


GO

waitfor delay '00:00:02' 



USE [DBMONITOR]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DBA_DB_Backup_IDERA_FULL]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[DBA_DB_Backup_IDERA_FULL]
GO

USE [DBMONITOR]
GO

CREATE Procedure [dbo].[DBA_DB_Backup_IDERA_FULL]    
AS              
-- Declare Location and get location from the configuration table              
              
Declare @Location varchar(250),  @LocationDelete  varchar(250)      
Declare @strQuaryP varchar(250),@strFullBackup varchar(1000)      
            
              
Declare @IDENT INT, @sql varchar(1000), @DBNAME VARCHAR(200)                                
DECLARE @File varchar(512)                                  
              
SELECT @Location= location FROM Dbmonitor.dbo.t_databases (nolock)                            
Where backupstatus=1      
              
Set   @LocationDelete=@Location            
              
              
If ( DATEPART (dd,getdate()))=1              
              
Set @Location =@Location+cast(year(getdate()) as varchar)+'\Monthly\' + cast(datepart(MM,getdate()) as varchar(2))+'\'              
Else              
Set @Location =@Location+cast(year(getdate()) as varchar)+'\Weekly\'+ cast(datepart(wk,getdate()) as varchar(2))+'\'              
              
--Select @Location              
              
              
If object_id('tempdb.dbo.#fileExist') is not null                  
      Drop table #fileExist                  
create table #fileExist (                  
      fileExists int,                  
      fileIsDir int,                  
      parentDirExists int                  
      )                  
                        
Insert into #fileExist                  
Exec xp_fileexist @Location                  
              
Declare @Directory int                  
select @Directory=fileIsDir from #fileExist                  
                  
select @Directory                  
                  
If @Directory=0                   
                  
Select @strQuaryP='xp_cmdshell ''md '+@Location+''''                  
Exec  (@strQuaryP)                  
                  
If @Directory=1                  
Print  'Directory Exists'                  
                       
                  
waitfor delay '00:00:02'                            
              
select @IDENT=min([database_id]) from SYS.DATABASES WHERE [database_id] > 0 AND                                   
NAME  COLLATE DATABASE_DEFAULT IN (SELECT Dbname FROM dbmonitor.dbo.[T_Databases](NOLOCK) WHERE BackupStatus > 0 )  --('DNKView', 'NLDView', 'GBRView','CHEView','AUSView','ESPView')                                  
while @IDENT is not null                                  
Begin                                  
SELECT @DBNAME = NAME FROM SYS.DATABASES WHERE [database_id] = @IDENT                        
              
-- Delete old files              
EXEC [DBA_DB_Backup_IDERA_FULL_Retention] @LocationDelete,@DBName              
               
--select @LocationDelete,@DBName            
                        
/*Change disk location here as required*/                                  
--Select @strFullBackup = 'SET QUOTED_IDENTIFIER OFF BACKUP DATABASE ' + @DBNAME + ' TO Disk="'+@Location +''+@DBNAME +''+Replace(Convert(char(10),Getdate(),121),'-','')+'.Bak'+'" WITH NOINIT,NOREWIND, NOUNLOAD,DESCRIPTION= N''Data_backup_'+Replace(Replace(Convert(char(13),Getdate(),121),'-',''),' ','_')+''',NAME=N''Data_backup_'+Replace(Replace(Convert(char(13),Getdate(),121),'-',''),' ','_') +''''                                       
Select @strFullBackup = 'SET QUOTED_IDENTIFIER OFF EXEC [master].[dbo].[xp_ss_backup] @database=''' + @DBNAME + ''',@filename= '''+@Location +''+@DBNAME +''+Replace(Convert(char(10),Getdate(),121),'-','')+'_IDERA_FULL.Bak'''+',@backuptype=''Full'' ,@desc= N''backup_'+Replace(Replace(Convert(char(13),Getdate(),121),'-',''),' ','_')+''''                                       
--Select @strFullBackup = 'SET QUOTED_IDENTIFIER OFF BACKUP DATABASE ['+ @DBNAME +'] TO Disk="'+@Location +''+@DBNAME +''+Replace(Convert(char(10),Getdate(),121),'-','')+'_FULL_COMP.Bak'+'" WITH NOINIT,NOREWIND, NOUNLOAD, COMPRESSION,DESCRIPTION= N''Data_backup_FULL_COMP_'+Replace(Replace(Convert(char(13),Getdate(),121),'-',''),' ','_')+''',NAME=N''Data_backup_'+Replace(Replace(Convert(char(13),Getdate(),121),'-',''),' ','_') +''''                                
--BACKUP DATABASE [DBMONITOR] TO  DISK = N'\\192.168.0.58\backup\dbmonitor.bak' WITH NOFORMAT, NOINIT,  NAME = N'DBMONITOR-Full Database Backup', SKIP, NOREWIND, NOUNLOAD, COMPRESSION,  STATS = 10
--GO
        
select (@strFullBackup)                          
Exec  (@strFullBackup)                         
                           
                                 
SELECT @IDENT=min([database_id]) from SYS.DATABASES WHERE [database_id] > 0 and [database_id]>@IDENT AND NAME  COLLATE DATABASE_DEFAULT IN (SELECT Dbname FROM dbmonitor.dbo.[T_Databases](NOLOCK) WHERE BackupStatus>0)                                  
end                           
           
-- Delete history               

GO


waitfor delay '00:00:02' 




USE [DBMONITOR]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DBA_DB_Backup_SQL_DIFF_Retention]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[DBA_DB_Backup_SQL_DIFF_Retention]
GO


USE [DBMONITOR]
GO


CREATE Procedure [dbo].[DBA_DB_Backup_SQL_DIFF_Retention] ( @Location varchar(max),@DBName varchar(max))      
As      
      
--Declare @Location varchar(100)  
--Declare @DBName varchar(100)   
  
--Set @Location ='\\192.168.0.49\backup\Databases\LEB-DB003\'      
  
--Set @DBName ='DBMONITOR'  
      
      
select top 6 * into #ToDelete from T_Date where Date< convert(varchar(20),GETDATE()-6,111)      
order by ID desc      
      
          
--select * from #ToDelete   
      
Declare @StartDate int      
Declare @EndDate int      
--Declare @DatabaseName varchar(200)      
--Set @DatabaseName ='DBTest'      
      
Select @StartDate=Min(id),@enddate=max(id) from #Todelete      
      
While (@StartDate <=@EndDate )      
Begin      
      
Declare @SQL varchar(max)      
Declare @Week int      
Declare @Date datetime      
      
      
select @Week=Week,@date=date from t_date where id=@startdate      
      
 Set @SQL ='EXEC xp_cmdshell ''del  '+ @Location+cast(year(getdate()) as varchar) +'Weekly\'+cast(@Week as varchar(2))+'\'+@DBName + replace(Convert(varchar(10),@Date,121) ,'-','')+'_SQL_DIFF.bak'''      
  
     
--select @SQL       
Exec (@SQL)      
      
set @StartDate =@StartDate +1      
      
End
GO


waitfor delay '00:00:02' 


USE [DBMONITOR]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DBA_DB_Backup_SQL_DIFF]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[DBA_DB_Backup_SQL_DIFF]
GO


USE [DBMONITOR]
GO


Create Procedure [dbo].[DBA_DB_Backup_SQL_DIFF]    
AS              
-- Declare Location and get location from the configuration table              
              
Declare @Location varchar(250),  @LocationDelete  varchar(250)      
Declare @strQuaryP varchar(250),@strFullBackup varchar(1000)      
            
              
Declare @IDENT INT, @sql varchar(1000), @DBNAME VARCHAR(200)                                
DECLARE @File varchar(512)                                  
              
SELECT @Location= location FROM Dbmonitor.dbo.t_databases (nolock)                            
Where backupstatus=1      
              
Set   @LocationDelete=@Location            
              
              
If ( DATEPART (dd,getdate()))=1              
              
Set @Location =@Location+cast(year(getdate()) as varchar)+'\Monthly\' + cast(datepart(MM,getdate()) as varchar(2))+'\'              
Else              
Set @Location =@Location+cast(year(getdate()) as varchar)+'\Weekly\'+ cast(datepart(wk,getdate()) as varchar(2))+'\'              
              
--Select @Location              
              
              
If object_id('tempdb.dbo.#fileExist') is not null                  
      Drop table #fileExist                  
create table #fileExist (                  
      fileExists int,                  
      fileIsDir int,                  
      parentDirExists int                  
      )                  
                        
Insert into #fileExist                  
Exec xp_fileexist @Location                  
              
Declare @Directory int                  
select @Directory=fileIsDir from #fileExist                  
                  
select @Directory                  
                  
If @Directory=0                   
                  
Select @strQuaryP='xp_cmdshell ''md '+@Location+''''                  
Exec  (@strQuaryP)                  
                  
If @Directory=1                  
Print  'Directory Exists'                  
                       
                  
waitfor delay '00:00:02'                            
              
select @IDENT=min([database_id]) from SYS.DATABASES WHERE [database_id] > 0 AND                                   
NAME  COLLATE DATABASE_DEFAULT  IN (SELECT Dbname FROM dbmonitor.dbo.[T_Databases](NOLOCK) WHERE BackupStatus = 1 and Dbname <> 'master')  --('DNKView', 'NLDView', 'GBRView','CHEView','AUSView','ESPView')                                  
while @IDENT is not null                                  
Begin                                  
SELECT @DBNAME = NAME FROM SYS.DATABASES WHERE [database_id] = @IDENT                        
              
-- Delete old files              
EXEC DBA_DB_Backup_SQL_DIFF_Retention @LocationDelete,@DBName              
               
--select @LocationDelete,@DBName            
                        
/*Change disk location here as required*/                                  
--Select @strFullBackup = 'SET QUOTED_IDENTIFIER OFF BACKUP DATABASE ' + @DBNAME + ' TO Disk="'+@Location +''+@DBNAME +''+Replace(Convert(char(10),Getdate(),121),'-','')+'.Bak'+'" WITH NOINIT,NOREWIND, NOUNLOAD,DESCRIPTION= N''Data_backup_'+Replace(Replace(Convert(char(13),Getdate(),121),'-',''),' ','_')+''',NAME=N''Data_backup_'+Replace(Replace(Convert(char(13),Getdate(),121),'-',''),' ','_') +''''                              
          
--Select @strFullBackup = 'SET QUOTED_IDENTIFIER OFF EXEC [master].[dbo].[xp_ss_backup] @database=''' + @DBNAME + ''',@filename= '''+@Location +''+@DBNAME +''+Replace(Convert(char(10),Getdate(),121),'-','')+'.Bak'''+',@backuptype=''Full'' ,@desc= N''backup_'+Replace(Replace(Convert(char(13),Getdate(),121),'-',''),' ','_')+''''                                       
Select @strFullBackup = 'SET QUOTED_IDENTIFIER OFF BACKUP DATABASE ['+ @DBNAME +'] TO Disk="'+@Location +''+@DBNAME +''+Replace(Convert(char(10),Getdate(),121),'-','')+'_SQL_DIFF.Bak'+'"  WITH  DIFFERENTIAL , NOINIT,NOREWIND, NOUNLOAD ,DESCRIPTION= N''Data_backup_SQL_DIFF_'+Replace(Replace(Convert(char(13),Getdate(),121),'-',''),' ','_')+''',NAME=N''Data_backup_SQL_DIFF'+Replace(Replace(Convert(char(13),Getdate(),121),'-',''),' ','_') +''''                                

--BACKUP DATABASE [DBMONITOR] TO  DISK = N'\\192.168.0.58\backup\dbmonitor.bak' WITH NOFORMAT, NOINIT,  NAME = N'DBMONITOR-Full Database Backup', SKIP, NOREWIND, NOUNLOAD, COMPRESSION,  STATS = 10
--GO
        
select (@strFullBackup)                          
Exec  (@strFullBackup)                         
                           
                                 
SELECT @IDENT=min([database_id]) from SYS.DATABASES WHERE [database_id] > 0 and [database_id]>@IDENT AND NAME  COLLATE DATABASE_DEFAULT  IN (SELECT Dbname FROM dbmonitor.dbo.[T_Databases](NOLOCK) WHERE BackupStatus  = 1 )                                  
end                           
             
-- Delete history               

GO


waitfor delay '00:00:02' 



USE [DBMONITOR]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DBA_DB_Backup_SQL_FULL_Retention]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[DBA_DB_Backup_SQL_FULL_Retention]
GO



USE [DBMONITOR]
GO


Create Procedure [dbo].[DBA_DB_Backup_SQL_FULL_Retention] ( @Location varchar(max),@DBName varchar(max))      
As      
      
--Declare @Location varchar(100)  
--Declare @DBName varchar(100)   
--Set @Location ='\\192.168.0.49\backup\Databases\LEB-DB003\'      
--Set @DBName ='DBMONITOR'  
      
      
select top 6 * into #ToDelete from T_Date where Date< convert(varchar(20),GETDATE()-18,111)      
order by ID desc      
        
--select * from #ToDelete   
      
Declare @StartDate int      
Declare @EndDate int      
--Declare @DatabaseName varchar(200)      
--Set @DatabaseName ='DBTest'      
      
Select @StartDate=Min(id),@enddate=max(id) from #Todelete      
      
While (@StartDate <=@EndDate )      
Begin      
      
Declare @SQL varchar(max)      
Declare @Week int      
Declare @Date datetime      
      
      
select @Week=Week,@date=date from t_date where id=@startdate      
      
 Set @SQL ='EXEC xp_cmdshell ''del  '+ @Location+cast(year(getdate()) as varchar)+'\Weekly\'+cast(@Week as varchar(2))+'\'+@DBName + replace(Convert(varchar(10),@Date,121) ,'-','')+'_SQL_FULL.Bak'''      
  
     
--select @SQL       
Exec (@SQL)      
      
set @StartDate =@StartDate +1      
      
End


GO

waitfor delay '00:00:02' 


USE [DBMONITOR]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DBA_DB_Backup_SQL_FULL]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[DBA_DB_Backup_SQL_FULL]
GO

USE [DBMONITOR]
GO


Create Procedure [dbo].[DBA_DB_Backup_SQL_FULL]    
AS              
-- Declare Location and get location from the configuration table              
              
Declare @Location varchar(250),  @LocationDelete  varchar(250)      
Declare @strQuaryP varchar(250),@strFullBackup varchar(1000)      
            
              
Declare @IDENT INT, @sql varchar(1000), @DBNAME VARCHAR(200)                                
DECLARE @File varchar(512)                                  
              
SELECT @Location= location FROM Dbmonitor.dbo.t_databases (nolock)                            
Where backupstatus=1      
              
Set   @LocationDelete=@Location            
              
              
If ( DATEPART (dd,getdate()))=1              
              
Set @Location =@Location+cast(year(getdate()) as varchar)+'\Monthly\' + cast(datepart(MM,getdate()) as varchar(2))+'\'              
Else              
Set @Location =@Location+cast(year(getdate()) as varchar)+'\Weekly\'+ cast(datepart(wk,getdate()) as varchar(2))+'\'              
              
--Select @Location              
              
              
If object_id('tempdb.dbo.#fileExist') is not null                  
      Drop table #fileExist                  
create table #fileExist (                  
      fileExists int,                  
      fileIsDir int,                  
      parentDirExists int                  
      )                  
                        
Insert into #fileExist                  
Exec xp_fileexist @Location                  
              
Declare @Directory int                  
select @Directory=fileIsDir from #fileExist                  
                  
select @Directory                  
                  
If @Directory=0                   
                  
Select @strQuaryP='xp_cmdshell ''md '+@Location+''''                  
Exec  (@strQuaryP)                  
                  
If @Directory=1                  
Print  'Directory Exists'                  
                       
                  
waitfor delay '00:00:02'                            
              
select @IDENT=min([database_id]) from SYS.DATABASES WHERE [database_id] > 0 AND                                   
NAME  COLLATE DATABASE_DEFAULT  IN (SELECT Dbname FROM dbmonitor.dbo.[T_Databases](NOLOCK) WHERE BackupStatus = 1 )  --('DNKView', 'NLDView', 'GBRView','CHEView','AUSView','ESPView')                                  
while @IDENT is not null                                  
Begin                                  
SELECT @DBNAME = NAME FROM SYS.DATABASES WHERE [database_id] = @IDENT                        
              
-- Delete old files              
EXEC DBA_DB_Backup_SQL_FULL_Retention @LocationDelete,@DBName              
               
--select @LocationDelete,@DBName            
                        
/*Change disk location here as required*/                                  
--Select @strFullBackup = 'SET QUOTED_IDENTIFIER OFF BACKUP DATABASE ' + @DBNAME + ' TO Disk="'+@Location +''+@DBNAME +''+Replace(Convert(char(10),Getdate(),121),'-','')+'.Bak'+'" WITH NOINIT,NOREWIND, NOUNLOAD,DESCRIPTION= N''Data_backup_'+Replace(Replace(Convert(char(13),Getdate(),121),'-',''),' ','_')+''',NAME=N''Data_backup_'+Replace(Replace(Convert(char(13),Getdate(),121),'-',''),' ','_') +''''                              
--Select @strFullBackup = 'SET QUOTED_IDENTIFIER OFF EXEC [master].[dbo].[xp_ss_backup] @database=''' + @DBNAME + ''',@filename= '''+@Location +''+@DBNAME +''+Replace(Convert(char(10),Getdate(),121),'-','')+'.Bak'''+',@backuptype=''Full'' ,@desc= N''backup_'+Replace(Replace(Convert(char(13),Getdate(),121),'-',''),' ','_')+''''                                       
Select @strFullBackup = 'SET QUOTED_IDENTIFIER OFF BACKUP DATABASE ['+ @DBNAME +'] TO Disk="'+@Location +''+@DBNAME +''+Replace(Convert(char(10),Getdate(),121),'-','')+'_SQL_FULL.Bak'+'" WITH NOINIT,NOREWIND, NOUNLOAD,DESCRIPTION= N''Data_backup_SQL_FULL_'+Replace(Replace(Convert(char(13),Getdate(),121),'-',''),' ','_')+''',NAME=N''Data_backup_SQL_fULL_'+Replace(Replace(Convert(char(13),Getdate(),121),'-',''),' ','_') +''''                                
--BACKUP DATABASE [DBMONITOR] TO  DISK = N'\\192.168.0.58\backup\dbmonitor.bak' WITH NOFORMAT, NOINIT,  NAME = N'DBMONITOR-Full Database Backup', SKIP, NOREWIND, NOUNLOAD, COMPRESSION,  STATS = 10
--GO
        
select (@strFullBackup)                          
Exec  (@strFullBackup)                         
                           
                                 
SELECT @IDENT=min([database_id]) from SYS.DATABASES WHERE [database_id] > 0 and [database_id]>@IDENT AND NAME  COLLATE DATABASE_DEFAULT  IN (SELECT Dbname FROM dbmonitor.dbo.[T_Databases](NOLOCK) WHERE BackupStatus=1)                                  
end                           
          
-- Delete history               
GO





/*

-------------- backup timings 1

SELECT *  FROM DBMONITOR.DBO.T_Databases
GO

select * into    bckup_T_Databases_20140821 FROM DBMONITOR.DBO.T_Databases

--TRUNCATE TABLE DBMONITOR.DBO.T_Databases
--DBCC CHECKIDENT('T_Databases', RESEED, 1)

INSERT INTO  DBMONITOR.DBO.T_Databases ( Dbname)

 --DELETE FROM DBMONITOR.DBO.T_Databases ( Dbname)
SELECT  X.database_name   FROM 
(
select 
database_name
, backup_start_date,backup_finish_date 
, case  type when  'I' then 'Differential' when  'D' then 'FULL'  else 'Other' end BB
, Datename(weekday, backup_finish_date )   DD
, datediff ( HH, backup_start_date ,backup_finish_date)Hours     
, backup_size/1028/1028  SIZ
from msdb..backupset a, msdb..backupmediafamily b
where a.media_set_id = b.media_set_id 
--and database_name = 'Bi_backup_clean'  
and type = 'D' 
AND CONVERT( VARCHAR(10),backup_start_date , 121) in (  '2014-08-02' , '2014-08-03') 
--order by a.backup_start_date desc 
) X  
WHERE '['+database_name+']' NOT IN ( SELECT Dbname  FROM DBMONITOR.DBO.T_Databases)
ORDER BY '['+database_name+']' 

UPDATE DBMONITOR.DBO.T_Databases set Location  = 'H:\ODS2\BACKUP\Leb-odsmssql2\'

-- sp_who2 active
 --select * from sys.dm_exec_requests where session_id = 236  
   
   
   */