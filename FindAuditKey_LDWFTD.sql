
Declare @stSource Varchar (20), @dtStart datetime

Set @stSource='LDW_STG_GBR'
Set @dtStart='2015-01-01'

  
  
     
            SELECT  
            row_number()over( order by convert(char(6),[Start_Time],112)) myrows_id,
                        convert(char(6),[Start_Time],112) [Partition_Month],
                              Min([Package_Execution_Key]) [Start_Key],
                              MAX([Package_Execution_Key]) [End_Key]
                              --,Max([Package_Execution_Key])- Min([Package_Execution_Key]) [Key Diff]
            FROM [LDW_AUDIT].[dbo].[Audit_Package_Execution]
            Where Source_Name=@stSource and Package_Name like 'Leb_Telco_STG_ODS%' 
             And Package_Name not in ('Leb_Telco_STG_ODS_LifeCycle_SNAPSHOT_REC_CDR','Leb_Telco_STG_ODS_Ethnicity_Count'
            ,'Leb_Telco_STG_ODS_TopUp_MGR_REC_CDR','Leb_Telco_STG_ODS_TopUp_MON_REC_CDR','Leb_Telco_STG_ODS_TopUp_VOU_REC_CDR') 
             And [Start_Time]>=@dtStart
            Group by convert(char(6),[Start_Time],112)