
------------------------------ LEB-ODSMSSQL1
-------------------------------------------------- GBRVIEW

----------ARCHIVING_ODS_DATA_FIX_TEMPLATE


USE gbrview
GO

----------------------------- CDR_0_NEW

sp_spaceused CDR_0_NEW
GO
-- cdr_0_new	384911896  	336758320 KB	212236984 KB	123535072 KB	986264 KB

SELECT MIN(CHARGING_TIMESTAMP) ,  MAX(CHARGING_TIMESTAMP)  FROM CDR_0_NEW (NOLOCK)
GO
-- 2013-07-27 00:01:07.000	2015-06-05 10:13:38.000

SELECT CONVERT(VARCHAR(7), CHARGING_TIMESTAMP, 121) MM ,  COUNT(*) CNT  FROM CDR_0_NEW (NOLOCK)
GROUP BY CONVERT(VARCHAR(7), CHARGING_TIMESTAMP, 121)
GO

2015-03	94499450
2015-05	98792190
2013-07	345
2015-04	93343922
2013-10	2
2014-01	21
2013-08	160092
2015-06	14581669
2015-02	83602724
-------------------------------- ARCHIVE

sp_spaceused CDR_0_Archive
GO
-- Cdr_0_Archive	177731252  	162394112 KB	93079040 KB	69151072 KB	164000 KB

SELECT MIN(CHARGING_TIMESTAMP) ,  MAX(CHARGING_TIMESTAMP)  FROM CDR_0_ARCHIVE (NOLOCK)
GO
-- 2014-12-01 00:00:00.000	2015-01-31 23:59:59.000

SELECT CONVERT(VARCHAR(7), CHARGING_TIMESTAMP, 121) MM ,  COUNT(*) CNT  FROM CDR_0_ARCHIVE (NOLOCK)
GROUP BY CONVERT(VARCHAR(7), CHARGING_TIMESTAMP, 121)
GO

2015-01	86089579
2014-12	91641673

------------------- CHECK ON ARCHIVE DATABASE 

SELECT CONVERT(VARCHAR(7), CHARGING_TIMESTAMP, 121) MM ,  COUNT(*) CNT  FROM  GBRVIEW_archive.dbo.[CDR2014]  (NOLOCK)
GROUP BY CONVERT(VARCHAR(7), CHARGING_TIMESTAMP, 121)
GO



2014-01	86248445
2014-02	84410713
2014-03	96287082
2014-04	92786368
2014-05	143170000
2014-06	98433052
2014-07	95026609
2014-08	93554922
2014-09	95943355
2014-10	97854727
2014-11	91035146


 ----------------------- FIND THE PARTITION FOR THE REMOVABLE FILEGROUP
 
------------------- CREATE TABLE 

USE [GBRVIEW_ARCHIVE]
GO


