
---------------------- LBR-AMSRADB02
------------------------------------RANLDTTD
 

--------------------------------- LBR-AWSRADB02_RANLDTTD_Archive_NLD_CORR_T_AUG2015_20150618
 
sp_spaceused NLD_CORR_T
go
-- NLD_CORR_T	75445126            	146778664 KB	136433064 KB	10327360 KB	18240 KB

sp_spaceused NLD_CORR_T
GO
--  NLD_CORR_T	75445126            	146778664 KB	136433064 KB	10327360 KB	18240 KB


select   YEAR( COM_CallStartTime) , MONTH ( COM_CallStartTime) , COUNT(*) from [RANLDTTD].dbo.NLD_CORR_T (nolock)
GROUP BY YEAR( COM_CallStartTime) , MONTH ( COM_CallStartTime)
go

2015	6	39973581
2015	7	35471545

 
----------------------- create filegroup

USE [master]
GO
ALTER DATABASE [RANLDTTD] ADD FILEGROUP [RANLDTTD_NLD_CORR_T_oddmonth_AUG]
GO
ALTER DATABASE [RANLDTTD] ADD FILE ( NAME = N'RANLDTTD_NLD_CORR_T_oddmonth_AUG', FILENAME = N'D:\MSSQL_DATA\RANLDTTD\RANLDTTD_NLD_CORR_T_oddmonth_AUG.ndf' , SIZE = 136314880KB , FILEGROWTH = 51200KB ) TO FILEGROUP [RANLDTTD_NLD_CORR_T_oddmonth_AUG]
GO

USE [master]
GO
ALTER DATABASE [RANLDTTD] ADD FILEGROUP [RANLDTTD_NLD_CORR_T_oddmonth_Indx_AUG]
GO
ALTER DATABASE [RANLDTTD] ADD FILE ( NAME = N'RANLDTTD_NLD_CORR_T_oddmonth_Indx_AUG', FILENAME = N'E:\MSSQL_INDEX\RANLDTTD\RANLDTTD_NLD_CORR_T_oddmonth_Indx_AUG.ndf' , SIZE = 10485760KB , FILEGROWTH = 51200KB ) TO FILEGROUP [RANLDTTD_NLD_CORR_T_oddmonth_Indx_AUG]
GO


-------------- CREATE TABLE

USE [RANLDTTD]
GO


