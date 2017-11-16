

----------------------------  LBR-AWSRADB02_RADEUTTD_DEU_RETAIL_AUG2015_20150618
----------------------------
USE RADEUTTD
GO

select MIN(COM_CallStartTime) , MAX(COM_CallStartTime) from [RADEUTTD].dbo.DEU_RETAIL (nolock)
go
-- 2015-03-01 00:00:00.000	2015-04-23 11:06:33.000


---------- DEU_RETAIL 

USE RADEUTTD
GO

SP_SPACEUSED DEU_RETAIL
GO
										
--DEU_RETAIL	296548386           	325215304 KB	276595296 KB	48578744 KB	41264 KB


SELECT YEAR(  COM_CallStartTime) , MONTH(  COM_CallStartTime) , COUNT(*) FROM DEU_RETAIL (NOLOCK) 
GROUP BY YEAR(  COM_CallStartTime) , MONTH(  COM_CallStartTime)
 

 
------------------------------- CREATE INDEX



USE [master]
GO
ALTER DATABASE [RADEUTTD] ADD FILEGROUP [RADEUTTD_DEU_RETAIL_oddmonth_AUG]
GO
ALTER DATABASE [RADEUTTD] ADD FILE ( NAME = N'RADEUTTD_DEU_RETAIL_oddmonth_AUG', FILENAME = N'D:\MSSQL_DATA\RADEUTTD\RADEUTTD_DEU_RETAIL_oddmonth_AUG.ndf' , SIZE = 61668992KB , FILEGROWTH = 512000KB ) TO FILEGROUP [RADEUTTD_DEU_RETAIL_oddmonth_AUG]
GO
ALTER DATABASE [RADEUTTD] ADD FILEGROUP [RADEUTTD_DEU_RETAIL_oddmonth_AUG_INDX]
GO
ALTER DATABASE [RADEUTTD] ADD FILE ( NAME = N'RADEUTTD_DEU_RETAIL_oddmonth_AUG_INDX', FILENAME = N'E:\MSSQL_INDEX\RADEUTTD\RADEUTTD_DEU_RETAIL_oddmonth_AUG_INDX.ndf' , SIZE = 10268992KB , FILEGROWTH = 512000KB ) TO FILEGROUP [RADEUTTD_DEU_RETAIL_oddmonth_AUG_INDX]
GO


------------------------------------- CREATE TABLE

USE [RADEUTTD]
GO



