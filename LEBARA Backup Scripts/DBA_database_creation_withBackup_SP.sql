------ xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

USE [master]
GO

CREATE DATABASE [DBA] ON  PRIMARY 
( NAME = N'DBMONITOR', FILENAME = N'D:\Program Files\Microsoft SQL Server\MSSQL10.MSSQLSERVER\MSSQL\DATA\DBA\dbmonitor.mdf' , SIZE = 112384KB , MAXSIZE = UNLIMITED, FILEGROWTH = 10%)
 LOG ON 
( NAME = N'DBMONITOR_log', FILENAME = N'D:\Program Files\Microsoft SQL Server\MSSQL10.MSSQLSERVER\MSSQL\DATA\DBA\dbmonitor_log.ldf' , SIZE = 1792KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO

ALTER DATABASE [DBA] SET COMPATIBILITY_LEVEL = 100
GO

IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [DBA].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO

ALTER DATABASE [DBA] SET ANSI_NULL_DEFAULT OFF 
GO

ALTER DATABASE [DBA] SET ANSI_NULLS OFF 
GO

ALTER DATABASE [DBA] SET ANSI_PADDING OFF 
GO

ALTER DATABASE [DBA] SET ANSI_WARNINGS OFF 
GO

ALTER DATABASE [DBA] SET ARITHABORT OFF 
GO

ALTER DATABASE [DBA] SET AUTO_CLOSE OFF 
GO

ALTER DATABASE [DBA] SET AUTO_CREATE_STATISTICS ON 
GO

ALTER DATABASE [DBA] SET AUTO_SHRINK OFF 
GO

ALTER DATABASE [DBA] SET AUTO_UPDATE_STATISTICS ON 
GO

ALTER DATABASE [DBA] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO

ALTER DATABASE [DBA] SET CURSOR_DEFAULT  GLOBAL 
GO

ALTER DATABASE [DBA] SET CONCAT_NULL_YIELDS_NULL OFF 
GO

ALTER DATABASE [DBA] SET NUMERIC_ROUNDABORT OFF 
GO

ALTER DATABASE [DBA] SET QUOTED_IDENTIFIER OFF 
GO

ALTER DATABASE [DBA] SET RECURSIVE_TRIGGERS OFF 
GO

ALTER DATABASE [DBA] SET  DISABLE_BROKER 
GO

ALTER DATABASE [DBA] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO

ALTER DATABASE [DBA] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO

ALTER DATABASE [DBA] SET TRUSTWORTHY OFF 
GO

ALTER DATABASE [DBA] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO

ALTER DATABASE [DBA] SET PARAMETERIZATION SIMPLE 
GO

ALTER DATABASE [DBA] SET READ_COMMITTED_SNAPSHOT OFF 
GO

ALTER DATABASE [DBA] SET HONOR_BROKER_PRIORITY OFF 
GO

ALTER DATABASE [DBA] SET  READ_WRITE 
GO

ALTER DATABASE [DBA] SET RECOVERY SIMPLE 
GO

ALTER DATABASE [DBA] SET  MULTI_USER 
GO

ALTER DATABASE [DBA] SET PAGE_VERIFY CHECKSUM  
GO

ALTER DATABASE [DBA] SET DB_CHAINING OFF 
GO






------ xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

USE [DBA]
GO
/****** Object:  User [GBR\SQLDBA_Backups]    Script Date: 02/14/2013 11:43:44 ******/
CREATE USER [GBR\SQLDBA_Backups] FOR LOGIN [GBR\SQLDBA_Backups] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [GBR\DBARemoteAccess]    Script Date: 02/14/2013 11:43:45 ******/
CREATE USER [GBR\DBARemoteAccess] FOR LOGIN [GBR\DBARemoteAccess]
GO
/****** Object:  Table [dbo].[T_DDL_Database_Level_Events]    Script Date: 02/14/2013 11:43:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[T_DDL_Database_Level_Events](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[EventTime] [datetime] NULL,
	[EventType] [varchar](max) NULL,
	[ServerName] [varchar](max) NULL,
	[LoginName] [varchar](max) NULL,
	[DatabaseName] [varchar](max) NULL,
	[SchemaName] [varchar](max) NULL,
	[ObjectType] [varchar](max) NULL,
	[ObjectName] [varchar](max) NULL,
	[CommandText] [varchar](max) NULL,
	[SPID] [varchar](max) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[T_DDL_Database_Level_Events] DISABLE CHANGE_TRACKING
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[T_Date]    Script Date: 02/14/2013 11:43:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_Date](
	[Date] [datetime] NULL,
	[day] [int] NULL,
	[Week] [int] NULL,
	[Month] [int] NULL,
	[Year] [int] NULL,
	[Quater] [int] NULL,
	[DayOfWeek] [int] NULL,
	[DayOfMonth] [int] NULL,
	[DayOfYear] [int] NULL,
	[ID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[T_Date] DISABLE CHANGE_TRACKING
GO
/****** Object:  Table [dbo].[T_Databases]    Script Date: 02/14/2013 11:43:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[T_Databases](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Dbname] [varchar](75) NULL,
	[ShrinkStatus] [int] NULL,
	[BackupStatus] [int] NULL,
	[Location] [varchar](250) NULL,
	[Cat] [varchar](2) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[T_Databases] DISABLE CHANGE_TRACKING
GO
SET ANSI_PADDING OFF
GO

/****** Object:  StoredProcedure [dbo].[USP_DatabaseSizes]    Script Date: 02/14/2013 11:43:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
cREATE  PROCEDURE [dbo].[USP_DatabaseSizes] as   
/* Purpose: Stored procedure to give at a glance information of database size,free space, file locations and file sizes */   
BEGIN  
DECLARE @DBInfo TABLE ( ServerName VARCHAR(100), DatabaseName VARCHAR(100), FileSizeMB INT, LogicalFileName sysname, 
PhysicalFileName NVARCHAR(520), Status sysname, Updateability sysname, RecoveryMode sysname, 
FreeSpaceMB INT, FreeSpacePct VARCHAR(7), 
FreeSpacePages INT, PollDate datetime)   
DECLARE @command VARCHAR(5000)   
SELECT @command = 'Use [' + '?' + '] SELECT @@servername as ServerName, ' + '''' + '?' + '''' + ' AS DatabaseName, CAST(sysfiles.size/128.0 AS int) AS FileSize, sysfiles.name AS LogicalFileName, sysfiles.filename AS PhysicalFileName, CONVERT(sysname,
DatabasePropertyEx(''?'',''Status'')) AS Status, CONVERT(sysname,DatabasePropertyEx(''?'',''Updateability'')) AS Updateability, CONVERT(sysname,DatabasePropertyEx(''?'',''Recovery'')) AS RecoveryMode, CAST(sysfiles.size/128.0 - CAST(FILEPROPERTY(sysfiles.name,
' + '''' + 'SpaceUsed' + '''' + ' ) AS int)/128.0 AS int) AS FreeSpaceMB, CAST(100 * (CAST (((sysfiles.size/128.0 -CAST(FILEPROPERTY(sysfiles.name, ' + '''' + 'SpaceUsed' + '''' + ' ) AS int)/128.0)/(sysfiles.size/128.0)) AS decimal(4,2))) AS varchar(8)) 
 
 + ' + '''' + '%' + '''' + ' AS FreeSpacePct, GETDATE() as PollDate FROM dbo.sysfiles'   
INSERT INTO @DBInfo (ServerName, DatabaseName, FileSizeMB, LogicalFileName, PhysicalFileName, 
Status, Updateability, RecoveryMode, FreeSpaceMB, FreeSpacePct, PollDate)  
EXEC sp_MSForEachDB @command 
SELECT ServerName, DatabaseName, LogicalFileName,
 PhysicalFileName, FileSizeMB, FreeSpaceMB, FreeSpacePct, Status,  
 RecoveryMode FROM @DBInfo ORDER BY  FreeSpaceMB desc ,FreeSpacePct,
 left(physicalfilename,1)   
END
GO

/****** Object:  StoredProcedure [dbo].[GetAllTableSizes]    Script Date: 02/14/2013 11:43:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_tables      
      
CREATE PROCEDURE [dbo].[GetAllTableSizes]      
AS      
/*      
    Obtains spaced used data for ALL user tables in the database      
*/      
DECLARE @TableName VARCHAR(100)    --For storing values in the cursor      
      
--Cursor to get the name of all user tables from the sysobjects listing      
DECLARE tableCursor CURSOR      
FOR       
select [name]      
from dbo.sysobjects       
where  OBJECTPROPERTY(id, N'IsUserTable') = 1      
FOR READ ONLY      
      
--A procedure level temp table to store the results      
CREATE TABLE #TempTable      
(      
    tableName varchar(100),      
    numberofRows varchar(100),      
    reservedSize varchar(50),      
    dataSize varchar(50),      
    indexSize varchar(50),      
    unusedSize varchar(50)      
)      
      
--Open the cursor      
OPEN tableCursor      
      
--Get the first table name from the cursor      
FETCH NEXT FROM tableCursor INTO @TableName      
      
--Loop until the cursor was not able to fetch      
WHILE (@@Fetch_Status >= 0)      
BEGIN      
    --Dump the results of the sp_spaceused query to the temp table      
    INSERT  #TempTable      
        EXEC sp_spaceused @TableName      
              
    --Get the next table name      
    FETCH NEXT FROM tableCursor INTO @TableName      
END      
      
--Get rid of the cursor      
CLOSE tableCursor      
DEALLOCATE tableCursor      
      
alter table #TempTable add createdDate  datetime      
      
select so.name, su.name name_schema, so.crdate createdDate      
into #temp2      
from sysobjects so join sysusers su on so.uid = su.uid      
where su.name <> 'sys' and  OBJECTPROPERTY(so.id, N'IsUserTable') = 1      
order by so.crdate      
      
-- select * from sysobjects      
      
update  A set a.createdDate = b.createdDate       
from #TempTable A , #temp2 b       
where a.tableName  COLLATE DATABASE_DEFAULT  = b.name COLLATE DATABASE_DEFAULT       
              
      
--Select all records so we can use the reults      
    
--insert into DBA.dbo.DBA_TableClean_Med_TableList ([Database] ,tableName,numberofRows,reservedSize,dataSize,indexSize,unusedSize,createdDate )    
select  db_name() as [Database] ,tableName,numberofRows,reservedSize,dataSize,indexSize,unusedSize,createdDate    
FROM #TempTable    
--SELECT db_name() as [Database] , *  into DBA.dbo.tabledatalist FROM #TempTable    
      
--  use DBA    
--  go    
      
-- CREATE TABLE DBA_Tabledatalist      
--(   [Database] varchar(500),      
--    tableName varchar(100),      
--    numberofRows varchar(100),      
--    reservedSize varchar(50),      
--    dataSize varchar(50),      
--    indexSize varchar(50),      
--    unusedSize varchar(50),     
--     createdDate  datetime ,    
--     Owner varchar(255)    
--)     
    
-- select * from DBA.dbo.DBA_Tabledatalist    
     
--Final cleanup!      
DROP TABLE #TempTable      
--DROP TABLE #temp2
GO


/****** Object:  StoredProcedure [dbo].[DBA_DB_Backup_COMP_DIFF_Retention]    Script Date: 02/14/2013 11:43:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[DBA_DB_Backup_COMP_DIFF_Retention] ( @Location varchar(max),@DBName varchar(max))      
As      
      
--Declare @Location varchar(100)  
--Declare @DBName varchar(100)   
  
--Set @Location ='\\192.168.0.49\backup\Databases\LEB-DB003\'      
  
--Set @DBName ='DBA'  
      
      
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
      
 Set @SQL ='EXEC xp_cmdshell ''del  '+ @Location +'Weekly\'+cast(@Week as varchar(2))+'\'+@DBName + replace(Convert(varchar(10),@Date,121) ,'-','')+'_COMP_DIFF.bak'''      
  
     
--select @SQL       
Exec (@SQL)      
      
set @StartDate =@StartDate +1      
      
End
GO
/****** Object:  StoredProcedure [dbo].[DBA_DB_Backup_IDERA_FULL_Retention]    Script Date: 02/14/2013 11:43:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[DBA_DB_Backup_IDERA_FULL_Retention] ( @Location varchar(max),@DBName varchar(max))      
As      
      
--Declare @Location varchar(100)  
--Declare @DBName varchar(100)   
--Set @Location ='\\192.168.0.49\backup\Databases\LEB-DB003\'      
--Set @DBName ='DBA'  
      
      
select top 6 * into #ToDelete from T_Date where Date< convert(varchar(20),GETDATE()-31,111)      
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
/****** Object:  StoredProcedure [dbo].[DBA_DB_Backup_IDERA_FULL]    Script Date: 02/14/2013 11:43:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[DBA_DB_Backup_IDERA_FULL]    
AS              
-- Declare Location and get location from the configuration table              
              
Declare @Location varchar(250),  @LocationDelete  varchar(250)      
Declare @strQuaryP varchar(250),@strFullBackup varchar(1000)      
            
              
Declare @IDENT INT, @sql varchar(1000), @DBNAME VARCHAR(200)                                
DECLARE @File varchar(512)                                  
              
SELECT @Location= location FROM DBA.dbo.t_databases (nolock)                            
Where backupstatus=1      
              
Set   @LocationDelete=@Location            
              
              
----If ( DATEPART (dd,getdate()))=1              
              
----Set @Location =@Location+cast(year(getdate()) as varchar)+'\Monthly\' + cast(datepart(MM,getdate()) as varchar(2))+'\'              
----Else              
----Set @Location =@Location+cast(year(getdate()) as varchar)+'\Weekly\'+ cast(datepart(wk,getdate()) as varchar(2))+'\'              
              
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
NAME  IN (SELECT Dbname FROM DBA.dbo.[T_Databases](NOLOCK) WHERE BackupStatus > 0 )  --('DNKView', 'NLDView', 'GBRView','CHEView','AUSView','ESPView')                                  
while @IDENT is not null                                  
Begin                                  
SELECT @DBNAME = NAME FROM SYS.DATABASES WHERE [database_id] = @IDENT                        
              
-- Delete old files              
--EXEC [DBA_DB_Backup_IDERA_FULL_Retention] @LocationDelete,@DBName              
               
--select @LocationDelete,@DBName            
                        
/*Change disk location here as required*/                                  
--Select @strFullBackup = 'SET QUOTED_IDENTIFIER OFF BACKUP DATABASE ' + @DBNAME + ' TO Disk="'+@Location +''+@DBNAME +''+Replace(Convert(char(10),Getdate(),121),'-','')+'.Bak'+'" WITH NOINIT,NOREWIND, NOUNLOAD,DESCRIPTION= N''Data_backup_'+Replace(Replace(Convert(char(13),Getdate(),121),'-',''),' ','_')+''',NAME=N''Data_backup_'+Replace(Replace(Convert(char(13),Getdate(),121),'-',''),' ','_') +''''                                       
Select @strFullBackup = 'SET QUOTED_IDENTIFIER OFF EXEC [master].[dbo].[xp_ss_backup] @database=''' + @DBNAME + ''',@filename= '''+@Location +''+@DBNAME +''+Replace(Convert(char(10),Getdate(),121),'-','')+'_IDERA_FULL.Bak'''+',@backuptype=''Full'' ,@desc= N''backup_'+Replace(Replace(Convert(char(13),Getdate(),121),'-',''),' ','_')+''''                                       
--Select @strFullBackup = 'SET QUOTED_IDENTIFIER OFF BACKUP DATABASE ['+ @DBNAME +'] TO Disk="'+@Location +''+@DBNAME +''+Replace(Convert(char(10),Getdate(),121),'-','')+'_FULL_COMP.Bak'+'" WITH NOINIT,NOREWIND, NOUNLOAD, COMPRESSION,DESCRIPTION= N''Data_backup_FULL_COMP_'+Replace(Replace(Convert(char(13),Getdate(),121),'-',''),' ','_')+''',NAME=N''Data_backup_'+Replace(Replace(Convert(char(13),Getdate(),121),'-',''),' ','_') +''''                                
--BACKUP DATABASE [DBA] TO  DISK = N'\\192.168.0.58\backup\DBA.bak' WITH NOFORMAT, NOINIT,  NAME = N'DBA-Full Database Backup', SKIP, NOREWIND, NOUNLOAD, COMPRESSION,  STATS = 10
--GO
        
select (@strFullBackup)                          
Exec  (@strFullBackup)                         
                           
                                 
SELECT @IDENT=min([database_id]) from SYS.DATABASES WHERE [database_id] > 0 and [database_id]>@IDENT AND NAME  IN (SELECT Dbname FROM DBA.dbo.[T_Databases](NOLOCK) WHERE BackupStatus>0)                                  
end                           
           
-- Delete history
GO
/****** Object:  StoredProcedure [dbo].[DBA_DB_Backup_IDERA_DIFF_Retention]    Script Date: 02/14/2013 11:43:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[DBA_DB_Backup_IDERA_DIFF_Retention] ( @Location varchar(max),@DBName varchar(max))      
As      
      
--Declare @Location varchar(100)  
--Declare @DBName varchar(100)   
--Set @Location ='\\192.168.0.49\backup\Databases\LEB-DB003\'      
--Set @DBName ='DBA'  
      
      
select top 6 * into #ToDelete from T_Date where Date< convert(varchar(20),GETDATE()-31,111)      
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
      
 Set @SQL ='EXEC xp_cmdshell ''del  '+ @Location +'Weekly\'+cast(@Week as varchar(2))+'\'+@DBName + replace(Convert(varchar(10),@Date,121) ,'-','')+'_IDERA_DIFF.bak'''      
  
     
--select @SQL       
Exec (@SQL)      
      
set @StartDate =@StartDate +1      
      
End
GO
/****** Object:  StoredProcedure [dbo].[DBA_DB_Backup_COMP_FULL_Retention]    Script Date: 02/14/2013 11:43:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[DBA_DB_Backup_COMP_FULL_Retention] ( @Location varchar(max),@DBName varchar(max))      
As      
      
--Declare @Location varchar(100)  
--Declare @DBName varchar(100)   
  
--Set @Location ='\\192.168.0.49\backup\Databases\LEB-DB003\'      
  
--Set @DBName ='DBA'  
      
      
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
/****** Object:  StoredProcedure [dbo].[DBA_DB_Backup_SQL_DIFF_Retention]    Script Date: 02/14/2013 11:43:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[DBA_DB_Backup_SQL_DIFF_Retention] ( @Location varchar(max),@DBName varchar(max))      
As      
      
--Declare @Location varchar(100)  
--Declare @DBName varchar(100)   
  
--Set @Location ='\\192.168.0.49\backup\Databases\LEB-DB003\'      
  
--Set @DBName ='DBA'  
      
      
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
      
 Set @SQL ='EXEC xp_cmdshell ''del  '+ @Location +'Weekly\'+cast(@Week as varchar(2))+'\'+@DBName + replace(Convert(varchar(10),@Date,121) ,'-','')+'_SQL_DIFF.bak'''      
  
     
--select @SQL       
Exec (@SQL)      
      
set @StartDate =@StartDate +1      
      
End
GO

/****** Object:  StoredProcedure [dbo].[DBA_DB_Backup_SQL_FULL_Retention]    Script Date: 02/14/2013 11:43:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[DBA_DB_Backup_SQL_FULL_Retention] ( @Location varchar(max),@DBName varchar(max))      
As      
      
--Declare @Location varchar(100)  
--Declare @DBName varchar(100)   
--Set @Location ='\\192.168.0.49\backup\Databases\LEB-DB003\'      
--Set @DBName ='DBA'  
      
      
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

/****** Object:  StoredProcedure [dbo].[DBA_SP_Index_Rebuild_Reorg]    Script Date: 02/14/2013 11:43:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[DBA_SP_Index_Rebuild_Reorg]       
@strDatabase Varchar (20),        
@strAction Varchar (20)        
As        
        
Declare @strTableName Varchar (100)        
Declare @strIndexName Varchar (100)        
Declare @strQuery Varchar (1000)        
 Declare curTablesIndexs Cursor For Select Table_Name,Index_Name from [DBA].[dbo].[DBA_Table_Frag_Info] where action_take=@strAction and databasename=@strDatabase        
 Open curTablesIndexs          
 Fetch Next From curTablesIndexs Into @strTableName,@strIndexName          
 While @@FETCH_STATUS = 0           
 Begin        
 Select @strQuery='ALTER INDEX '+@strIndexName+' ON '+@strTableName +' '+ @strAction        
 Exec (@strQuery)        
        
 Fetch Next From curTablesIndexs Into @strTableName,@strIndexName            
 End          
 Close curTablesIndexs          
 Deallocate curTablesIndexs         
        
/*---------------------------------------------------------------------------------------------------------------        
        
        
Exec DBA_SP_Index_Rebuild_Reorg 'CHEView','REBUILD'        
        
---------------------------------------------------------------------------------------------------------------*/
GO
/****** Object:  StoredProcedure [dbo].[DBA_SP_GetFragInfo]    Script Date: 02/14/2013 11:43:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[DBA_SP_GetFragInfo]      
@strDatabaseName Varchar (50)      
As      
SET nocount ON      
 Declare @strName Varchar (200)      
 Declare @intID int      
 Declare curTables Cursor For Select Name,ID from sys.sysobjects (nolock) where xtype='u' --and name like 'c%'      
 Open curTables      
 Fetch Next From curTables Into @strName,@intID      
 While @@FETCH_STATUS = 0       
 Begin      
       
 IF NOT not EXISTS (Select TOP 1 * From Sys.Sysindexes (Nolock) Where ID=@intID and name not like '_wa%')      
--  Begin      
--   Print 'No Index'      
--  End       
-- Else      
  Begin      
      
      
   Delete from [DBA].[dbo].[DBA_Table_Frag_Info] where Table_Name=@strName      
   INSERT INTO [DBA].[dbo].[DBA_Table_Frag_Info]      
        ([Databasename]      
        ,[Frag_Date]      
        ,[Table_Name]      
        ,[Index_ID]      
        ,[Index_Name]      
        ,[Avg_Frag_Percentage])      
      
   SELECT @strDatabaseName,Getdate(),@strName,a.index_id, name, avg_fragmentation_in_percent      
   FROM sys.dm_db_index_physical_stats (DB_ID(), OBJECT_ID(@strName),      
     NULL, NULL, NULL) AS a      
    JOIN sys.indexes AS b ON a.object_id = b.object_id AND a.index_id = b.index_id;      
      
      
   update [DBA].[dbo].[DBA_Table_Frag_Info] set Action_Take='REORGANIZE' where Avg_Frag_Percentage between 5 and 30 and Action_Take is null and databasename=@strDatabaseName     
   update [DBA].[dbo].[DBA_Table_Frag_Info] set Action_Take='REBUILD' where Avg_Frag_Percentage>30 and Action_Take is null and databasename=@strDatabaseName       
   update [DBA].[dbo].[DBA_Table_Frag_Info] set Action_Take='None' where Avg_Frag_Percentage<5 and Action_Take is null and databasename=@strDatabaseName       
   update [DBA].[dbo].[DBA_Table_Frag_Info] set Index_Type='CLUSTERED' where Index_Name like 'pk%' and index_Id=1 and Index_Type is null and databasename=@strDatabaseName       
   update [DBA].[dbo].[DBA_Table_Frag_Info] set Index_Type='NONCLUSTERED' where Index_Name not like 'pk%'  and index_Id<>1 and Index_Type is null and databasename=@strDatabaseName       
      
--   select * from [DBA].[dbo].[DBA_Table_Frag_Info]      
  End      
      
 Fetch Next From curTables Into @strName,@intID        
 End      
 Close curTables      
 Deallocate curTables   
  
SET nocount OFF      

/*----------------------------------------------------------------------------------------------------------      
      
      
Exec DBA_GetFragInfo   @strDatabaseName='AUSView'      
      
select * from [DBA].[dbo].[DBA_Table_Frag_Info]      
----------------------------------------------------------------------------------------------------------*/


waitfor delay '00:00:02' 

--------------------------------------   Sp to get fragmentation info


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DBA_SP_Index_Rebuild_Reorg]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[DBA_SP_Index_Rebuild_Reorg]
GO
/****** Object:  StoredProcedure [dbo].[P_DeleteLastWeekData]    Script Date: 02/14/2013 11:43:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[P_DeleteLastWeekData] ( @Location varchar(max),@DBName varchar(max))      
As      
      
--Declare @Location varchar(100)  
--Declare @DBName varchar(100)   
  
--Set @Location ='\\192.168.0.49\backup\Databases\LEB-DB003\'      
  
--Set @DBName ='DBA'  
      
      
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
      
 Set @SQL ='EXEC xp_cmdshell ''del  '+ @Location +'Weekly\'+cast(@Week as varchar(2))+'\'+@DBName + replace(Convert(varchar(10),@Date,121) ,'-','')+'.bak'''      
  
     
--select @SQL       
Exec (@SQL)      
      
set @StartDate =@StartDate +1      
      
End
GO
/****** Object:  StoredProcedure [dbo].[P_BackupDatabase_SQLSOFT_DIFF]    Script Date: 02/14/2013 11:43:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[P_BackupDatabase_SQLSOFT_DIFF]          
AS          
-- Declare Location and get location from the configuration table          
          
Declare @Location varchar(250),  @LocationDelete  varchar(250)           
Declare @strQuaryP varchar(250),@strFullBackup varchar(250)          
        
          
Declare @IDENT INT, @sql varchar(1000), @DBNAME VARCHAR(200)                            
DECLARE @File varchar(512)                              
          
SELECT @Location=location FROM DBA.dbo.t_databases (nolock)                        
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
NAME  IN (SELECT Dbname FROM DBA.dbo.[T_Databases](NOLOCK) WHERE BackupStatus=1) --('DNKView', 'NLDView', 'GBRView','CHEView','AUSView','ESPView')                              
while @IDENT is not null                              
Begin                              
SELECT @DBNAME = NAME FROM SYS.DATABASES WHERE [database_id] = @IDENT                    
  
  
-- Delete old files          
EXEC P_DeleteLastWeekData @LocationDelete,@DBName          
           
--select @LocationDelete,@DBName        
                    
/*Change disk location here as required*/                              
--Select @strFullBackup = 'SET QUOTED_IDENTIFIER OFF BACKUP DATABASE ' + @DBNAME + ' TO Disk="'+@Location +''+@DBNAME +''+Replace(Convert(char(10),Getdate(),121),'-','')+'.Bak'+'" WITH NOINIT,NOREWIND, NOUNLOAD,DESCRIPTION= N''Data_backup_'+Replace(Replace(Convert(char(13),Getdate(),121),'-',''),' ','_')+''',NAME=N''Data_backup_'+Replace(Replace(Convert(char(13),Getdate(),121),'-',''),' ','_') +''''                          
Select @strFullBackup = 'SET QUOTED_IDENTIFIER OFF EXEC [master].[dbo].[xp_ss_backup] @database=''' + @DBNAME + ''',@filename= '''+@Location +''+@DBNAME +''+Replace(Convert(char(10),Getdate(),121),'-','')+'_IDERA_DIFF.Bak'''+',@backuptype=''Differential'' ,@desc= N''backup_'+Replace(Replace(Convert(char(13),Getdate(),121),'-',''),' ','_')+''''                                       
                  
select (@strFullBackup)                      
Exec  (@strFullBackup)                     
                       
                             
SELECT @IDENT=min([database_id]) from SYS.DATABASES WHERE [database_id] > 0 and [database_id]>@IDENT AND NAME  IN (SELECT Dbname FROM DBA.dbo.[T_Databases](NOLOCK) WHERE BackupStatus=1)                              
end
GO
/****** Object:  StoredProcedure [dbo].[P_BackupDatabase_SQLSOFT]    Script Date: 02/14/2013 11:43:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[P_BackupDatabase_SQLSOFT]          
AS          
-- Declare Location and get location from the configuration table          
          
Declare @Location varchar(250),  @LocationDelete  varchar(250)           
Declare @strQuaryP varchar(250),@strFullBackup varchar(250)          
        
          
Declare @IDENT INT, @sql varchar(1000), @DBNAME VARCHAR(200)                            
DECLARE @File varchar(512)                              
          
SELECT @Location=location FROM DBA.dbo.t_databases (nolock)                        
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
NAME  IN (SELECT Dbname FROM DBA.dbo.[T_Databases](NOLOCK) WHERE BackupStatus=1) --('DNKView', 'NLDView', 'GBRView','CHEView','AUSView','ESPView')                              
while @IDENT is not null                              
Begin                              
SELECT @DBNAME = NAME FROM SYS.DATABASES WHERE [database_id] = @IDENT                    
          
-- Delete old files          
EXEC P_DeleteLastWeekData @LocationDelete,@DBName          
           
--select @LocationDelete,@DBName        
                    
/*Change disk location here as required*/                              
--Select @strFullBackup = 'SET QUOTED_IDENTIFIER OFF BACKUP DATABASE ' + @DBNAME + ' TO Disk="'+@Location +''+@DBNAME +''+Replace(Convert(char(10),Getdate(),121),'-','')+'.Bak'+'" WITH NOINIT,NOREWIND, NOUNLOAD,DESCRIPTION= N''Data_backup_'+Replace(Replace(Convert(char(13),Getdate(),121),'-',''),' ','_')+''',NAME=N''Data_backup_'+Replace(Replace(Convert(char(13),Getdate(),121),'-',''),' ','_') +''''                          
Select @strFullBackup = 'SET QUOTED_IDENTIFIER OFF EXEC [master].[dbo].[xp_ss_backup] @database=''' + @DBNAME + ''',@filename= '''+@Location +''+@DBNAME +''+Replace(Convert(char(10),Getdate(),121),'-','')+'_IDERA_FULL.Bak'''+',@backuptype=''Full'' ,@desc= N''backup_'+Replace(Replace(Convert(char(13),Getdate(),121),'-',''),' ','_')+''''                                       
                  
select (@strFullBackup)                      
Exec  (@strFullBackup)                     
                       
                             
SELECT @IDENT=min([database_id]) from SYS.DATABASES WHERE [database_id] > 0 and [database_id]>@IDENT AND NAME  IN (SELECT Dbname FROM DBA.dbo.[T_Databases](NOLOCK) WHERE BackupStatus=1)                              
end
GO
/****** Object:  StoredProcedure [dbo].[DBA_DB_Backup_SQL_FULL]    Script Date: 02/14/2013 11:43:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[DBA_DB_Backup_SQL_FULL]    
AS              
-- Declare Location and get location from the configuration table              
              
Declare @Location varchar(250),  @LocationDelete  varchar(250)      
Declare @strQuaryP varchar(250),@strFullBackup varchar(1000)      
            
              
Declare @IDENT INT, @sql varchar(1000), @DBNAME VARCHAR(200)                                
DECLARE @File varchar(512)                                  
              
SELECT @Location= location FROM DBA.dbo.t_databases (nolock)                            
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
NAME  IN (SELECT Dbname FROM DBA.dbo.[T_Databases](NOLOCK) WHERE BackupStatus = 1 )  --('DNKView', 'NLDView', 'GBRView','CHEView','AUSView','ESPView')                                  
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
--BACKUP DATABASE [DBA] TO  DISK = N'\\192.168.0.58\backup\DBA.bak' WITH NOFORMAT, NOINIT,  NAME = N'DBA-Full Database Backup', SKIP, NOREWIND, NOUNLOAD, COMPRESSION,  STATS = 10
--GO
        
select (@strFullBackup)                          
Exec  (@strFullBackup)                         
                           
                                 
SELECT @IDENT=min([database_id]) from SYS.DATABASES WHERE [database_id] > 0 and [database_id]>@IDENT AND NAME  IN (SELECT Dbname FROM DBA.dbo.[T_Databases](NOLOCK) WHERE BackupStatus=1)                                  
end                           
          
-- Delete history
GO
/****** Object:  StoredProcedure [dbo].[DBA_DB_Backup_SQL_DIFF]    Script Date: 02/14/2013 11:43:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[DBA_DB_Backup_SQL_DIFF]    
AS              
-- Declare Location and get location from the configuration table              
              
Declare @Location varchar(250),  @LocationDelete  varchar(250)      
Declare @strQuaryP varchar(250),@strFullBackup varchar(1000)      
            
              
Declare @IDENT INT, @sql varchar(1000), @DBNAME VARCHAR(200)                                
DECLARE @File varchar(512)                                  
              
SELECT @Location= location FROM DBA.dbo.t_databases (nolock)                            
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
NAME  IN (SELECT Dbname FROM DBA.dbo.[T_Databases](NOLOCK) WHERE BackupStatus = 1 and Dbname <> 'master')  --('DNKView', 'NLDView', 'GBRView','CHEView','AUSView','ESPView')                                  
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

--BACKUP DATABASE [DBA] TO  DISK = N'\\192.168.0.58\backup\DBA.bak' WITH NOFORMAT, NOINIT,  NAME = N'DBA-Full Database Backup', SKIP, NOREWIND, NOUNLOAD, COMPRESSION,  STATS = 10
--GO
        
select (@strFullBackup)                          
Exec  (@strFullBackup)                         
                           
                                 
SELECT @IDENT=min([database_id]) from SYS.DATABASES WHERE [database_id] > 0 and [database_id]>@IDENT AND NAME  IN (SELECT Dbname FROM DBA.dbo.[T_Databases](NOLOCK) WHERE BackupStatus  = 1 )                                  
end                           
             
-- Delete history
GO
/****** Object:  StoredProcedure [dbo].[DBA_DB_Backup_COMP_FULL]    Script Date: 02/14/2013 11:43:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[DBA_DB_Backup_COMP_FULL]    
AS              
-- Declare Location and get location from the configuration table              
              
Declare @Location varchar(250),  @LocationDelete  varchar(250)      
Declare @strQuaryP varchar(250), @strFullBackup varchar(1000)      
            
              
Declare @IDENT INT, @sql varchar(1000), @DBNAME VARCHAR(200)                                
DECLARE @File varchar(512)                                  
              
SELECT @Location= location FROM DBA.dbo.t_databases (nolock)                            
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
NAME  IN (SELECT Dbname FROM DBA.dbo.[T_Databases](NOLOCK) WHERE BackupStatus = 1 )  --('DNKView', 'NLDView', 'GBRView','CHEView','AUSView','ESPView')                                  
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

--BACKUP DATABASE [DBA] TO  DISK = N'\\192.168.0.58\backup\DBA.bak' WITH NOFORMAT, NOINIT,  NAME = N'DBA-Full Database Backup', SKIP, NOREWIND, NOUNLOAD, COMPRESSION,  STATS = 10
--GO
        
select (@strFullBackup)                          
Exec  (@strFullBackup)                         
                           
                                 
SELECT @IDENT=min([database_id]) from SYS.DATABASES WHERE [database_id] > 0 and [database_id]>@IDENT AND NAME  IN (SELECT Dbname FROM DBA.dbo.[T_Databases](NOLOCK) WHERE BackupStatus=1)                                  
end                           
               
-- Delete history
GO
/****** Object:  StoredProcedure [dbo].[DBA_DB_Backup_IDERA_DIFF]    Script Date: 02/14/2013 11:43:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[DBA_DB_Backup_IDERA_DIFF]    
AS              
-- Declare Location and get location from the configuration table              
              
Declare @Location varchar(250),  @LocationDelete  varchar(250)      
Declare @strQuaryP varchar(250),@strFullBackup varchar(1000)      
            
              
Declare @IDENT INT, @sql varchar(1000), @DBNAME VARCHAR(200)                                
DECLARE @File varchar(512)                                  
              
SELECT @Location= location FROM DBA.dbo.t_databases (nolock)                            
Where backupstatus=1      
              
Set   @LocationDelete=@Location            
              
              
--If ( DATEPART (dd,getdate()))=1              
              
--Set @Location =@Location+cast(year(getdate()) as varchar)+'\Monthly\' + cast(datepart(MM,getdate()) as varchar(2))+'\'              
--Else              
--Set @Location =@Location+cast(year(getdate()) as varchar)+'\Weekly\'+ cast(datepart(wk,getdate()) as varchar(2))+'\'              
              
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
NAME  IN (SELECT Dbname FROM DBA.dbo.[T_Databases](NOLOCK) WHERE BackupStatus = 1  AND Dbname <> 'MASTER')  
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
--BACKUP DATABASE [DBA] TO  DISK = N'\\192.168.0.58\backup\DBA.bak' WITH NOFORMAT, NOINIT,  NAME = N'DBA-Full Database Backup', SKIP, NOREWIND, NOUNLOAD, COMPRESSION,  STATS = 10
--GO
        
select (@strFullBackup)                          
Exec  (@strFullBackup)                         
                           
                                 
SELECT @IDENT=min([database_id]) from SYS.DATABASES WHERE [database_id] > 0 and [database_id]>@IDENT AND NAME  IN (SELECT Dbname FROM DBA.dbo.[T_Databases](NOLOCK) WHERE BackupStatus=1)                                  
end                           
             
-- Delete history
GO
/****** Object:  StoredProcedure [dbo].[DBA_DB_Backup_COMP_DIFF]    Script Date: 02/14/2013 11:43:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[DBA_DB_Backup_COMP_DIFF]    
AS              
-- Declare Location and get location from the configuration table              
              
Declare @Location varchar(250),  @LocationDelete  varchar(250)      
Declare @strQuaryP varchar(250),@strFullBackup varchar(1000)      
            
              
Declare @IDENT INT, @sql varchar(1000), @DBNAME VARCHAR(200)                                
DECLARE @File varchar(512)                                  
              
SELECT @Location= location FROM DBA.dbo.t_databases (nolock)                            
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
NAME  IN (SELECT Dbname FROM DBA.dbo.[T_Databases](NOLOCK) WHERE BackupStatus = 1 and Dbname <> 'master')  --('DNKView', 'NLDView', 'GBRView','CHEView','AUSView','ESPView')                                  
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

--BACKUP DATABASE [DBA] TO  DISK = N'\\192.168.0.58\backup\DBA.bak' WITH NOFORMAT, NOINIT,  NAME = N'DBA-Full Database Backup', SKIP, NOREWIND, NOUNLOAD, COMPRESSION,  STATS = 10
--GO
        
select (@strFullBackup)                          
Exec  (@strFullBackup)                         
                           
                                 
SELECT @IDENT=min([database_id]) from SYS.DATABASES WHERE [database_id] > 0 and [database_id]>@IDENT AND NAME  IN (SELECT Dbname FROM DBA.dbo.[T_Databases](NOLOCK) WHERE BackupStatus  = 1 )                                  
end                           
   
-- Delete history
GO
/****** Object:  Default [DF__T_Databas__Shrin__20C1E124]    Script Date: 02/14/2013 11:43:46 ******/
ALTER TABLE [dbo].[T_Databases] ADD  DEFAULT ((1)) FOR [ShrinkStatus]
GO
/****** Object:  Default [DF__T_Databas__Backu__21B6055D]    Script Date: 02/14/2013 11:43:46 ******/
ALTER TABLE [dbo].[T_Databases] ADD  DEFAULT ((1)) FOR [BackupStatus]
GO
/****** Object:  Default [DF_T_Databases_Location]    Script Date: 02/14/2013 11:43:46 ******/
ALTER TABLE [dbo].[T_Databases] ADD  CONSTRAINT [DF_T_Databases_Location]  DEFAULT ('\\LEB-NTTCIFS01\SQLBackups\Ascade Assure DB Backup\') FOR [Location]
GO
