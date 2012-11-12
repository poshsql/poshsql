function Get-PQSpace() {
 param(
        [Parameter(Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
        [string[]]$Computername,
        [switch]$mb
    )
	process {
            #$ErrorActionPreference = "SilentlyContinue"
            $disk = Get-WMIObject -Query "SELECT name,capacity,freespace,systemname from Win32_Volume where drivetype=3" -Computername $ComputerName
            $info = @{
                'Server'  = $disk.systemname;
                'Name'    = $disk.name;
                '%Free'   = [int64]($disk.freespace / $disk.Capacity * 100);
            }
            if ($mb){
                $info.Add('Total(MB)', [int64]($disk.capacity/1MB));
                $info.Add('Free(MB)', [int64]($disk.freespace/1MB));
            }else{
                $info.Add('Total(GB)', [int64]($disk.capacity/1GB));
                $info.Add('Free(GB)', [int64]($disk.freespace/1GB));
            }
            $obj = New-Object -TypeName PSObject -Property $info
            $obj.PSObject.typenames.insert(0,'PoshSQL.ServerDiskSpace')
            if ($mb){
                write-output $obj | select "Server","Name","Total(MB)","Free(MB)","%Free"
            }else{
                write-output $obj | select "Server","Name","Total(GB)","Free(GB)","%Free"
            }
            
    }
}
