truncate table [DEL_BULK_UPLOAD]

bulk insert [DEL_BULK_UPLOAD]
 from 'F:\GermanyNormalExpired\DE_OCS_20141217.list' 
 with (ROWTERMINATOR = '0x0a',batchsize=10000,tablock,KeepIdentity)
 
 
 
 Declare @vr_FileName varchar(1000) 
 set @vr_FileName ='DE_OCS_20141217.list'
     INSERT into [dbo].[DE_Expired_Kalyan] (MSISDN, OCSDelDate, OCSFileName)          
    SELECT           
    ltrim(rtrim(MSISDN)) as MSISDN,          
    SUBSTRING(@vr_FileName,LEN(@vr_FileName)-12,8) as OCSDelDate,          
     @vr_FileName as OCSFileName
     --into [dbo].[DE_Expired_Kalyan]    
    from [dbo].[DEL_BULK_UPLOAD]   
 
 
 select distinct (OCSDelDate) from [DE_Expired_Kalyan] order by 1
 
 