function Get-PQBackupFiles([string]$ServerName,[string]$DatabaseName,[string]$stopat,[string]$tag){
	$Query = LoadQuery -tag BackupFiles
	$Query = ReplaceParameters $Query $DatabaseName $stopat 
	$files = ExecuteSQL -Query $Query -ServerName $ServerName -DatabaseName $DatabaseName
	foreach ($file in $files){
		$info = @{
			'start_date'      = $file.start_date;
			'backup_type'     = $file.backup_type;
			'file_name'     = $file.file_name;
			'file_size'   = $file.file_size;
		}
		$obj = New-Object -TypeName PSObject -Property $info
		$obj.PSObject.typenames.insert(0,'PoshSQL.Backupfiles')
		write-output $obj	
	}

}
