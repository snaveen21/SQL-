

--------CREATE PARTIONING

USE [master]
GO
ALTER DATABASE [DNKVIEW_ARCHIVE] ADD FILEGROUP [DNK_CDR_V2_2015_01]
GO
ALTER DATABASE [DNKVIEW_ARCHIVE] ADD FILE ( NAME = N'DNK_CDR_V2_2015_01', FILENAME = N'G:\ODS1\DNK_ARC\DATA\A_DATA\CDR_V2_2015\DNK_CDR_V2_2015_01.ndf' , SIZE = 102400KB , FILEGROWTH = 102400KB ) TO FILEGROUP [DNK_CDR_V2_2015_01]
GO
ALTER DATABASE [DNKVIEW_ARCHIVE] ADD FILEGROUP [DNK_CDR_V2_2015]
GO
ALTER DATABASE [DNKVIEW_ARCHIVE] ADD FILE ( NAME = N'DNK_CDR_V2_2015', FILENAME = N'G:\ODS1\DNK_ARC\DATA\A_DATA\CDR_V2_2015\DNK_CDR_V2_2015.ndf' , SIZE = 102400KB , FILEGROWTH = 102400KB ) TO FILEGROUP [DNK_CDR_V2_2015]
GO
ALTER DATABASE [DNKVIEW_ARCHIVE] ADD FILEGROUP [DNK_CDR_V2_2015_02]
GO
ALTER DATABASE [DNKVIEW_ARCHIVE] ADD FILE ( NAME = N'DNK_CDR_V2_2015_02', FILENAME = N'G:\ODS1\DNK_ARC\DATA\A_DATA\CDR_V2_2015\DNK_CDR_V2_2015_02.ndf' , SIZE = 102400KB , FILEGROWTH = 102400KB ) TO FILEGROUP [DNK_CDR_V2_2015_02]
GO
ALTER DATABASE [DNKVIEW_ARCHIVE] ADD FILEGROUP [DNK_CDR_V2_2015_03]
GO
ALTER DATABASE [DNKVIEW_ARCHIVE] ADD FILE ( NAME = N'DNK_CDR_V2_2015_03', FILENAME = N'G:\ODS1\DNK_ARC\DATA\A_DATA\CDR_V2_2015\DNK_CDR_V2_2015_03.ndf' , SIZE = 102400KB , FILEGROWTH = 102400KB ) TO FILEGROUP [DNK_CDR_V2_2015_03]
GO
ALTER DATABASE [DNKVIEW_ARCHIVE] ADD FILEGROUP [DNK_CDR_V2_2015_04]
GO
ALTER DATABASE [DNKVIEW_ARCHIVE] ADD FILE ( NAME = N'DNK_CDR_V2_2015_04', FILENAME = N'G:\ODS1\DNK_ARC\DATA\A_DATA\CDR_V2_2015\DNK_CDR_V2_2015_04.ndf' , SIZE = 102400KB , FILEGROWTH = 102400KB ) TO FILEGROUP [DNK_CDR_V2_2015_04]
GO
ALTER DATABASE [DNKVIEW_ARCHIVE] ADD FILEGROUP [DNK_CDR_V2_2015_05]
GO
ALTER DATABASE [DNKVIEW_ARCHIVE] ADD FILE ( NAME = N'DNK_CDR_V2_2015_05', FILENAME = N'G:\ODS1\DNK_ARC\DATA\A_DATA\CDR_V2_2015\DNK_CDR_V2_2015_05.ndf' , SIZE = 102400KB , FILEGROWTH = 102400KB ) TO FILEGROUP [DNK_CDR_V2_2015_05]
GO
ALTER DATABASE [DNKVIEW_ARCHIVE] ADD FILEGROUP [DNK_CDR_V2_2015_06]
GO
ALTER DATABASE [DNKVIEW_ARCHIVE] ADD FILE ( NAME = N'DNK_CDR_V2_2015_06', FILENAME = N'G:\ODS1\DNK_ARC\DATA\A_DATA\CDR_V2_2015\DNK_CDR_V2_2015_06.ndf' , SIZE = 102400KB , FILEGROWTH = 102400KB ) TO FILEGROUP [DNK_CDR_V2_2015_06]
GO
ALTER DATABASE [DNKVIEW_ARCHIVE] ADD FILEGROUP [DNK_CDR_V2_2015_07]
GO
ALTER DATABASE [DNKVIEW_ARCHIVE] ADD FILE ( NAME = N'DNK_CDR_V2_2015_07', FILENAME = N'G:\ODS1\DNK_ARC\DATA\A_DATA\CDR_V2_2015\DNK_CDR_V2_2015_07.ndf' , SIZE = 102400KB , FILEGROWTH = 102400KB ) TO FILEGROUP [DNK_CDR_V2_2015_07]
GO
ALTER DATABASE [DNKVIEW_ARCHIVE] ADD FILEGROUP [DNK_CDR_V2_2015_08]
GO
ALTER DATABASE [DNKVIEW_ARCHIVE] ADD FILE ( NAME = N'DNK_CDR_V2_2015_08', FILENAME = N'G:\ODS1\DNK_ARC\DATA\A_DATA\CDR_V2_2015\DNK_CDR_V2_2015_08.ndf' , SIZE = 102400KB , FILEGROWTH = 102400KB ) TO FILEGROUP [DNK_CDR_V2_2015_08]
GO
ALTER DATABASE [DNKVIEW_ARCHIVE] ADD FILEGROUP [DNK_CDR_V2_2015_09]
GO
ALTER DATABASE [DNKVIEW_ARCHIVE] ADD FILE ( NAME = N'DNK_CDR_V2_2015_09', FILENAME = N'G:\ODS1\DNK_ARC\DATA\A_DATA\CDR_V2_2015\DNK_CDR_V2_2015_09.ndf' , SIZE = 102400KB , FILEGROWTH = 102400KB ) TO FILEGROUP [DNK_CDR_V2_2015_09]
GO
ALTER DATABASE [DNKVIEW_ARCHIVE] ADD FILEGROUP [DNK_CDR_V2_2015_10]
GO
ALTER DATABASE [DNKVIEW_ARCHIVE] ADD FILE ( NAME = N'DNK_CDR_V2_2015_10', FILENAME = N'G:\ODS1\DNK_ARC\DATA\A_DATA\CDR_V2_2015\DNK_CDR_V2_2015_10.ndf' , SIZE = 102400KB , FILEGROWTH = 102400KB ) TO FILEGROUP [DNK_CDR_V2_2015_10]
GO
ALTER DATABASE [DNKVIEW_ARCHIVE] ADD FILEGROUP [DNK_CDR_V2_2015_11]
GO
ALTER DATABASE [DNKVIEW_ARCHIVE] ADD FILE ( NAME = N'DNK_CDR_V2_2015_11', FILENAME = N'G:\ODS1\DNK_ARC\DATA\A_DATA\CDR_V2_2015\DNK_CDR_V2_2015_11.ndf' , SIZE = 102400KB , FILEGROWTH = 102400KB ) TO FILEGROUP [DNK_CDR_V2_2015_11]
GO
ALTER DATABASE [DNKVIEW_ARCHIVE] ADD FILEGROUP [DNK_CDR_V2_2015_12]
GO
ALTER DATABASE [DNKVIEW_ARCHIVE] ADD FILE ( NAME = N'DNK_CDR_V2_2015_12', FILENAME = N'G:\ODS1\DNK_ARC\DATA\A_DATA\CDR_V2_2015\DNK_CDR_V2_2015_12.ndf' , SIZE = 102400KB , FILEGROWTH = 102400KB ) TO FILEGROUP [DNK_CDR_V2_2015_12]
GO

