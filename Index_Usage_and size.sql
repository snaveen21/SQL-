


SELECT  convert(char(100),object_name(i.object_id)) AS table_name, i.name AS index_name, 
    i.index_id, i.type_desc as index_type,
    partition_id, partition_number AS pnum,  rows, 
    allocation_unit_id AS au_id, a.type_desc as page_type_desc, total_pages AS pages
FROM sys.indexes i JOIN sys.partitions p  
      ON i.object_id = p.object_id AND i.index_id = p.index_id
    JOIN sys.allocation_units a
      ON p.partition_id = a.container_id
      order by pages desc
      
   
--Below we can see the number of Inserts, Updates and Deletes that occurred for each index, so this shows how much work SQL Server had to do to maintain the index. 

SELECT OBJECT_NAME(A.[OBJECT_ID]) AS [OBJECT NAME], 
       I.[NAME] AS [INDEX NAME], 
       A.LEAF_INSERT_COUNT, 
       A.LEAF_UPDATE_COUNT, 
       A.LEAF_DELETE_COUNT  
FROM   SYS.DM_DB_INDEX_OPERATIONAL_STATS (db_id(),NULL,NULL,NULL ) A 
       INNER JOIN SYS.INDEXES AS I 
         ON I.[OBJECT_ID] = A.[OBJECT_ID] 
            AND I.INDEX_ID = A.INDEX_ID 
WHERE  OBJECTPROPERTY(A.[OBJECT_ID],'IsUserTable') = 1   
      
      
      
--This DMV shows you how many times the index was used for user queries

--Here we can see seeks, scans, lookups and updates. 

--The seeks refer to how many times an index seek occurred for that index.  A seek is the fastest way to access the data, so this is good.
--The scans refers to how many times an index scan occurred for that index.  A scan is when multiple rows of data had to be searched to find the data.  Scans are something you want to try to avoid.
--The lookups refer to how many times the query required data to be pulled from the clustered index or the heap (does not have a clustered index).  Lookups are also something you want to try to avoid.
--The updates refers to how many times the index was updated due to data changes which should correspond to the first query above.

SELECT OBJECT_NAME(S.[OBJECT_ID]) AS [OBJECT NAME], 
       I.[NAME] AS [INDEX NAME], 
       USER_SEEKS, 
       USER_SCANS, 
       USER_LOOKUPS, 
       USER_UPDATES 
FROM   SYS.DM_DB_INDEX_USAGE_STATS AS S 
       INNER JOIN SYS.INDEXES AS I ON I.[OBJECT_ID] = S.[OBJECT_ID] AND I.INDEX_ID = S.INDEX_ID 
WHERE  OBJECTPROPERTY(S.[OBJECT_ID],'IsUserTable') = 1
       AND S.database_id = DB_ID()
       
       
       ContactBase                                                                                         
ContactExtensionBase                                                                                
ContactExtensionBase                                                                                
ContactExtensionBase                                                                                
ContactExtensionBase                                                                                
ContactExtensionBase                                                                                
CustomerAddressBase                                                                                 
Demo_SIMCardExtensionBase                                                                           
CustomerAddressBase                                                                                 
AnnotationBase                                                                                      