
select Count(MSISDN) from [dbo].[OCSDump08012015] where Status='NormalExpired'

truncate table [DEL_BULK_UPLOAD]
bulk insert [DEL_BULK_UPLOAD]
 from 'f:\DE_NormalExpired.txt'
 with (ROWTERMINATOR = '0x0a',batchsize=10000,tablock,KeepIdentity)
 
 
    INSERT into [dbo].[OCSDump08012015] (MSISDN, Status)          
    SELECT           
    ltrim(rtrim(MSISDN)) as MSISDN,          
    'NormalExpired'    
    from [dbo].[DEL_BULK_UPLOAD]   
    