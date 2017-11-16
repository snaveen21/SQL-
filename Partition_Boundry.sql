


SELECT  f.NAME AS file_group_name,
        SCHEMA_NAME(t.schema_id) AS table_schema,
        t.name AS table_name,
        p.partition_number,
        ISNULL(CAST(left_prv.value AS VARCHAR(MAX))+ CASE WHEN pf.boundary_value_on_right = 0 THEN ' < '
               ELSE ' <= '
          END , '-INF < ')
        + 'X' + ISNULL(CASE WHEN pf.boundary_value_on_right = 0 THEN ' <= '
                           ELSE ' < '
                      END + CAST(right_prv.value AS NVARCHAR(MAX)), ' < INF') AS range_desc,
        pf.boundary_value_on_right,
        ps.name AS partition_schem_name,
        pf.name AS partition_function_name,
        left_prv.value AS left_boundary,
        right_prv.value AS right_boundary
FROM    sys.partitions p
JOIN    sys.tables t
        ON p.object_id = t.object_id
JOIN    sys.indexes i
        ON p.object_id = i.object_id
        AND p.index_id = i.index_id
JOIN    sys.allocation_units au
        ON p.hobt_id = au.container_id
JOIN    sys.filegroups f
        ON au.data_space_id = f.data_space_id
LEFT JOIN    sys.partition_schemes ps
        ON ps.data_space_id = i.data_space_id
LEFT JOIN    sys.partition_functions pf
        ON ps.function_id = pf.function_id
LEFT JOIN sys.partition_range_values left_prv
        ON left_prv.function_id = ps.function_id
           AND left_prv.boundary_id + 1 = p.partition_number
LEFT JOIN sys.partition_range_values right_prv
        ON right_prv.function_id = ps.function_id
           AND right_prv.boundary_id = p.partition_number
           order by 3,4
           
           
          
--Type 2

DECLARE @TableName NVARCHAR(200) = N'dbo.CDR_GSM_0'
 
SELECT SCHEMA_NAME(o.schema_id) + '.' + OBJECT_NAME(i.object_id) AS [object]
     , p.partition_number AS [p#]
     , fg.name AS [filegroup]
     , p.rows
     , au.total_pages AS pages
     , CASE boundary_value_on_right
       WHEN 1 THEN 'less than'
       ELSE 'less than or equal to' END as comparison
     , rv.value
     , CONVERT (VARCHAR(6), CONVERT (INT, SUBSTRING (au.first_page, 6, 1) +
       SUBSTRING (au.first_page, 5, 1))) + ':' + CONVERT (VARCHAR(20),
       CONVERT (INT, SUBSTRING (au.first_page, 4, 1) +
       SUBSTRING (au.first_page, 3, 1) + SUBSTRING (au.first_page, 2, 1) +
       SUBSTRING (au.first_page, 1, 1))) AS first_page
FROM sys.partitions p
INNER JOIN sys.indexes i
     ON p.object_id = i.object_id
AND p.index_id = i.index_id
INNER JOIN sys.objects o
     ON p.object_id = o.object_id
INNER JOIN sys.system_internals_allocation_units au
     ON p.partition_id = au.container_id
INNER JOIN sys.partition_schemes ps
     ON ps.data_space_id = i.data_space_id
INNER JOIN sys.partition_functions f
     ON f.function_id = ps.function_id
INNER JOIN sys.destination_data_spaces dds
     ON dds.partition_scheme_id = ps.data_space_id
     AND dds.destination_id = p.partition_number
INNER JOIN sys.filegroups fg
     ON dds.data_space_id = fg.data_space_id
LEFT OUTER JOIN sys.partition_range_values rv
     ON f.function_id = rv.function_id
     AND p.partition_number = rv.boundary_id
WHERE i.index_id < 2
     AND o.object_id = OBJECT_ID(@TableName)
     order by 2;



