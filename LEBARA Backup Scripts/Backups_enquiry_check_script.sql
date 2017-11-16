
-------------------------------- Any server 
------------------ Backups_enquiry_check_script

select database_name, backup_start_date,backup_finish_date , 
case  type when  'I' then 'Differential' when  'D' then 'FULL'  else 'Other' end Type, 
left(physical_device_name,len(physical_device_name) -(CHARINDEX('\', REVERSE(physical_device_name)))+1) Location,
Datename(weekday, backup_finish_date ) Day, 
datediff ( HH, backup_start_date ,
backup_finish_date)Hours , 
backup_size/1028/1028 Size
from msdb..backupset a, msdb..backupmediafamily b
where a.media_set_id = b.media_set_id 
-- and database_name = 'Bi_backup_clean'  -- >>  choose required database if required
-- an  d type = 'D'  -- >>  choose backup types as required ( D = Database/ I = Differential database/ L = Log/ F = File or filegroup/ G =Differential file/ P = Partial/ Q = Differential partial )
order by a.backup_start_date desc 
