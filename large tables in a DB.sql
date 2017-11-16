SELECT 
    t.NAME AS TableName,
    i.name as indexName,
    sum(p.rows) as RowCounts,
    sum(a.total_pages) as TotalPages, 
    sum(a.used_pages) as UsedPages, 
    sum(a.data_pages) as DataPages,
    (sum(a.total_pages) * 8) / 1024 as TotalSpaceMB, 
    (sum(a.used_pages) * 8) / 1024 as UsedSpaceMB, 
    (sum(a.data_pages) * 8) / 1024 as DataSpaceMB
FROM 
    sys.tables t
INNER JOIN      
    sys.indexes i ON t.OBJECT_ID = i.object_id
INNER JOIN 
    sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id
INNER JOIN 
    sys.allocation_units a ON p.partition_id = a.container_id
WHERE 
    t.NAME NOT LIKE 'dt%' AND
    i.OBJECT_ID > 255 AND   
    i.index_id <= 1
GROUP BY 
    t.NAME, i.object_id, i.index_id, i.name 
ORDER BY 
    --object_name(i.object_id) 
    SUM(p.rows) DESC
	--SUM(a.total_pages) DESC
    
-- Methode #2

USE ESPView
GO
CREATE TABLE #GetLargest 
(
  table_name    sysname ,
  row_count     INT,
  reserved_size VARCHAR(50),
  data_size     VARCHAR(50),
  index_size    VARCHAR(50),
  unused_size   VARCHAR(50)
)

SET NOCOUNT ON

INSERT #GetLargest

EXEC sp_msforeachtable 'sp_spaceused ''?'''

SELECT 
  a.table_name,
  a.row_count,
  COUNT(*) AS col_count,
  a.data_size
  FROM #GetLargest a
     INNER JOIN information_schema.columns b
     ON a.table_name collate database_default
     = b.table_name collate database_default
       GROUP BY a.table_name, a.row_count, a.data_size
       ORDER BY CAST(REPLACE(a.data_size, ' KB', '') AS integer) DESC

DROP TABLE #GetLargest


-- Method #3
 select name=object_schema_name(object_id) + '.' + object_name(object_id)
, rows=sum(case when index_id < 2 then row_count else 0 end)
, reserved_kb=8*sum(reserved_page_count)
, data_kb=8*sum( case 
     when index_id<2 then in_row_data_page_count + lob_used_page_count + row_overflow_used_page_count 
     else lob_used_page_count + row_overflow_used_page_count 
    end )
, index_kb=8*(sum(used_page_count) 
    - sum( case 
           when index_id<2 then in_row_data_page_count + lob_used_page_count + row_overflow_used_page_count 
        else lob_used_page_count + row_overflow_used_page_count 
        end )
     )    
, unused_kb=8*sum(reserved_page_count-used_page_count)
from sys.dm_db_partition_stats
where object_id > 1024
group by object_id
order by 
3 desc   