----------------------------------------------


/****** Object:  PartitionFunction [DNK_CDR_V2_2015_FN]    Script Date: 08/02/2015 23:41:27 ******/
CREATE PARTITION FUNCTION [DNK_CDR_V2_2015_FN](datetime) AS RANGE RIGHT FOR VALUES (N'2015-01-01T00:00:00.000', N'2015-02-01T00:00:00.000', N'2015-03-01T00:00:00.000', N'2015-04-01T00:00:00.000', N'2015-05-01T00:00:00.000', N'2015-06-01T00:00:00.000', N'2015-07-01T00:00:00.000', N'2015-08-01T00:00:00.000', N'2015-09-01T00:00:00.000', N'2015-10-01T00:00:00.000', N'2015-11-01T00:00:00.000', N'2015-12-01T00:00:00.000')
GO

USE [DNKVIEW_ARCHIVE]
GO

/****** Object:  PartitionScheme [DNK_CDR_V2_2015_SCH]    Script Date: 08/02/2015 23:41:43 ******/
CREATE PARTITION SCHEME [DNK_CDR_V2_2015_SCH] AS PARTITION [DNK_CDR_V2_2015_FN] TO ([DNK_CDR_V2_2015], [DNK_CDR_V2_2015_01], [DNK_CDR_V2_2015_02], [DNK_CDR_V2_2015_03], [DNK_CDR_V2_2015_04], [DNK_CDR_V2_2015_05], [DNK_CDR_V2_2015_06], [DNK_CDR_V2_2015_07], [DNK_CDR_V2_2015_08], [DNK_CDR_V2_2015_09], [DNK_CDR_V2_2015_10], [DNK_CDR_V2_2015_11], [DNK_CDR_V2_2015_12])
GO

----------------------


USE [DNKVIEW_ARCHIVE]
GO



CREATE TABLE [dbo].[CDR_V2_2015](
	[CDR_Specific_ID] [bigint] IDENTITY(1400000000,1) NOT FOR REPLICATION NOT NULL,
	[MSISDN] [varchar](25) NULL,
	[A_number] [varchar](25) NULL,
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
	[allowance_value] [float] NULL,
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
	[MSISDN_ID] [bigint] NULL,
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
	[Price_Plan_ID] [int] NULL,
	[Profile] [varchar](20) NULL,
	[Calling_Home_Country_Code] [int] NULL,
	[Called_Home_Country_Code] [int] NULL,
	[Calling_Roam_Country_Code] [int] NULL,
	[Called_Roam_Country_Code] [int] NULL,
	[Service_flow] [tinyint] NULL,
	[inserted_date] [datetime] NULL,
	[inserted_by] [varchar](100) NULL,
	[modified_date] [datetime] NULL,
	[modified_by] [varchar](100) NULL,
	[description] [varchar](100) NULL,
 CONSTRAINT [pk_CDR_V2_2015] PRIMARY KEY CLUSTERED 
(
	[CDR_Specific_ID] ASC,
	[charging_timestamp] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [DNK_CDR_V2_2015_SCH]([charging_timestamp])
) ON [DNK_CDR_V2_2015_SCH]([charging_timestamp])

GO


-------------------------------



USE [DNKVIEW_ARCHIVE]
/****** Object:  Index [IX_CDR_MSISDN]    Script Date: 08/02/2015 23:40:03 ******/
CREATE NONCLUSTERED INDEX [IX_CDR_MSISDN_2015] ON [dbo].[CDR_V2_2015] 
(
	[MSISDN] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [DNK_CDR_V2_2015_SCH]([charging_timestamp])
GO

ALTER TABLE [dbo].[CDR_V2_2015] ADD  DEFAULT (getdate()) FOR [inserted_date]
GO


