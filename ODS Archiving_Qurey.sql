use DBMONITOR

select top 10 * from DBA_ODS_Archive_Control_Table where DatabaseName ='NLDVIEW' order by Archived_Date desc
select top 10 * from DBA_ODS_Archive_Master_Table
select top 10 * from DBA_ODS_Monthly_Archive_Control_Table
