function Get-SqlServiceStatus(){
	param(
      [Parameter(Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
      [string[]]$instanceName
    )
	process {
		foreach ($instance in $instancename){
			if ($instance -like "*\*") {
				$ServerName = $instance.split('\')[0]
				$inst= $instance.split('\')[1]
				#code
			}else{
				$ServerName = $instance.split('\')[0]
				$inst= 'Default' 
			}
			#SQL Services{{{	
			if ($inst -ne 'Default'){
				$sql = gwmi win32_service -comp $servername -filter "( name like '%MSSQL`$$inst')" | 
				select __server,name,startmode,state,status 
			}else{
				$sql = gwmi win32_service -comp $servername -filter "( name like 'MSSQLSERVER')" | 
				select __server,name,startmode,state,status 
			}
			#}}}
			#SQL Agent Services{{{	
			if ($inst -ne 'Default'){
				$sqlagent = gwmi win32_service -comp $servername -filter "( name like '%sqlagent`$$inst')" | 
				select __server,name,startmode,state,status 
			}else{
				$sqlagent = gwmi win32_service -comp $servername -filter "( name like 'sqlserveragent')" | 
				select __server,name,startmode,state,status 
			}
			#}}}
			#SQL Analysis Services{{{	
			if ($inst -ne 'Default'){
				$msolap = gwmi win32_service -comp $servername -filter "( name like '%MSOLAP`$$inst')" | 
				select __server,name,startmode,state,status 
			}else{
				$msolap = gwmi win32_service -comp $servername -filter "( name like 'MSSQLServerOLAPService')" | 
				select __server,name,startmode,state,status 
			}
			#}}}
			#SQL FullText Service{{{	
			if ($inst -ne 'Default'){
				$ft = gwmi win32_service -comp $servername -filter "(name like '%MSSQLFDLauncher' or name like '%msftesql')" | 
				select __server,name,startmode,state,status 
			}else{
				$ft = gwmi win32_service -comp $servername -filter "(name like '%MSSQLFDLauncher`$$instanceName' or name like '%msftesql`$$instanceName')" | 
				select __server,name,startmode,state,status 
			}
			#}}}
			$info = @{
				'InstanceName' = $instance;
				'SQL'  = DecorateServiceStatus -status $sql.state -startmode $sql.startmode
				'Agent'  = DecorateServiceStatus -status $sqlagent.state -startmode $sqlagent.startmode
				'FTS'  = DecorateServiceStatus -status $ft.state -startmode $ft.startmode
				'SSAS'  = DecorateServiceStatus -status $msolap.state -startmode $msolap.startmode
			}
			$obj = New-Object -TypeName PSObject -Property $info
			$obj.PSObject.typenames.insert(0,'PoshSQL.SQLServicesStatus')
			write-output $obj | select "instanceName","SQL","Agent",FTS,SSAS
		}
	}
}