CREATE TABLE [dbo].[DEU_RETAIL_AUG](
	[CallingPartyNumber] [varchar](64) NULL,
	[CalledPartyNumber] [varchar](64) NULL,
	[CallingRoamCountryCode] [varchar](30) NULL,
	[CalledRoamCountryCode] [varchar](30) NULL,
	[OnNetIndicator] [tinyint] NULL,
	[MMSLength] [int] NULL,
	[TotalFlux] [bigint] NULL,
	[ServiceFlow] [tinyint] NULL,
	[RoamState] [tinyint] NULL,
	[ChargingTime] [datetime] NULL,
	[SERIALNO] [bigint] NOT NULL,
	[ChargeOfFundAccounts] [decimal](20, 4) NULL,
	[ChargeFromPrepaid] [decimal](20, 4) NULL,
	[PrepaidBalance] [decimal](20, 4) NULL,
	[StartTimeOfBillCycle] [datetime] NULL,
	[BearerCapability] [varchar](32) NULL,
	[PostPaidBalance] [decimal](20, 4) NULL,
	[AccountType1] [int] NULL,
	[ChargeAmount1] [decimal](20, 4) NULL,
	[CurrentAcctAmount1] [decimal](20, 4) NULL,
	[AccountType2] [int] NULL,
	[ChargeAmount2] [decimal](20, 4) NULL,
	[CurrentAcctAmount2] [decimal](20, 4) NULL,
	[AccountType3] [int] NULL,
	[ChargeAmount3] [decimal](20, 4) NULL,
	[CurrentAcctAmount3] [varchar](30) NULL,
	[AccountType4] [int] NULL,
	[ChargeAmount4] [decimal](20, 4) NULL,
	[CurrentAcctAmount4] [varchar](30) NULL,
	[AccountType5] [int] NULL,
	[ChargeAmount5] [decimal](20, 4) NULL,
	[CurrentAcctAmount5] [varchar](30) NULL,
	[AccountType6] [int] NULL,
	[ChargeAmount6] [decimal](20, 4) NULL,
	[CurrentAcctAmount6] [varchar](30) NULL,
	[AccountType7] [int] NULL,
	[ChargeAmount7] [decimal](20, 4) NULL,
	[CurrentAcctAmount7] [varchar](30) NULL,
	[AccountType8] [int] NULL,
	[ChargeAmount8] [decimal](20, 4) NULL,
	[CurrentAcctAmount8] [varchar](30) NULL,
	[AccountType9] [int] NULL,
	[ChargeAmount9] [decimal](20, 4) NULL,
	[CurrentAcctAmount9] [varchar](30) NULL,
	[AccountType10] [int] NULL,
	[ChargeAmount10] [decimal](20, 4) NULL,
	[CurrentAcctAmount10] [varchar](30) NULL,
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
	[File_name] [varchar](100) NOT NULL,
	[COM_Dumping_time] [datetime] NOT NULL DEFAULT (getdate()),
	[COM_Rating_time] [datetime] NULL,
	[COM_correlation_time] [datetime] NULL,
	[COM_Iscorrelated] [int] NULL,
	[COM_Usage] [bigint] NULL DEFAULT ((0)),
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
	[RT_RATEUNIT] [varchar](20) NULL,
	[RT_PRICEPKGDESC] [varchar](25) NULL,
	[RT_PRICEPKGID] [varchar](20) NULL,
	[RT_TIMEPREMIUM] [varchar](20) NULL,
	[RT_TOTALVOLUMEUNITS] [bigint] NOT NULL DEFAULT ((0)),
	[RT_ISTRANSFERRED] [tinyint] NOT NULL DEFAULT ((0)),
	[RT_ISREPROCESSED] [tinyint] NOT NULL DEFAULT ((0)),
	[RT_PUNITCOST] [decimal](20, 4) NOT NULL DEFAULT ((0)),
	[RT_CHARGEDUSAGE] [varchar](30) NOT NULL DEFAULT ((0)),
	[RT_DURATIONUNITS] [bigint] NOT NULL DEFAULT ((0)),
	[RT_TOTALCHARGE] [decimal](20, 4) NOT NULL DEFAULT ((0)),
	[RT_DPFLAG] [int] NOT NULL DEFAULT ((0)),
	[RT_SERVICEDESC] [varchar](50) NULL,
	[RT_TIMEBAND] [varchar](20) NULL,
	[RT_DAYCODE] [varchar](20) NULL,
	[RT_OPERATORNAME] [varchar](20) NULL,
	[HOTLINE_INDICATOR] [varchar](30) NULL,
	[OPPOSENUMBER_TYPE] [varchar](30) NULL,
	[Reserved_3] [varchar](30) NULL,
	[CALL_TYPE] [varchar](30) NULL,
	[WS_RESERV5] [varchar](30) NULL,
	[Reserved_6] [varchar](30) NULL,
	[COUNTRY_NAME] [varchar](50) NULL,
	[DESTINATION_COUNTRY] [varchar](50) NULL,
	[DESTINATION_OPERATOR] [varchar](50) NULL,
	[DURATION_MIN] [varchar](50) NULL,
	[ACCOUNT_ID] [varchar](50) NULL,
	[CALLED_HOME_COUNTRY_CODE] [int] NULL,
	[CHARGE_DURATION] [int] NULL,
	[SERVICE_TYPE] [varchar](30) NULL,
	[PRODUCT_ID] [varchar](30) NULL,
	[CATEGORY_ID] [varchar](50) NULL,
	[TELESERVICE_CODE] [varchar](50) NULL,
	[TRAFFIC_CASE] [varchar](50) NULL,
	[SEND_RESULT_SMS] [varchar](50) NULL,
	[Reserved_15] [varchar](50) NULL,
	[Reserved_16] [varchar](50) NULL,
	[Reserved_17] [varchar](50) NULL,
	[Reserved_18] [varchar](50) NULL,
	[Reserved_19] [varchar](50) NULL,
	[Reserved_20] [varchar](50) NULL,
 CONSTRAINT [PK_DEU_RETAIL_AUG] PRIMARY KEY CLUSTERED 
(
	[File_name] ASC,
	[COM_RECORDID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [RADEUTTD_DEU_RETAIL_oddmonth_AUG]
) ON [RADEUTTD_DEU_RETAIL_oddmonth_AUG]

GO
 

sp_spaceused DEU_RETAIL_AUG
 

 --------- BLUKINSERT DEU_RETAIL


  SELECT GETDATE()  -- 2015-06-18 23:01:58.673
 GO

 USE [RADEUTTD]
GO

bulk insert [RADEUTTD].dbo.[DEU_RETAIL_AUG] from 'M:\ARCHIVE_FILES_FINA20L\201507\RADEUTTD\DEU_RETAIL_AUG_DELTA_DELTA_20150819.txt' with (batchsize=10000,tablock,FIELDTERMINATOR='\t',KeepIdentity) 
GO  --  (83917849 row(s) affected)

 SELECT GETDATE()  -- 2015-08-20 12:30:43.687
 GO
 
CREATE NONCLUSTERED INDEX [DEU_RET_CALL_START_TMTSP_ISCORR_AUG] ON [dbo].[DEU_RETAIL_AUG]
(
	[COM_CallStartTime] ASC,
	[COM_Iscorrelated] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [RADEUTTD_DEU_RETAIL_oddmonth_AUG_INDX]
GO

 --SELECT GETDATE()  -- 2015-06-19 00:38:07.273
 --GO
 
CREATE NONCLUSTERED INDEX [DEU_RET_DUMPING_TMTSP_AUG] ON [dbo].[DEU_RETAIL_AUG]
(
	[COM_Dumping_time] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [RADEUTTD_DEU_RETAIL_oddmonth_AUG_INDX]
GO

 --SELECT GETDATE()  -- 2015-06-19 00:56:09.940
 --GO
 
CREATE NONCLUSTERED INDEX [DEU_RET_WS_ISTRANS_AUG] ON [dbo].[DEU_RETAIL_AUG]
(
	[WS_ISTRANSFERRED] ASC
)
WHERE ([WS_ISTRANSFERRED]=(0))
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [RADEUTTD_DEU_RETAIL_oddmonth_AUG_INDX]
GO

 --SELECT GETDATE()  -- 2015-06-19 01:07:53.553
 --GO
 
-----------------------

sp_rename 'DEU_RETAIL' , 'JUL2015_DEU_RETAIL'
go

sp_rename 'DEU_RETAIL_AUG' , 'DEU_RETAIL'
go

update statistics DEU_RETAIL
go


SP_SPACEUSED DEU_RETAIL
GO
--DEU_RETAIL	101764506           	113670072 KB	98013096 KB	15644536 KB	12440 KB


SELECT YEAR(  COM_CallStartTime) , MONTH(  COM_CallStartTime) , COUNT(*) FROM JUL2015_DEU_RETAIL (NOLOCK) 
GROUP BY YEAR(  COM_CallStartTime) , MONTH(  COM_CallStartTime)
GO

/*

2015	4	101500696
2015	3	64374146

*/