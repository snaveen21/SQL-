
--ROWTTD55_VOU_REC_CDR_PROD_evenmonth_IDX
--ROWTTD55_VOU_REC_CDR_PROD_oddmonth_IDX

--ROWTTD55_VOU_REC_CDR_PROD_evenmonth_DATA
--ROWTTD55_VOU_REC_CDR_PROD_oddmonth_DATA


--select * from REC_CDR

USE [master]
GO
ALTER DATABASE [ROWTTD55] ADD FILEGROUP [ROWTTD55_VOU_REC_CDR_PROD_evenmonth_DATA]
GO
ALTER DATABASE [ROWTTD55] ADD FILE (NAME='ROWTTD55_VOU_REC_CDR_PROD_evenmonth_DATA', FILENAME='F:\MSSQL_DATA\ROWTTD55\ROWTTD55_VOU_REC_CDR_PROD_evenmonth_DATA.ndf') TO FILEGROUP ROWTTD55_VOU_REC_CDR_PROD_evenmonth_DATA;


USE [master]
GO
ALTER DATABASE [ROWTTD55] ADD FILEGROUP [ROWTTD55_VOU_REC_CDR_PROD_oddmonth_DATA]
GO
ALTER DATABASE [ROWTTD55] ADD FILE (NAME='ROWTTD55_VOU_REC_CDR_PROD_oddmonth_DATA', FILENAME='F:\MSSQL_DATA\ROWTTD55\ROWTTD55_VOU_REC_CDR_PROD_oddmonth_DATA.ndf') TO FILEGROUP ROWTTD55_VOU_REC_CDR_PROD_oddmonth_DATA;



USE [master]
GO
ALTER DATABASE [ROWTTD55] ADD FILEGROUP [ROWTTD55_VOU_REC_CDR_PROD_evenmonth_IDX]
GO
ALTER DATABASE [ROWTTD55] ADD FILE (NAME='ROWTTD55_VOU_REC_CDR_PROD_evenmonth_IDX', FILENAME='F:\MSSQL_DATA\ROWTTD55\ROWTTD55_VOU_REC_CDR_PROD_evenmonth_IDX.ndf') TO FILEGROUP ROWTTD55_VOU_REC_CDR_PROD_evenmonth_IDX;


USE [master]
GO
ALTER DATABASE [ROWTTD55] ADD FILEGROUP [ROWTTD55_VOU_REC_CDR_PROD_oddmonth_IDX]
GO
ALTER DATABASE [ROWTTD55] ADD FILE (NAME='ROWTTD55_VOU_REC_CDR_PROD_oddmonth_IDX', FILENAME='F:\MSSQL_DATA\ROWTTD55\ROWTTD55_VOU_REC_CDR_PROD_oddmonth_IDX.ndf') TO FILEGROUP ROWTTD55_VOU_REC_CDR_PROD_oddmonth_IDX;



