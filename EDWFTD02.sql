
Declare @Cbcpquery varchar(1000) 
set @Cbcpquery = 'BCP "select * from ldw_archive.dbo.DEU_MNO_CDR_Tran_Archive_2014_OCT_1 (nolock)" queryout C:\FT\Log05\DEU_MNO_CDR_Tran_Archive_2014_OCT.txt -o C:\FT\Log05\DEU_MNO_CDR_Tran_Archive_2014_OCT_log.txt -c -T -S LEB-EDWFTDW02'

print  @Cbcpquery



Declare @Cbcpquery varchar(1000) 
set @Cbcpquery = 'BCP "select * from ldw_archive.dbo.AUS_MNO_CDR_Tran_Archive_2014_NOV (nolock)" queryout C:\FT\Log05\AUS_MNO_CDR_Tran_Archive_2014_NOV.txt -o C:\FT\Log05\AUS_MNO_CDR_Tran_Archive_2014_NOV_log.txt -c -T -S LEB-EDWFTDW02'

print  @Cbcpquery





Declare @Cbcpquery varchar(1000) 
set @Cbcpquery = 'BCP "select * from ldw_archive.dbo.AUS_MNO_CDR_Tran_Archive_2014_DEC (nolock)" queryout C:\FT\Log05\AUS_MNO_CDR_Tran_Archive_2014_DEC.txt -o C:\FT\Log05\AUS_MNO_CDR_Tran_Archive_2014_DEC_log.txt -c -T -S LEB-EDWFTDW02'

print  @Cbcpquery




Declare @Cbcpquery varchar(1000) 
set @Cbcpquery = 'BCP "select * from ldw_archive.dbo.FRA_MNO_CDR_Tran_Archive_2014_OCT_1 (nolock)" queryout C:\FT\Log05\FRA_MNO_CDR_Tran_Archive_2014_OCT.txt -o C:\FT\Log05\FRA_MNO_CDR_Tran_Archive_2014_OCT_log.txt -c -T -S LEB-EDWFTDW02'

print  @Cbcpquery