CREATE TABLE [dbo].[NLD_CORR_T_AUG](
	[ReCORD_TYPE] [varchar](20) NULL,
	[SerVED_MOBILE_IDENTITY] [varchar](20) NULL,
	[CalLED_NUMBER] [varchar](30) NULL,
	[SerVICE_TYPE] [varchar](30) NULL,
	[SerVICE_IDENTIFICATION] [varchar](20) NULL,
	[Msc_IDENTIFICATION] [varchar](20) NULL,
	[LocaTION_AREA_IDENTIFICATION] [varchar](20) NULL,
	[MS_ClaSS_APRK] [varchar](20) NULL,
	[StaRT_CHARGING_DATE] [varchar](20) NULL,
	[StaRT_CHARGING_TIME] [varchar](20) NULL,
	[ChaRGEABLE_TIME] [varchar](20) NULL,
	[DatA_VOLUME] [varchar](20) NULL,
	[DatA_VOLUME_REFERENCE] [varchar](20) NULL,
	[End_CHARGE] [varchar](20) NULL,
	[Tax_CODE] [varchar](20) NULL,
	[ExcHANGE_RATE_CODE] [varchar](20) NULL,
	[CounTRY_TAP_CODE] [varchar](20) NULL,
	[OperATOR_TAP_CODE] [varchar](20) NULL,
	[StrEAM_NUMBER] [varchar](20) NULL,
	[TarIFF_SCHEME_NUMBERS] [varchar](20) NULL,
	[TraFFIC_AGREEMENT_NUMBER] [varchar](20) NULL,
	[NetWORK_SUBTYPE] [varchar](20) NULL,
	[SesSION_ID] [varchar](20) NULL,
	[ParTIAL_CODE] [varchar](20) NULL,
	[ParTIAL_RECORD_NR] [varchar](20) NULL,
	[SubTYPE_DEPENDENT] [varchar](20) NULL,
	[TerMINATING_OPERATOR_CODE] [varchar](20) NULL,
	[COM_Rec_Type] [int] NULL,
	[COM_Direction] [int] NULL,
	[COM_Roaming_Ind] [int] NULL,
	[COM_RECORDID] [varchar](100) NOT NULL,
	[COM_A_No] [varchar](64) NULL,
	[COM_A_Imsi] [varchar](64) NULL,
	[COM_B_No] [varchar](64) NULL,
	[COM_C_NO] [varchar](64) NULL,
	[COM_Duration] [int] NOT NULL,
	[COM_Uplink_Volume] [bigint] NULL,
	[COM_Downlink_Volume] [bigint] NULL,
	[COM_ServedIMSI_RoamingLoc] [varchar](20) NULL,
	[COM_OtherParty_RoamingLoc] [varchar](20) NULL,
	[COM_ThirdParty_RoamingLoc] [varchar](20) NULL,
	[COM_CallStartTime] [datetime] NULL,
	[COM_CallEndTime] [datetime] NULL,
	[COM_DialCodePattern] [varchar](20) NULL,
	[COM_ServiceID] [varchar](20) NULL,
	[COM_First_LAC] [varchar](30) NULL,
	[COM_First_Cell] [varchar](30) NULL,
	[COM_Last_LAC] [varchar](30) NULL,
	[COM_Last_Cell] [varchar](30) NULL,
	[COM_Rec_EntityTye] [varchar](30) NULL,
	[COM_Rec_EntityNo] [varchar](30) NULL,
	[COM_APN] [varchar](50) NULL,
	[COM_Prepaid_PostPaid] [int] NULL,
	[COM_MNO_Charge] [decimal](16, 4) NULL,
	[File_name] [varchar](100) NOT NULL,
	[COM_Dumping_time] [datetime] NOT NULL,
	[COM_Rating_time] [datetime] NULL,
	[COM_Correlation_Time] [datetime] NULL,
	[COM_Iscorrelated] [int] NULL,
	[COM_Usage] [bigint] NOT NULL,
	[WS_RATEUNIT] [varchar](20) NULL,
	[WS_PRICEPKGDESC] [varchar](25) NULL,
	[WS_PRICEPKGID] [varchar](20) NULL,
	[WS_TIMEPREMIUM] [varchar](20) NULL,
	[WS_TOTALVOLUMEUNITS] [bigint] NOT NULL,
	[WS_ISTRANSFERRED] [tinyint] NOT NULL,
	[WS_ISREPROCESSED] [tinyint] NOT NULL,
	[WS_PUNITCOST] [decimal](20, 4) NOT NULL,
	[WS_CHARGEDUSAGE] [varchar](30) NOT NULL,
	[WS_DURATIONUNITS] [int] NOT NULL,
	[WS_TOTALCHARGE] [decimal](20, 4) NOT NULL,
	[WS_DPFLAG] [int] NOT NULL,
	[WS_SERVICEDESC] [varchar](50) NULL,
	[WS_TIMEBAND] [varchar](20) NULL,
	[WS_DAYCODE] [varchar](20) NULL,
	[WS_OPERATORNAME] [varchar](20) NULL,
	[Reserved_1] [varchar](30) NULL,
	[Reserved_2] [varchar](30) NULL,
	[Reserved_3] [varchar](30) NULL,
	[Reserved_4] [varchar](30) NULL,
	[Reserved_5] [varchar](30) NULL,
	[Reserved_6] [varchar](30) NULL,
	[Reserved_7] [varchar](30) NULL,
	[Reserved_8] [varchar](30) NULL,
	[Reserved_9] [varchar](30) NULL,
	[Reserved_10] [varchar](30) NULL,
	[Rank_WS] [int] NULL,
	[RET_ChargeFromPrepaid] [decimal](20, 4) NULL,
	[RET_COM_Rec_Type] [int] NULL,
	[RET_COM_Direction] [int] NULL,
	[RET_COM_Roaming_Ind] [int] NULL,
	[RET_COM_RECORDID] [varchar](100) NOT NULL,
	[RET_COM_A_No] [varchar](64) NULL,
	[RET_COM_A_Imsi] [varchar](64) NULL,
	[RET_COM_B_No] [varchar](64) NULL,
	[RET_COM_C_NO] [varchar](64) NULL,
	[RET_COM_Duration] [int] NOT NULL,
	[RET_COM_Uplink_Volume] [bigint] NULL,
	[RET_COM_Downlink_Volume] [bigint] NULL,
	[RET_COM_ServedIMSI_RoamingLoc] [varchar](20) NULL,
	[RET_COM_OtherParty_RoamingLoc] [varchar](20) NULL,
	[RET_COM_ThirdParty_RoamingLoc] [varchar](20) NULL,
	[RET_COM_CallStartTime] [datetime] NULL,
	[RET_COM_CallEndTime] [datetime] NULL,
	[RET_COM_DialCodePattern] [varchar](20) NULL,
	[RET_COM_ServiceID] [varchar](20) NULL,
	[RET_COM_First_LAC] [varchar](30) NULL,
	[RET_COM_First_Cell] [varchar](30) NULL,
	[RET_COM_Last_LAC] [varchar](30) NULL,
	[RET_COM_Last_Cell] [varchar](30) NULL,
	[RET_COM_Rec_EntityTye] [varchar](30) NULL,
	[RET_COM_Rec_EntityNo] [varchar](30) NULL,
	[RET_COM_APN] [varchar](50) NULL,
	[RET_COM_Prepaid_PostPaid] [int] NULL,
	[RET_File_name] [varchar](100) NOT NULL,
	[RET_COM_Dumping_time] [datetime] NOT NULL,
	[RET_COM_Rating_time] [datetime] NULL,
	[RET_COM_correlation_time] [datetime] NULL,
	[RET_COM_Iscorrelated] [int] NULL,
	[RET_COM_Usage] [bigint] NOT NULL,
	[RET_WS_RATEUNIT] [varchar](20) NULL,
	[RET_WS_PRICEPKGDESC] [varchar](25) NULL,
	[RET_WS_PRICEPKGID] [varchar](20) NULL,
	[RET_WS_TIMEPREMIUM] [varchar](20) NULL,
	[RET_WS_TOTALVOLUMEUNITS] [bigint] NOT NULL,
	[RET_WS_ISTRANSFERRED] [tinyint] NOT NULL,
	[RET_WS_ISREPROCESSED] [tinyint] NOT NULL,
	[RET_WS_PUNITCOST] [decimal](20, 4) NOT NULL,
	[RET_WS_CHARGEDUSAGE] [varchar](30) NOT NULL,
	[RET_WS_DURATIONUNITS] [int] NOT NULL,
	[RET_WS_TOTALCHARGE] [decimal](20, 4) NOT NULL,
	[RET_WS_DPFLAG] [int] NOT NULL,
	[RET_WS_SERVICEDESC] [varchar](50) NULL,
	[RET_WS_TIMEBAND] [varchar](20) NULL,
	[RET_WS_DAYCODE] [varchar](20) NULL,
	[RET_WS_OPERATORNAME] [varchar](20) NULL,
	[HOTLINE_INDICATOR] [varchar](30) NULL,
	[OPPOSENUMBER_TYPE] [varchar](30) NULL,
	[RET_Reserved_3] [varchar](30) NULL,
	[CALL_TYPE] [varchar](30) NULL,
	[RET_Reserved_5] [varchar](30) NULL,
	[RET_Reserved_6] [varchar](30) NULL,
	[COUNTRY_NAME] [varchar](50) NULL,
	[DESTINATION_COUNTRY] [varchar](50) NULL,
	[DESTINATION_OPERATOR] [varchar](50) NULL,
	[DURATION_MIN] [varchar](50) NULL,
	[ACCOUNT_ID] [varchar](30) NULL,
	[CALLED_HOME_COUNTRY_CODE] [int] NULL,
	[CHARGE_DURATION] [int] NULL,
	[SERVICE_TYPE_RET] [varchar](30) NULL,
	[PRODUCT_ID] [varchar](30) NULL,
	[CATEGORY_ID] [varchar](50) NULL,
	[TELESERVICE_CODE] [varchar](50) NULL,
	[TRAFFIC_CASE] [varchar](50) NULL,
	[SEND_RESULT_SMS] [varchar](50) NULL,
	[RET_Reserved_15] [varchar](50) NULL,
	[RET_Reserved_16] [varchar](50) NULL,
	[RET_Reserved_17] [varchar](50) NULL,
	[RET_Reserved_18] [varchar](50) NULL,
	[RET_Reserved_19] [varchar](50) NULL,
	[RET_Reserved_20] [varchar](50) NULL,
	[Rank_RET] [int] NULL,
	[DUP_Rank_WS] [int] NULL,
	[DUP_Rank_RET] [int] NULL,
	[INSERT_TIMESTAMP] [datetime] NULL,
 CONSTRAINT [PK_NLD_CORR_AUG] PRIMARY KEY CLUSTERED 
(
	[File_name] ASC,
	[COM_RECORDID] ASC,
	[RET_File_name] ASC,
	[RET_COM_RECORDID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [RANLDTTD_NLD_CORR_T_oddmonth_AUG]
) ON [RANLDTTD_NLD_CORR_T_oddmonth_AUG]

GO

 

 -------------BULK INSERT

 
 SELECT GETDATE()  -- 2015-07-30 06:44:34.030
 GO
 
USE [RANLDTTD]
GO

bulk insert [RANLDTTD].dbo.[NLD_CORR_T_AUG] from 'D:\ARCHIVE_FILES_FINAL\201507\RANLDTTD\NLD_CORR_T_AUG_DELTA_20150819.txt' with (batchsize=10000,tablock,FIELDTERMINATOR='\t',KeepIdentity) 
GO  -- (22774758 row(s) affected)


 SELECT GETDATE()  -- 2015-06-19 06:44:46.040
 GO
 
sp_spaceused [NLD_CORR_T_AUG]

----------------------- create index

select GETDATE()  -- 2015-06-19 06:44:46.057
go

USE [RANLDTTD]
GO


CREATE NONCLUSTERED INDEX [NLD_CORR_CALL_START_TMTSP_AUG] ON [dbo].[NLD_CORR_T_AUG]
(
	[COM_CallStartTime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [RANLDTTD_NLD_CORR_T_oddmonth_Indx_AUG]
GO



--select GETDATE()   -- 2015-07-30 07:43:26.173
--go 



SP_RENAME [NLD_CORR_T] , [JUL2015_NLD_CORR_T]
GO

SP_RENAME [NLD_CORR_T_AUG] , [NLD_CORR_T]
GO


UPDATE STATISTICS [NLD_CORR_T]
GO


--SP_SPACEUSED [NLD_CORR_T]
--GO

select count(1) from [NLD_CORR_T]
go--22774758

-- NLD_CORR_T	5757770             	9600416 KB	8943408 KB	655832 KB	1176 KB
 
select   YEAR( COM_CallStartTime) , MONTH ( COM_CallStartTime) , COUNT(*) from [RANldTTD].dbo.[JUL2015_NLD_CORR_T] (nolock)
GROUP BY YEAR( COM_CallStartTime) , MONTH ( COM_CallStartTime)
go
 
2015	6	39973581
2015	7	35471545
 