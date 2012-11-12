Function Get-PQSqlServers($tag="all")
{
	[xml]$serverxml = Get-Content "$(poshpath -tag config)\servers.xml"
 	if($tag -eq "all"){ 
	 	$servers = $serverxml.servers.server
	}else{
	 	$servers = $serverxml.servers.server | where {$_.tag -eq $tag}
	}
	foreach ($server in $servers){
		$info = @{
			'InstanceName' = $Server.servername;
			'ServerName'   = $Server.servername.split('\')[0];
		    'TagMatch'     = $tag;
			'Tags'         = $server.tag;
		}
		$obj = New-Object -TypeName PSObject -Property $info
		$obj.PSObject.typenames.insert(0,'PoshSQL.ServerInfo')
		write-output $obj	
	}
}
