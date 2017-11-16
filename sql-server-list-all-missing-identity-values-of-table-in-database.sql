/*============================================================================
Original Blog Link: http://blog.sqlauthority.com/2009/07/27/sql-server-list-all-missing-identity-values-of-table-in-database/
(C) Pinal Dave http://blog.SQLAuthority.com
Like us on Facebook: http://facebook.com/SQLAuth
Follow us on Twitter: http://twitter.com/pinaldave
============================================================================*/
/*
	Functionality : 
					* List all Table Names which do have missing identity values. 
					* Provide missing Identity values.

	Compatibility : 
					* SQL Server 2005 and higher

	Note :
	1. To be executed on each database. (This is not at server level)

	Created By : 
			Imran Mohammed 
			
	Downloaded From :
			http://blog.SQLAuthority.com		
			
	Copyright : 
			pinal@sqlauthority (C) http://blog.SQLAuthority.com
*/
SET NOCOUNT ON
SET ANSI_WARNINGS OFF

DECLARE @Store_TABLE_Info TABLE  (	Ident int IDENTITY (1,1)
									, Table_Name varchar(256)
									, Column_Name varchar(130)
									, Seed_Value sql_variant
									, increment_value sql_variant
									, Last_value sql_variant
								 )

DECLARE @Table_Name varchar(261) 
		,@Column_Name varchar(130)
		,@Seed_value sql_variant
		,@Increment_Value sql_variant
		,@last_Value sql_variant
		,@count int
		,@Sqlcmd1 nvarchar(4000)
		,@Sqlcmd2 nvarchar(4000)
		,@Sqlcmd3 nvarchar(4000)
		,@count_Records  varchar(50)

/*
 List out all table names thats has identity column. 
	* Get Complete Table Name (Including Schema Name).
	* Get Column Name on which Identity property is enabled
	* Get Seed Value (Starting Value of Identity)
	* Get Increment Value (Incremental value for Identity Property)
	* Get Current Seed value/ Last Value in column. (Current Value)
*/

INSERT INTO		@Store_TABLE_Info
				SELECT	'['+SCHEMA_NAME([Schema_id])+'].'+ '['+OBJECT_NAME(ST.[object_id])+']'  [Table_Name]
						,'['+SIC.Name+']' [Column_Name]
						,Seed_Value
						,Increment_Value
						,ISNULL(last_Value,0)last_Value
				FROM	Sys.Tables ST
						JOIN sys.Identity_columns SIC ON ST.[object_id] = SIC.[object_id] 

CREATE TABLE	#Temp_Final_Mismatch	(	TABLE_Name varchar(261)
											, Column_Name varchar(130)
											, Missing_Identity_Values varchar (MAX)
										)

SET @count = 1 
WHILE @count < =  ( SELECT COUNT(* ) FROM @Store_TABLE_Info)
	BEGIN 
		SELECT	@TABLE_Name = TABLE_Name 
				,@Column_Name = Column_Name 
				,@Seed_value = Seed_value
				,@Increment_Value = Increment_Value 
				,@last_Value = last_Value 
		FROM	@Store_TABLE_Info
		WHERE	Ident = @Count 

		/*
		Considering One table at a time (Making Use of While Loop):

		Using Above information:
		1. we First create a Temporary table with same column name, with the same Seed Value and Same Increment value. 
		2. We have Seed Value, Increment Value and Current Value, This information is enough to have complete set of Identity values in our Temporary table.
			* This is done through another while loop.
		3. Now we will compare Temporary Table created in Step 1 with User Defined table 
			* Trying to find all missing Identity values that are present in Temporary table but not present in user defined table. (One Table at a time)
		4. Result from above step, we store into another temporary table.
		*/	

		--		Based on Original Seed Value, Increment Value and Current Value, We can calculate how many records suppose to be present in User Defined Table.		

		SET @count_Records = CONVERT(varchar ,((CONVERT(int,@last_Value) - (1* CONVERT(int,@Seed_value)) )/CONVERT(int,@Increment_Value)  )+	1) 

		SET @Sqlcmd1 = '
			CREATE TABLE #Temp_'+CONVERT(varchar , @Count) +' ( '+@Column_Name+' int IDENTITY ('+CONVERT(varchar ,@Seed_value) +','+CONVERT( varchar,@Increment_Value)+'), Bit_Value bit default (1))
			
			'+/*			
				Inserting Estimated No of Records into Temporary table.
			*/+'
			DECLARE @Count1 int 
			SET @Count1 = 1 
			While @Count1 < = '+@count_Records+' -- To Get Actual Number of records that should be present in a TABLE.
				BEGIN
					INSERT INTO #Temp_'+CONVERT(varchar , @Count) +' VALUES (default)		
					SET @Count1 = @Count1 + 1
				END

			'+/*			
				Comparing Temporary Table with User Defined Table, To get Missing Identity Values information.
			*/+'
			DECLARE @temp_store_id TABLE ( Ident int IDENTITY (1,1), Missing_Ident varchar (50))

			INSERT INTO @temp_store_id (Missing_Ident)
										SELECT '+@Column_Name+' 
										FROM
											(
												SELECT	'+@Column_Name+'  
												FROM	#Temp_'+CONVERT(varchar , @Count) +' 
													EXCEPT
												SELECT	'+@Column_Name +' 
												FROM	'+@TABLE_Name+'
											) X

			'+/*			
				Now that we have all Missing value into @temp_store_id Table. Lets make it a string, So that we can easily read it.
			*/+'
			DECLARE @String varchar (max)
			SET @String = '' ''
			SELECT @String = @String + CASE WHEN @string = '' '' THEN '''' ELSE '','' END + CONVERT( varchar(50),Missing_Ident) 
			FROM @temp_store_id 

			'+/*			
				Store String Values in another temporary table, Which will be displayed at the end
			*/+'
			If @String != '' ''
				INSERT INTO #Temp_Final_Mismatch VALUES ('''+@TABLE_Name+''', '''+@Column_Name +''' , @String )

			DROP TABLE #Temp_'+CONVERT(varchar , @Count) 

			--print @Sqlcmd1 
			 EXEC Sp_EXECutesql @Sqlcmd1 
		SET @count = @count + 1
END 

-- Displaying Final Result.
SELECT	* 
FROM	#Temp_Final_Mismatch

DROP TABLE #Temp_Final_Mismatch 
SET NOCOUNT ON
SET ANSI_WARNINGS ON
GO