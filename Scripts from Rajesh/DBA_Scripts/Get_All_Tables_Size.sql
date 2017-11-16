DECLARE @TableName VARCHAR(100)    --For storing values in the cursor        
        
--Cursor to get the name of all user tables from the sysobjects listing        
DECLARE tableCursor CURSOR        
FOR         
select name from sys.sysobjects where xtype = 'U'      

        
--A procedure level temp table to store the results        
CREATE TABLE #TempTable        
(        
    tableName varchar(100),        
    numberofRows varchar(100),        
    reservedSize varchar(50),        
    dataSize varchar(50),        
    indexSize varchar(50),        
    unusedSize varchar(50)        
)        
        
--Open the cursor        
OPEN tableCursor        
        
--Get the first table name from the cursor        
FETCH NEXT FROM tableCursor INTO @TableName        
        
--Loop until the cursor was not able to fetch        
WHILE (@@Fetch_Status >= 0)        
BEGIN        
    --Dump the results of the sp_spaceused query to the temp table        
        INSERT  #TempTable        
        EXEC sp_spaceused  @TableName        
                
    --Get the next table name        
    FETCH NEXT FROM tableCursor INTO @TableName        
END        
        
--Get rid of the cursor        
CLOSE tableCursor        
DEALLOCATE tableCursor  

select * from   #TempTable

--drop table #TempTable       
GO


