----------------------------  LBR-AWSRADB02_RADEUTTD_DEU_WHOLESALE_AUG2015_20150618

use RADEUTTD
go


select MIN(COM_CallStartTime) , MAX(COM_CallStartTime) from [RADEUTTD].dbo.DEU_wholesale (nolock)
go
-- 2015-02-12 20:12:07.000	2015-04-23 09:03:11.000
 

---------- DEU_WHOLESALE


USE RADEUTTD
GO

SP_SPACEUSED DEU_WHOLESALE
GO
-- DEU_WHOLESALE	265735024           	315119528 KB	246151336 KB	68929040 KB	39152 KB


SELECT YEAR(  COM_CallStartTime) , MONTH(  COM_CallStartTime) , COUNT(*) FROM DEU_WHOLESALE 
GROUP BY YEAR(  COM_CallStartTime) , MONTH(  COM_CallStartTime)

 2015	4	161642457
2015	3	104092508
2015	2	59
------------------------------- CREATE INDEX



USE [master]
GO
ALTER DATABASE [RADEUTTD] ADD FILEGROUP [RADEUTTD_DEU_WHOLESALE_oddmonth_AUG]
GO
ALTER DATABASE [RADEUTTD] ADD FILE ( NAME = N'RADEUTTD_DEU_WHOLESALE_oddmonth_AUG', FILENAME = N'D:\MSSQL_DATA\RADEUTTD\RADEUTTD_DEU_WHOLESALE_oddmonth_AUG.ndf' , SIZE = 157286400KB , FILEGROWTH = 512000KB ) TO FILEGROUP [RADEUTTD_DEU_WHOLESALE_oddmonth_AUG]
GO
ALTER DATABASE [RADEUTTD] ADD FILEGROUP [RADEUTTD_DEU_WHOLESALE_oddmonth_AUG_INDX]
GO
ALTER DATABASE [RADEUTTD] ADD FILE ( NAME = N'RADEUTTD_DEU_WHOLESALE_oddmonth_AUG_INDX', FILENAME = N'E:\MSSQL_INDEX\RADEUTTD\RADEUTTD_DEU_WHOLESALE_oddmonth_AUG_INDX.ndf' , SIZE = 52428800KB , FILEGROWTH = 512000KB ) TO FILEGROUP [RADEUTTD_DEU_WHOLESALE_oddmonth_AUG_INDX]
GO


------------------------------------- CREATE TABLE

USE [RADEUTTD]
GO
 

