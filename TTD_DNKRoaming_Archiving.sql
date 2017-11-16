use DNKTTD_ROAMING
go 



 DNK_CDR to Bkp_Apr2015_May2015_DNK_CDR
 DNK_FileName to Bkp_Apr2015_May2015_DNK_FileName
 REC_CDR to Bkp_Apr2015_May2015_REC_CDR
 SMS_REC_CDR to Bkp_Apr2015_May2015_SMS_REC_CDR
 DATA_REC_CDR to Bkp_Apr2015_May2015_DATA_REC_CDR



Declare @Cbcpquery varchar(1000) 
set @Cbcpquery = 'BCP "select * from DNKTTD_ROAMING.dbo.DNK_CDR(nolock)" queryout I:\Archive\DNKTTD_ROAMING\DNK_CDR.txt -o I:\Archive\DNKTTD_ROAMING\DNK_CDR_log_1.txt -c -T -S LEB-EDWTTD01'

print  @Cbcpquery

Exec master..xp_cmdshell @Cbcpquery


Declare @Cbcpquery varchar(1000) 
set @Cbcpquery = 'BCP "select * from DNKTTD_ROAMING.dbo.DNK_FileName(nolock)" queryout I:\Archive\DNKTTD_ROAMING\DNK_FileName.txt -o I:\Archive\DNKTTD_ROAMING\DNK_FileName_log_1.txt -c -T -S LEB-EDWTTD01'

print  @Cbcpquery

Exec master..xp_cmdshell @Cbcpquery


Declare @Cbcpquery varchar(1000) 
set @Cbcpquery = 'BCP "select * from DNKTTD_ROAMING.dbo.REC_CDR(nolock)" queryout I:\Archive\DNKTTD_ROAMING\REC_CDR.txt -o I:\Archive\DNKTTD_ROAMING\REC_CDR_log_1.txt -c -T -S LEB-EDWTTD01'

print  @Cbcpquery

Exec master..xp_cmdshell @Cbcpquery


Declare @Cbcpquery varchar(1000) 
set @Cbcpquery = 'BCP "select * from DNKTTD_ROAMING.dbo.SMS_REC_CDR(nolock)" queryout I:\Archive\DNKTTD_ROAMING\Bkp_Apr2015_May2015_SMS_REC_CDR.txt -o I:\Archive\DNKTTD_ROAMING\Bkp_Apr2015_May2015_SMS_REC_CDR_log.txt -c -T -S LEB-EDWTTD01'

print  @Cbcpquery

Exec master..xp_cmdshell @Cbcpquery


Declare @Cbcpquery varchar(1000) 
set @Cbcpquery = 'BCP "select * from DNKTTD_ROAMING.dbo.DATA_REC_CDR(nolock)" queryout I:\Archive\DNKTTD_ROAMING\Bkp_Apr2015_May2015_DATA_REC_CDR.txt -o I:\Archive\DNKTTD_ROAMING\Bkp_Apr2015_May2015_DATA_REC_CDR_log.txt -c -T -S LEB-EDWTTD01'

print  @Cbcpquery

Exec master..xp_cmdshell @Cbcpquery


57017466 
sp_spaceused DNK_CDR

truncate table DNKTTD_ROAMING.dbo.DNK_FileName
truncate table DNKTTD_ROAMING.dbo.REC_CDR
truncate table DNKTTD_ROAMING.dbo.SMS_REC_CDR
truncate table DNKTTD_ROAMING.dbo.DATA_REC_CDR
truncate table DNKTTD_ROAMING.dbo.DNK_CDR