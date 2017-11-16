  
  --runn it in both FTDW and REp
 
 select Top 10 * from CDR_Tran_Account_Link
  select max (Audit_Key) as Autid_KEY from CDR_Tran_Account_Link nolock 
  
  select MAX(EVENT_START_DATE_TIME) from MNO_CDR_TRAN where AUDIT_KEY=3423212
  --2015-08-23 07:29:54.000

 select max (Audit_Key) as Autid_KEY from CDR_Tran_Account_Link nolock 
 --use the max audit key to get the time
 select MAX(EVENT_START_DATE_TIME) from MNO_CDR_TRAN where AUDIT_KEY=3423214