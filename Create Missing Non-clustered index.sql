/* Steps
Step1:
	Dont use the idx in primary. find a diffrant drive for the idx file to be placed.
	Check the Dependancies 

*/
 USE [Logging_Bundles]
 
 
-- check the dependancies  
--- Method 1
sp_MSdependencies N'CategoryLog'
--- Method 2
SELECT distinct so.name 
FROM syscomments sc 
INNER JOIN sysobjects so ON sc.id = so.id 
WHERE charindex('CategoryLog', text) > 0
 
--- Method 3 
 SELECT routine_name, routine_type FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_DEFINITION LIKE '%CategoryLog%'
 
 --- Method 4 This approach uses the system stored procedure sp_depends.
 EXEC sp_depends @objname = N'CategoryLog' ;
 
 
 sp_help [CategoryLog]
 
GO
CREATE NONCLUSTERED INDEX [IX_CategoryID_LogID]
ON [dbo].[CategoryLog] ([CategoryID],[LogID])
   
   
   