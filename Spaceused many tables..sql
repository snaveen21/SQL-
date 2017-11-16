DECLARE @spaceused TABLE (
      table_name nvarchar(128),
      [rows] int,
      reserved varchar(18),
      data varchar(18),
      index_size  varchar(18),
      unused varchar(18)
      )
INSERT @spaceused  Exec sp_spaceused CustomData
INSERT @spaceused  Exec sp_spaceused MessageStates
INSERT @spaceused  Exec sp_spaceused MessageEvents
INSERT @spaceused  Exec sp_spaceused Messages
INSERT @spaceused  Exec sp_spaceused ResubmitData
INSERT @spaceused  Exec sp_spaceused ChildMessages
INSERT @spaceused  Exec sp_spaceused StatEntries
INSERT @spaceused  Exec sp_spaceused alertsPersistedAlerts

select table_name,	rows,	substring(reserved,1,len(reserved)-3)+'KB' as [RESERVED],	substring(data,1,len(data)-3)+'KB'as [DATA],index_size,	unused from @spaceused 
