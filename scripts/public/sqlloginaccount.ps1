function Get-PQSQLLoginAccount {
$Input |
	%{gwmi win32_service -computer $_.SErverName -property __server,name, startname, caption |
		select __server, name,startname| ? {$_.name -eq 'MSSQLSERVER'} }| ft
}
