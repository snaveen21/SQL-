
---------------------- LBR-AMSRADB02
------------------------------------RADEUTTD
 

--------------------------------- LBR-AWSRADB02_RADEUTTD_Archive_DEU_CORR_T_AUG2015_20150618

sp_spaceused DEU_CORR_T
go
-- DEU_CORR_T	149461629  	189019896 KB	188995816 KB	376 KB	23704 KB

sp_spaceused DEU_CORR_T_AUG
GO
-- DEU_CORR_T_AUG	45372341   	59715976 KB	58356288 KB	1234856 KB	124832 KB

select   YEAR( COM_CallStartTime) , MONTH ( COM_CallStartTime) , COUNT(*) from [RADEUTTD].dbo.DEU_CORR_T (nolock)
GROUP BY YEAR( COM_CallStartTime) , MONTH ( COM_CallStartTime)
go
--2015	12	49842076

--2015	1	5256135
--2015	2	48991077
--2015	3	45372341





----------------------- create filegroup

USE [master]
GO
ALTER DATABASE [RADEUTTD] ADD FILEGROUP [RADEUTTD_DEU_CORR_T_oddmonth_AUG]
GO
ALTER DATABASE [RADEUTTD] ADD FILE ( NAME = N'RADEUTTD_DEU_CORR_T_oddmonth_AUG', FILENAME = N'D:\MSSQL_DATA\RADEUTTD\RADEUTTD_DEU_CORR_T_oddmonth_AUG.ndf' , SIZE = 62914560KB , FILEGROWTH = 51200KB ) TO FILEGROUP [RADEUTTD_DEU_CORR_T_oddmonth_AUG]
GO


USE [master]
GO
ALTER DATABASE [RADEUTTD] ADD FILEGROUP [RADEUTTD_DEU_CORR_T_oddmonth_Indx_AUG]
GO
ALTER DATABASE [RADEUTTD] ADD FILE ( NAME = N'RADEUTTD_DEU_CORR_T_oddmonth_Indx_AUG', FILENAME = N'E:\MSSQL_INDEX\RADEUTTD\RADEUTTD_DEU_CORR_T_oddmonth_Indx_AUG.ndf' , SIZE = 5242880KB , FILEGROWTH = 51200KB ) TO FILEGROUP [RADEUTTD_DEU_CORR_T_oddmonth_Indx_AUG]
GO


-------------- CREATE TABLE

USE [RADEUTTD]
GO

CREATE TABLE [dbo].[DEU_CORR_T_AUG](
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
	[COM_MNO_Charge] [int] NULL,
	[File_name] [varchar](100) NOT NULL,
	[COM_Dumping_time] [datetime] NOT NULL,
	[COM_Rating_time] [datetime] NULL,
	[COM_Correlation_Time] [datetime] NULL,
	[COM_Iscorrelated] [int] NULL,
	[COM_Usage] [bigint] NULL,
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
	[GPRS_Apn] [varchar](63) NULL,
	[GPRS_ServiceName] [varchar](30) NULL,
	[Reserved_3] [varchar](30) NULL,
	[Reserved_4] [varchar](30) NULL,
	[WS_RESERV5] [varchar](30) NULL,
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
	[RET_COM_Usage] [bigint] NULL,
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
	[Rank_RET] [int] NULL,
	[DUP_Rank_WS] [int] NULL,
	[DUP_Rank_RET] [int] NULL,
	[INSERT_TIMESTAMP] [datetime] NULL
) ON [RADEUTTD_DEU_CORR_T_oddmonth_AUG]

GO
 


 -------------BULK INSERT
 
  SELECT GETDATE()  -- 2015-07-24 11:24:23.623
 GO
 
USE [RADEUTTD]
GO

bulk insert [RADEUTTD].dbo.[DEU_CORR_T_AUG] from 'M:\ARCHIVE_FILES_FINAL\201507\RADEUTTD\DEU_CORR_T_AUG_DELTA_DELTA_20150819.txt' with (batchsize=1000000,tablock,FIELDTERMINATOR='\t',KeepIdentity) 
GO  -- (30534489 row(s) affected)


 SELECT GETDATE()  -- 2015-07-24 11:54:50.830
 GO
 

sp_spaceused [DEU_CORR_T_AUG]
----------------------- create index

select GETDATE()  -- 2015-08-20 12:35:42.820
go

USE [RADEUTTD]
GO

CREATE NONCLUSTERED INDEX [DEU_CORR_CALL_START_TMTSP_AUG] ON [dbo].[DEU_CORR_T_AUG]
(
	[COM_CallStartTime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [RADEUTTD_DEU_CORR_T_oddmonth_Indx_AUG]
GO
 

--select GETDATE()   -- 2015-07-24 12:02:55.503
--go 

  update statistics [DEU_CORR_T_AUG]
  go
  


SP_RENAME [DEU_CORR_T] , [JUL2015_DEU_CORR_T]
GO

SP_RENAME [DEU_CORR_T_AUG] , [DEU_CORR_T]
GO


UPDATE STATISTICS [DEU_CORR_T]
GO


SP_SPACEUSED [DEU_CORR_T] -- (25062652 row(s) affected)
GO
-- DEU_CORR_T	25062652            	33518480 KB	32744824 KB	682128 KB	91528 KB

select   YEAR( COM_CallStartTime) , MONTH ( COM_CallStartTime) , COUNT(*) from [RADEUTTD].dbo.[JUL2015_DEU_CORR_T] (nolock)
GROUP BY YEAR( COM_CallStartTime) , MONTH ( COM_CallStartTime)
go

2015	4	43820000
2015	5	43880000
2015	6	74307514
2015	7	25062652
