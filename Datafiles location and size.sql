SELECT name, physical_name, state_desc, size, max_size, is_read_only
  FROM databasename.sys.database_files  
  WHERE type_desc = 'ROWS';
  
  SELECT name, type_desc, is_read_only 
  FROM sys.filegroups;
  
  
  SELECT FileGroupName = fg.name, FileGroupType = fg.type_desc, 
    FileGroupReadOnly = fg.is_read_only, 
    [FileName] = f.name, [FileLocation] = f.physical_name, 
    [FileState] = f.state_desc, f.size, f.max_size, 
    FileReadOnly = f.is_read_only
FROM sys.filegroups AS fg
LEFT OUTER JOIN sys.database_files AS f
ON fg.data_space_id = f.data_space_id
ORDER BY fg.data_space_id;