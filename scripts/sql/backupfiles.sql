declare @stopattime as datetime
declare @dbname as varchar(100)
declare @backupstartdate as datetime
select @stopattime = '@parameter2',@DBName = '@parameter1',@backupstartdate='1900-01-01'

if object_id('tempdb..#backupinfo') is not null
	drop table #backupinfo
create table #backupinfo(
	start_date datetime,
	backup_type varchar(1),
	file_name varchar(1000),
	file_size varchar(100)
)

declare @sql as nvarchar(1000)
set @sql = N'SELECT TOP 1 a.backup_start_date,a.type,b.physical_device_name,cast(compressed_backup_size/1024/1024 as int) as size_mb 
  FROM msdb.dbo.backupset a
    INNER JOIN msdb.dbo.backupmediafamily b
      ON a.media_set_id = b.media_set_id
  WHERE a.database_name = @DBName
    AND a.type = ''D''
    AND is_copy_only = 0
    AND (a.backup_start_date <= @stopattime
    AND a.backup_start_date >= @BackupStartDate)
  ORDER BY a.backup_start_date DESC'

if Left(cast(SERVERPROPERTY('productversion') as varchar),1)  in('9','8')
	select @sql = REPLACE(@sql,'compressed_backup_size','backup_size')
insert into #backupinfo
exec sp_executesql 
	@sql,N'@dbname varchar(100),@stopattime datetime,@backupStartDate datetime',@dbname,@stopattime,@backupstartdate

select @backupstartdate = start_date from #backupinfo

select @sql = REPLACE(@sql,'''D''','''I''')

insert into #backupinfo
exec sp_executesql 
	@sql,N'@dbname varchar(100),@stopattime datetime,@backupStartDate datetime',@dbname,@stopattime,@backupstartdate

select * from #backupinfo
