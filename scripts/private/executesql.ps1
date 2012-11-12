function ExecuteSQL ([string]$Query,[string]$DatabaseName,[string]$ServerName) {
  $Connection = New-Object System.Data.SQLClient.SQLConnection
  if ($DatabaseName.Trim() -eq '' -or $ServerName.Trim() -eq ''){
		  write-host 'Database Name and Server Name is a Mandatory Parameter' -ForegroundColor Red;
		  return;
  }
  $connectionstring = "server=$servername;database=$DatabaseName;trusted_connection=true;pooling=false"
  $connection.ConnectionString = $connectionstring;
  $Connection.Open()
  $Command = New-Object System.Data.SQLClient.SQLCommand
  $Command.Connection = $Connection
  $Command.CommandText = $Query
  $Adapter = New-Object System.Data.SqlClient.SqlDataAdapter
  $Adapter.SelectCommand = $Command
  $DataSet = New-Object System.Data.DataSet
  $Adapter.Fill($DataSet) | out-NULL
  $Connection.Close()
  $Connection.Dispose()
  $DataSet.Tables[0]
}
