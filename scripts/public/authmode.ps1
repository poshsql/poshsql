function Get-PQAuthMode(){
	param(
      [Parameter(Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
      [string[]]$instancename
    )
	process {
			$Query = LoadQuery -tag authmode
			$authstatus = ExecuteSQL -Query $Query -ServerName $instancename -DatabaseName master
			$info = @{
				'Server Name' = $authstatus.ServerName;
				'Auth Mode'  = $authstatus.AuthMode;
			}
			$obj = New-Object -TypeName PSObject -Property $info
			$obj.PSObject.typenames.insert(0,'PoshSQL.ServerAuthMode')
			write-output $obj | select "Server Name","Auth Mode"
	}

}