CREATE TABLE [dbo].[DEU_WHOLESALE_AUG](
	[Tag] [varchar](20) NULL,
	[TypeOfRecord] [varchar](20) NULL,
	[ChargingOrgDate] [varchar](20) NULL,
	[ChargingOrgTime] [varchar](20) NULL,
	[ChargingEffStartDate] [varchar](20) NULL,
	[ChargingEffStartTime] [varchar](20) NULL,
	[TimeOffset] [varchar](20) NULL,
	[BasicServiceChoice] [varchar](20) NULL,
	[BasicServiceCode] [varchar](20) NULL,
	[SSInformation] [varchar](20) NULL,
	[OtherPartyTON] [varchar](20) NULL,
	[OtherPartyNumPlan] [varchar](20) NULL,
	[OtherPartyNumber] [varchar](32) NULL,
	[CalledNumber] [varchar](64) NULL,
	[NetworkPrefix] [varchar](20) NULL,
	[PRNPrefix] [varchar](20) NULL,
	[CriteriaBand] [varchar](20) NULL,
	[CriteriaNetworkType] [varchar](20) NULL,
	[CallDuration] [varchar](20) NULL,
	[OrgUnits] [varchar](20) NULL,
	[FreeUnitsUsed] [varchar](20) NULL,
	[FreeUnitsType] [varchar](20) NULL,
	[FreeUnitsProgram] [varchar](20) NULL,
	[CallTransType] [varchar](20) NULL,
	[MSISDN] [varchar](20) NULL,
	[IMEI] [varchar](20) NULL,
	[ICCID] [varchar](20) NULL,
	[MCCMNC] [varchar](20) NULL,
	[StandardAgreementID] [varchar](20) NULL,
	[AccountNumber] [varchar](20) NULL,
	[ServiceID] [varchar](20) NULL,
	[TNRatedValue] [varchar](20) NULL,
	[TNRoundedValue] [varchar](20) NULL,
	[TNMeasureCV] [varchar](20) NULL,
	[TNCharge] [varchar](20) NULL,
	[TNChargedItem] [varchar](20) NULL,
	[SPRatedValue] [varchar](20) NULL,
	[SPRoundedValue] [varchar](20) NULL,
	[SPMeasureCV] [varchar](20) NULL,
	[SPChrgBeforeAllowance] [varchar](20) NULL,
	[SPCharge] [varchar](20) NULL,
	[SPChargedItem] [varchar](50) NULL,
	[SPAllowanceItem] [varchar](50) NULL,
	[SMSC] [varchar](20) NULL,
	[OriginatingLocation] [varchar](20) NULL,
	[TariffFlag] [varchar](20) NULL,
	[BonusByStart] [varchar](20) NULL,
	[BonusByEnd] [varchar](20) NULL,
	[ActionCode] [varchar](20) NULL,
	[InitialDataVolume] [varchar](20) NULL,
	[BMDProcessingID] [varchar](20) NULL,
	[SplitIndex] [varchar](20) NULL,
	[CellID] [varchar](20) NULL,
	[GPRS_PassStage_Reserved1] [varchar](30) NULL,
	[GPRS_PassInstanceUsageTicketCounter_Reserved2] [varchar](30) NULL,
	[GPRS_PassInstanceValueinitial_Reserved3] [varchar](30) NULL,
	[GPRS_PassInstanceValueBefore_Reserved4] [varchar](30) NULL,
	[GPRS_PassInstanceValueAfter_Reserved5] [varchar](30) NULL,
	[GPRS_PassInstanceInstantiationDate_Reserved6] [varchar](30) NULL,
	[COM_Rec_Type] [int] NULL,
	[COM_Direction] [int] NULL,
	[COM_Roaming_Ind] [int] NULL,
	[COM_RECORDID] [varchar](100) NOT NULL,
	[COM_A_No] [varchar](64) NULL,
	[COM_A_Imsi] [varchar](64) NULL,
	[COM_B_No] [varchar](64) NULL,
	[COM_C_NO] [varchar](64) NULL,
	[COM_Duration] [int] NOT NULL DEFAULT ((0)),
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
	[COM_MNO_Charge] [int] NULL,
	[File_name] [varchar](100) NOT NULL,
	[COM_Dumping_time] [datetime] NOT NULL DEFAULT (getdate()),
	[COM_Rating_time] [datetime] NULL,
	[COM_Correlation_Time] [datetime] NULL,
	[COM_Iscorrelated] [int] NULL,
	[COM_Usage] [int] NOT NULL DEFAULT ((0)),
	[WS_RATEUNIT] [varchar](20) NULL,
	[WS_PRICEPKGDESC] [varchar](25) NULL,
	[WS_PRICEPKGID] [varchar](20) NULL,
	[WS_TIMEPREMIUM] [varchar](20) NULL,
	[WS_TOTALVOLUMEUNITS] [bigint] NOT NULL DEFAULT ((0)),
	[WS_ISTRANSFERRED] [tinyint] NOT NULL DEFAULT ((0)),
	[WS_ISREPROCESSED] [tinyint] NOT NULL DEFAULT ((0)),
	[WS_PUNITCOST] [decimal](20, 4) NOT NULL DEFAULT ((0)),
	[WS_CHARGEDUSAGE] [varchar](30) NOT NULL DEFAULT ((0)),
	[WS_DURATIONUNITS] [int] NOT NULL DEFAULT ((0)),
	[WS_TOTALCHARGE] [decimal](20, 4) NOT NULL DEFAULT ((0)),
	[WS_DPFLAG] [int] NOT NULL DEFAULT ((0)),
	[WS_SERVICEDESC] [varchar](50) NULL,
	[WS_TIMEBAND] [varchar](20) NULL,
	[WS_DAYCODE] [varchar](20) NULL,
	[WS_OPERATORNAME] [varchar](20) NULL,
	[GPRS_APN] [varchar](63) NULL,
	[GPRS_ServiceName] [varchar](30) NULL,
	[Reserved_3] [varchar](30) NULL,
	[Reserved_4] [varchar](30) NULL,
	[WS_RESERV5] [varchar](30) NULL,
	[Reserved_6] [varchar](30) NULL,
	[Reserved_7] [varchar](30) NULL,
	[Reserved_8] [varchar](30) NULL,
	[Reserved_9] [varchar](30) NULL,
	[Reserved_10] [varchar](30) NULL,
 CONSTRAINT [PK_DEU_WHOLESALE_AUG] PRIMARY KEY CLUSTERED 
(
	[File_name] ASC,
	[COM_RECORDID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [RADEUTTD_DEU_WHOLESALE_oddmonth_AUG]
) ON [RADEUTTD_DEU_WHOLESALE_oddmonth_AUG]

GO

 
 ---------- BLUKINSERT DEU_WHOLESALE

SP_SPACEUSED [DEU_WHOLESALE_AUG]
GO



 SELECT GETDATE()  -- 2015-07-24 11:04:15.343
 GO
 
USE [RADEUTTD]


GO

bulk insert [RADEUTTD].dbo.[DEU_WHOLESALE_AUG] from 'M:\ARCHIVE_FILES_FINAL\201507\RADEUTTD\DEU_WHOLESALE_AUG_DELTA_DELTA_20150819.txt' with (batchsize=10000,tablock,FIELDTERMINATOR='\t',KeepIdentity) 
GO  -- (154841894 row(s) affected)


 SELECT GETDATE()  -- 2015-06-19 00:41:30.287
 GO
 
  

USE [RADEUTTD]
/****** Object:  Index [DEU_WS_CALL_START_TMTSP_AUG]    Script Date: 02/19/2015 13:00:00 ******/
CREATE NONCLUSTERED INDEX [DEU_WS_CALL_START_TMTSP_AUG] ON [dbo].[DEU_WHOLESALE_AUG]
(
	[COM_CallStartTime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [RADEUTTD_DEU_WHOLESALE_oddmonth_AUG_INDX]
GO
 SELECT GETDATE()  -- 2015-06-19 01:21:09.050
 GO
/****** Object:  Index [DEU_WS_DUMPING_TMTSP_AUG]    Script Date: 4/23/2015 8:21:21 PM ******/
CREATE NONCLUSTERED INDEX [DEU_WS_DUMPING_TMTSP_AUG] ON [dbo].[DEU_WHOLESALE_AUG]
(
	[COM_Dumping_time] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [RADEUTTD_DEU_WHOLESALE_oddmonth_AUG_INDX]
GO
 SELECT GETDATE()  -- 2015-06-19 01:43:12.770
 GO
/****** Object:  Index [DEU_WS_WS_ISTRANS_AUG]    Script Date: 4/23/2015 8:21:21 PM ******/
CREATE NONCLUSTERED INDEX [DEU_WS_WS_ISTRANS_AUG] ON [dbo].[DEU_WHOLESALE_AUG]
(
	[WS_ISTRANSFERRED] ASC
)
WHERE ([WS_ISTRANSFERRED]=(0))
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [RADEUTTD_DEU_WHOLESALE_oddmonth_AUG_INDX]
GO



 
 SELECT GETDATE()  -- 2015-07-24 22:07:10.250
 GO
 
 
-----------------------

sp_rename 'DEU_WHOLESALE' , 'JUL2014_DEU_WHOLESALE'
go

sp_rename 'DEU_WHOLESALE_AUG' , 'DEU_WHOLESALE'
go

update statistics DEU_WHOLESALE
go
 
 

SP_SPACEUSED DEU_WHOLESALE -- (206191034 row(s) affected)
GO
--DEU_WHOLESALE	154841894           	161403728 KB	123336352 KB	38051624 KB	15752 KB


SELECT YEAR(  COM_CallStartTime) , MONTH(  COM_CallStartTime) , COUNT(*) FROM JUL2015_DEU_WHOLESALE (NOLOCK) 
GROUP BY YEAR(  COM_CallStartTime) , MONTH(  COM_CallStartTime)
GO


/*

2015	4	101500696
2015	3	64374146

*/


