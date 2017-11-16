--Find the Index Fragmentation --


select top 10 * from Voucher_Batch
sp_help Voucher_Final

SELECT a.index_id, name, avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats (DB_ID(), OBJECT_ID(N'Voucher_Batch'),
     NULL, NULL, NULL) AS a
    JOIN sys.indexes AS b ON a.object_id = b.object_id AND a.index_id = b.index_id;


/* avg_fragmentation_in_percent value  Corrective statement  
> 5% and < = 30%						-- ALTER INDEX REORGANIZE
> 30%									-- ALTER INDEX REBUILD WITH (ONLINE = ON)*
*/
 

ALTER INDEX PK_BatchID ON Voucher_Batch
REORGANIZE ;

ALTER INDEX PK_BatchID ON Voucher_Batch
REBUILD ;
GO

