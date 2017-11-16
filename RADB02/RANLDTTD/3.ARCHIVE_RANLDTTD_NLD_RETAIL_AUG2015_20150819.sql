----------------------------  LBR-AWSRADB02_RANLDTTD_NLD_RETAIL_AUG_AUG2015_20150618
----------------------------
 
USE RANLDTTD
GO

select MIN(COM_CallStartTime) , MAX(COM_CallStartTime) from [RANLDTTD].dbo.NLD_RETAIL (nolock)
go
-- 2015-05-16 02:28:48.000	2015-07-29 09:09:22.000

---------- NLD_RETAIL 

USE RANLDTTD
GO

SP_SPACEUSED NLD_RETAIL
GO

--NLD_RETAIL	166034900           	199188352 KB	154067744 KB	45072224 KB	48384 KB


SELECT YEAR(  COM_CallStartTime) , MONTH(  COM_CallStartTime) , COUNT(*) FROM NLD_RETAIL (NOLOCK) 
GROUP BY YEAR(  COM_CallStartTime) , MONTH(  COM_CallStartTime)
 
 /*
2015	5	54144
2015	6	88515596
2015	7	77465160

*/
 
------------------------------- CREATE INDEX



USE [master]
GO
ALTER DATABASE [RANLDTTD] ADD FILEGROUP [RANLDTTD_NLD_RETAIL_oddmonth_AUG]
GO
ALTER DATABASE [RANLDTTD] ADD FILE ( NAME = N'RANLDTTD_NLD_RETAIL_oddmonth_AUG', FILENAME = N'D:\MSSQL_DATA\RANLDTTD\RANLDTTD_NLD_RETAIL_oddmonth_AUG.ndf' , SIZE = 157286400KB , FILEGROWTH = 512000KB ) TO FILEGROUP [RANLDTTD_NLD_RETAIL_oddmonth_AUG]
GO
ALTER DATABASE [RANLDTTD] ADD FILEGROUP [RANLDTTD_NLD_RETAIL_oddmonth_AUG_INDX]
GO
ALTER DATABASE [RANLDTTD] ADD FILE ( NAME = N'RANLDTTD_NLD_RETAIL_oddmonth_AUG_INDX', FILENAME = N'E:\MSSQL_INDEX\RANLDTTD\RANLDTTD_NLD_RETAIL_oddmonth_AUG_INDX.ndf' , SIZE = 41943040KB , FILEGROWTH = 512000KB ) TO FILEGROUP [RANLDTTD_NLD_RETAIL_oddmonth_AUG_INDX]
GO


------------------------------------- CREATE TABLE
USE [RANLDTTD]
GO

-- drop table 
 
