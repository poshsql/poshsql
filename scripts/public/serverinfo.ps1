function Get-PQServerinfo() {
 param(
        [Parameter(Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
        [string[]]$ServerName,
        [switch]$AsObject
    )
	process {
            $computersystem = Get-WMIObject -Query "SELECT * from Win32_ComputerSystem" -ComputerName $ServerName #Model and Make TotalPhysicalMemory
            $osname = Get-WMIObject -Query "SELECT * from Win32_OperatingSystem" -ComputerName $ServerName #OS version and Lastbootuptime
            $cpu = Get-WMIObject -Query "SELECT * from Win32_Processor" -ComputerName $ServerName #logical, Physical, hyperthreading, multicore, cpu clock speed 

            $info = @{
                'ServerName'  = $computersystem.Name;
                'Manufacturer'  = $computersystem.Manufacturer;
                'Model'    = $computersystem.Model;
                'TotalPhysicalMemory(MB)'    = $computersystem.TotalPhysicalMemory/1MB;
                'OSVersion'    = $osname.Name;
                'Lastbootuptime'    = $osname.Lastbootuptime;
                'PhysicalProcessors' = $cpu.Count;
                'LogicalCores(Per CPU)' =  $cpu[0].NumberofCores;
                'MaxClockSpeed' =  $cpu[0].MaxClockSpeed;
            }
            if ($cpu[0].NumberofCores -lt $cpu[0].NumberofLogicalProcessors){
                $info.Add("HyperThreading", "Enabled")
            }else{
                $info.Add("HyperThreading", "Disabled")
            }

            $obj = New-Object -TypeName PSObject -Property $info
            $obj.PSObject.typenames.insert(0,'PoshSQL.ServerInfo')
            
            if ($AsObject){
                $obj
            }else{
                $obj | select ServerName,Manufacturer,Model,"TotalPhysicalMemory(MB)",OSVersion,Lastbootuptime,PhysicalProcessors,"LogicalCores(Per CPU)",HyperThreading,MaxClockSpeed
            }
        } 
}