CREATE TABLE [dbo].[CDR2013_STAGING](
	[CDR_Specific_ID] [bigint] NOT NULL,
	[CDR_Type] [int] NULL,
	[CDR_ID] [varchar](15) NULL,
	[Network_Call_Reference] [varchar](30) NULL,
	[A_Number] [varchar](21) NULL,
	[B_Number] [varchar](21) NULL,
	[Dialled_Digits] [varchar](21) NULL,
	[Location] [varchar](5) NULL,
	[Call_Forwarding_Flag] [int] NULL,
	[SMSC_Address] [varchar](25) NULL,
	[Charging_TimeStamp] [datetime] NOT NULL,
	[Duration] [int] NULL,
	[Call_Charge] [numeric](20, 6) NULL,
	[Fragment_Number] [int] NULL,
	[Last_Fragment_Indicator] [int] NULL,
	[Record_Sequence_Number] [varchar](50) NULL,
	[Provider_ID] [varchar](5) NULL,
	[Service_Type] [varchar](10) NULL,
	[Service_Class] [varchar](20) NULL,
	[Message_Type] [varchar](11) NULL,
	[provider_charge] [varchar](50) NULL,
	[Premium_SMS_Delivery_Flag] [int] NULL,
	[APN_Name] [varchar](63) NULL,
	[Volume] [int] NULL,
	[Completion_Status] [int] NULL,
	[MMS_email] [varchar](30) NULL,
	[MMS_Action] [char](10) NULL,
	[MMS_Client_Type] [varchar](13) NULL,
	[Special_Call_Type_Flag] [int] NULL,
	[Protocol_Type] [varchar](10) NULL,
	[Prepaid_Indicator] [int] NULL,
	[USSD_Indicator] [int] NULL,
	[Sub_Rate_Class_ID] [int] NULL,
	[File_ID] [int] NULL,
	[Rate_Class] [varchar](6) NULL,
	[IMEI] [varchar](15) NULL,
	[Zone_ID] [int] NULL,
	[Customer_Price] [numeric](11, 6) NULL,
	[Transfer_Price] [numeric](11, 6) NULL,
	[Billed_Duration] [int] NULL,
	[Wholesale_Cost] [numeric](11, 6) NULL,
	[Fixed_Cost] [numeric](11, 6) NULL,
	[Net_Revenue] [numeric](11, 6) NULL,
	[Flag] [int] NULL,
	[Carrier_cost] [numeric](11, 6) NULL,
	[MSISDN_ID] [bigint] NULL,
	[customer_id] [bigint] NULL,
	[Roaming_zone] [varchar](10) NULL,
	[Roaming_zone_ID] [int] NULL,
	[SerialNumber] [bigint] NULL,
	[SubSequenceNumber] [int] NULL,
	[network_used] [varchar](5) NULL,
	[charging_case] [varchar](4) NULL,
	[Roam_State] [smallint] NULL,
	[qualifying_seconds] [int] NULL,
	[Inserted_Date] [datetime] NULL,
	[Run_ID] [bigint] NULL,
	[AccountType1] [int] NULL,
	[ChargedAllowance1] [float] NULL,
	[BalanceAfter1] [float] NULL,
	[AccountType2] [int] NULL,
	[ChargedAllowance2] [float] NULL,
	[BalanceAfter2] [float] NULL,
	[AccountType3] [int] NULL,
	[ChargedAllowance3] [float] NULL,
	[BalanceAfter3] [float] NULL,
	[AccountType4] [int] NULL,
	[ChargedAllowance4] [float] NULL,
	[BalanceAfter4] [float] NULL,
	[AccountType5] [int] NULL,
	[ChargedAllowance5] [float] NULL,
	[BalanceAfter5] [float] NULL,
	[AccountType6] [int] NULL,
	[ChargedAllowance6] [float] NULL,
	[BalanceAfter6] [float] NULL,
	[AccountType7] [int] NULL,
	[ChargedAllowance7] [float] NULL,
	[BalanceAfter7] [float] NULL,
	[AccountType8] [int] NULL,
	[ChargedAllowance8] [float] NULL,
	[BalanceAfter8] [float] NULL,
	[AccountType9] [int] NULL,
	[ChargedAllowance9] [float] NULL,
	[BalanceAfter9] [float] NULL,
	[AccountType10] [int] NULL,
	[ChargedAllowance10] [float] NULL,
	[BalanceAfter10] [float] NULL,
	[Sub_Cos_ID] [int] NULL,
	[Calling_Roam_Country] [int] NULL,
	[Called_Roam_Country] [int] NULL,
	[Product_ID] [varchar](20) NULL,
	[IMSI] [varchar](64) NULL,
	[Redirecting_Number] [varchar](20) NULL,
	[Originating_Location_Information] [varchar](20) NULL,
	[Terminating_Location_Information] [varchar](20) NULL,
	[Charged_Party_Single] [int] NULL,
	[Balance_After] [decimal](20, 4) NULL,
	[Hot_Line_Indicator] [int] NULL,
	[Termination_Reason] [int] NULL,
	[Calling_Cell_ID] [varchar](20) NULL,
	[Direction_Indicator] [varchar](20) NULL,
	[On_Net_Indicator] [tinyint] NULL,
	[Called_Home_Area_number] [int] NULL,
	[TTD_Call_Type] [int] NULL,
	[Service_flow] [int] NULL,
	[Calling_Home_Country_Code] [int] NULL,
	[Called_Home_Country_Code] [int] NULL
) ON [CDR2013_11]

GO

-------------------------archive

USE [GBRVIEW_ARCHIVE]
GO