CREATE TABLE [dbo].[NLD_RETAIL_AUG](
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
	[COM_Iscorrelated] [int] NULL DEFAULT ((0)),
	[COM_Usage] [bigint] NOT NULL DEFAULT ((0)),
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
	[ACCOUNT_ID] [varchar](30) NULL,
	[CALLED_HOME_COUNTRY_CODE] [int] NULL,
	[CHARGE_DURATION] [int] NULL,
	[SERVICE_TYPE_RET] [varchar](30) NULL,
	[PRODUCT_ID] [varchar](30) NULL,
	[CATEGORY_ID] [varchar](50) NULL,
	[TELESERVICE_CODE] [varchar](50) NULL,
	[TRAFFIC_CASE] [varchar](50) NULL,
	[SEND_RESULT_SMS] [varchar](50) NULL,
	[RReserved_15] [varchar](50) NULL,
	[Reserved_16] [varchar](50) NULL,
	[RReserved_17] [varchar](50) NULL,
	[Reserved_18] [varchar](50) NULL,
	[Reserved_19] [varchar](50) NULL,
	[Reserved_20] [varchar](50) NULL,
 CONSTRAINT [PK_NLD_RETAIL_T_AUG] PRIMARY KEY CLUSTERED 
(
	[File_name] ASC,
	[COM_RECORDID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [RANLDTTD_NLD_RETAIL_oddmonth_AUG]
) ON [RANLDTTD_NLD_RETAIL_oddmonth_AUG]

GO





 

 --------- BLUKINSERT NLD_RETAIL


  SELECT GETDATE()  -- 2015-07-30 06:43:03.343
 GO

 USE [RANLDTTD]
GO

bulk insert [RANLDTTD].dbo.[NLD_RETAIL_AUG] from 'D:\ARCHIVE_FILES_FINAL\201507\RANLDTTD\NLD_RETAIL_AUG_DELTA_20150819.txt' with (batchsize=10000,tablock,FIELDTERMINATOR='\t',KeepIdentity) 
GO  --  (83917849 row(s) affected)

 SELECT GETDATE()  -- 2015-04-24 05:59:13.620
 GO


 ---------------- 

 

CREATE NONCLUSTERED INDEX [NLD_RET_CALL_START_TMTSP_AUG] ON [dbo].[NLD_RETAIL_AUG]
(
	[COM_CallStartTime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [RANLDTTD_NLD_RETAIL_oddmonth_AUG_INDX]
GO

CREATE NONCLUSTERED INDEX [NLD_RET_DUMPING_TMTSP_AUG] ON [dbo].[NLD_RETAIL_AUG]
(
	[COM_Dumping_time] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [RANLDTTD_NLD_RETAIL_oddmonth_AUG_INDX]
GO

 CREATE NONCLUSTERED INDEX [NLD_RET_WS_ISTRANS_AUG] ON [dbo].[NLD_RETAIL_AUG]
(
	[WS_ISTRANSFERRED] ASC
)
INCLUDE ( 	[COM_ServiceID],
	[COM_A_No],
	[COM_B_No],
	[COM_C_NO],
	[COM_Rec_Type],
	[COM_Direction],
	[COM_Usage],
	[COM_CallStartTime],
	[COM_CallEndTime]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [RANLDTTD_NLD_RETAIL_oddmonth_AUG_INDX]
GO

--SELECT GETDATE()  -- 2015-07-30 11:49:20.697
--GO
 
-----------------------


--------/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
--------BEGIN TRANSACTION
--------SET QUOTED_IDENTIFIER ON
--------SET ARITHABORT ON
--------SET NUMERIC_ROUNDABORT OFF
--------SET CONCAT_NULL_YIELDS_NULL ON
--------SET ANSI_NULLS ON
--------SET ANSI_PADDING ON
--------SET ANSI_WARNINGS ON
--------COMMIT
--------BEGIN TRANSACTION
--------GO
--------ALTER TABLE dbo.NLD_RETAIL_AUG ADD
--------	ACCOUNT_ID varchar(30) NULL,
--------	CALLED_HOME_COUNTRY_CODE int NULL,
--------	CHARGE_DURATION int NULL,
--------	SERVICE_TYPE_RET varchar(30) NULL,
--------	PRODUCT_ID varchar(30) NULL,
--------	CATEGORY_ID varchar(50) NULL,
--------	TELESERVICE_CODE varchar(50) NULL,
--------	TRAFFIC_CASE varchar(50) NULL,
--------	Reserved_14 varchar(50) NULL,
--------	RReserved_15 varchar(50) NULL,
--------	Reserved_16 varchar(50) NULL,
--------	RReserved_17 varchar(50) NULL,
--------	Reserved_18 varchar(50) NULL,
--------	Reserved_19 varchar(50) NULL,
--------	Reserved_20 varchar(50) NULL
--------GO
--------ALTER TABLE dbo.NLD_RETAIL_AUG SET (LOCK_ESCALATION = TABLE)
--------GO
--------COMMIT


------------------------------------------ 


sp_rename 'NLD_RETAIL' , 'AUG2015_NLD_RETAIL'
go

sp_rename 'NLD_RETAIL_AUG' , 'NLD_RETAIL'
go

update statistics NLD_RETAIL
go


SP_SPACEUSED NLD_RETAIL
GO

-- NLD_RETAIL_AUG	51372047            	58737480 KB	43949824 KB	14781904 KB	5752 KB

SELECT YEAR(  COM_CallStartTime) , MONTH(  COM_CallStartTime) , COUNT(*) FROM AUG2015_NLD_RETAIL (NOLOCK) 
GROUP BY YEAR(  COM_CallStartTime) , MONTH(  COM_CallStartTime)
GO
 

/*

2015	5	54144
2015	6	88515596
2015	7	77465160
*/