CREATE TABLE [dbo].[CDR2014_staging](
	[CDR_Specific_ID] [bigint] NOT NULL,
	[MSISDN] [varchar](25) NULL,
	[charging_timestamp] [datetime] NOT NULL,
	[B_number] [varchar](25) NULL,
	[local_answer_call] [datetime] NULL,
	[duration] [int] NULL,
	[enduser_charge] [float] NULL,
	[qualifying_seconds] [int] NULL,
	[call_type] [varchar](2) NULL,
	[network_type] [int] NULL,
	[subscription_level] [varchar](3) NULL,
	[traffic_class] [varchar](4) NULL,
	[ISP_account] [varchar](8) NULL,
	[service_level] [varchar](5) NULL,
	[network_used] [varchar](5) NULL,
	[cost] [float] NULL,
	[allowance_value] [varchar](9) NULL,
	[origin] [varchar](5) NULL,
	[yesterday_bundle_id] [varchar](3) NULL,
	[bundle_id] [varchar](3) NULL,
	[bundle_contribution] [varchar](5) NULL,
	[yesterday_bundle_contribution] [varchar](5) NULL,
	[charging_case] [varchar](4) NULL,
	[message_source] [varchar](6) NULL,
	[contribution_flag] [varchar](1) NULL,
	[qualifying_flag] [varchar](1) NULL,
	[file_id] [int] NULL,
	[prefix_id] [int] NULL,
	[record_type] [varchar](2) NULL,
	[bundle_qualified] [varchar](5) NULL,
	[flag] [int] NULL,
	[wholesale_charge] [float] NULL,
	[transfer_cost] [float] NULL,
	[billed_duration] [int] NULL,
	[MSISDN_ID] [int] NULL,
	[Zone_Id] [int] NULL,
	[Net_Enduser_price] [float] NULL,
	[SerialNumber] [bigint] NULL,
	[SubSequenceNumber] [int] NULL,
	[Roam_State] [smallint] NULL,
	[dialled_number] [varchar](64) NULL,
	[ProductID] [varchar](20) NULL,
	[AccountType1] [int] NULL,
	[ChargeAmount1] [float] NULL,
	[CurrentAccountAmount1] [float] NULL,
	[AccountType2] [int] NULL,
	[ChargeAmount2] [float] NULL,
	[CurrentAccountAmount2] [float] NULL,
	[AccountType3] [int] NULL,
	[ChargeAmount3] [float] NULL,
	[CurrentAccountAmount3] [float] NULL,
	[AccountType4] [int] NULL,
	[ChargeAmount4] [float] NULL,
	[CurrentAccountAmount4] [float] NULL,
	[AccountType5] [int] NULL,
	[ChargeAmount5] [float] NULL,
	[CurrentAccountAmount5] [float] NULL,
	[AccountType6] [int] NULL,
	[ChargeAmount6] [float] NULL,
	[CurrentAccountAmount6] [float] NULL,
	[AccountType7] [int] NULL,
	[ChargeAmount7] [float] NULL,
	[CurrentAccountAmount7] [float] NULL,
	[AccountType8] [int] NULL,
	[ChargeAmount8] [float] NULL,
	[CurrentAccountAmount8] [float] NULL,
	[AccountType9] [int] NULL,
	[ChargeAmount9] [float] NULL,
	[CurrentAccountAmount9] [float] NULL,
	[AccountType10] [int] NULL,
	[ChargeAmount10] [float] NULL,
	[CurrentAccountAmount10] [float] NULL,
	[IMSI] [varchar](64) NULL,
	[Redirecting_Number] [varchar](20) NULL,
	[Originating_Location_Information] [varchar](20) NULL,
	[Terminating_Location_Information] [varchar](20) NULL,
	[Charged_Party_Single] [int] NULL,
	[Balance_After] [decimal](20, 4) NULL,
	[Redirection_Reason] [int] NULL,
	[Charge_Duration] [int] NULL,
	[Hot_Line_Indicator] [int] NULL,
	[Service_Type] [varchar](20) NULL,
	[Termination_Reason] [int] NULL,
	[Calling_Cell_ID] [varchar](20) NULL,
	[Direction_Indicator] [varchar](20) NULL,
	[On_Net_Indicator] [tinyint] NULL,
	[Result_Code] [int] NULL,
	[Run_ID] [bigint] NULL,
	[Price_Plan_ID] [int] NULL
) ON [CDR2014_01]

GO



----------------------- FIND THE PARTITION FOR THE REMOVABLE FILEGROUP


-- NLD_CDR2013_SCH

select * from sys.partition_functions  --  65543
go

select * from sys.partitions



select top 1000 * from sys.partition_range_values where function_id= 65547   -- >> BOUNDRY_ID  = 2
GO


---------------------------- switch 

ALTER TABLE CDR2014 SWITCH PARTITION 2 TO [CDR2014_staging]
go


sp_spaceused [CDR2014_staging]
go

select top 100 * from [CDR2014_staging]
go

drop table [CDR2014_staging]
go

------------- shrink


------ allot the space in fiegroup

USE [master]
GO
ALTER DATABASE [GBRVIEW_ARCHIVE] MODIFY FILE ( NAME = N'CDR2014_08', SIZE = 58553344KB )
GO

--------------------- drop index

USE [GBRVIEW_ARCHIVE]
GO

/****** Object:  Index [IX_ANumber]    Script Date: 08/01/2015 16:22:13 ******/
DROP INDEX [IX_ANumber] ON [dbo].[CDR2014]
GO


USE [GBRVIEW_ARCHIVE]
GO

/****** Object:  Index [IX_CDR_Type]    Script Date: 08/01/2015 16:22:38 ******/
DROP INDEX [IX_CDR_Type] ON [dbo].[CDR2014]
GO

-----------------------   BULK INSERT

----------------\\192.168.0.58\backup\Archive_Files\2014\8\LEB-ODSMSSQL1\NLD\CDR_0

select GETDATE()
go

 USE [GBRVIEW_archive]
GO

bulk insert GBRVIEW_archive.dbo.[CDR2014] from
'N:\Archive\GBRVIEW_CDR_201408.TXT'
with (batchsize=10000,tablock,FIELDTERMINATOR='\t',KeepIdentity)
GO

select GETDATE()
go
--------------------  create index


/****** Object:  Index [IX_ANumber]    Script Date: 08/01/2015 16:22:13 ******/
CREATE NONCLUSTERED INDEX [IX_ANumber] ON [dbo].[CDR2014]
(
	[A_Number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [NLD_CDR2014_SCH]([Charging_TimeStamp])
GO


select GETDATE()
go

/****** Object:  Index [IX_CDR_Type]    Script Date: 08/01/2015 16:22:38 ******/
CREATE NONCLUSTERED INDEX [IX_CDR_Type] ON [dbo].[CDR2014]
(
	[CDR_Type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [NLD_CDR2014_SCH]([Charging_TimeStamp])
GO

select GETDATE()
go

