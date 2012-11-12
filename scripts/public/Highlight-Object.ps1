Function Out-Highlight {
# Parameter Definition {{{
	Param( 
		[Parameter(ValueFromPipeline = $true)] $InputObject,
		[Parameter(Position = 0)] [scriptblock]$Condition= {$false},
		[ValidateNotNullOrEmpty()] [System.String]$Fcolor = 'Red',
		[ValidateNotNullOrEmpty()] [System.String]$Bcolor = 'Black',
		[String[]]$Property 
	)#}}}
# Initialize {{{
	Begin{
		$columnheader = $true	
		$hostwidth=$host.ui.RawUI.BufferSize.Width -1	
		$hostcolor=$host.ui.RawUI.ForegroundColor
		$hostbcolor=$host.ui.RawUI.BackgroundColor
		$PQFT = @()
	}
#}}}
# Build objects and add into Array (Also Handle Visibility) {{{
	Process{
		if ($columnheader){
			foreach($pt in $InputObject.PSObject.properties){
				if ($Property -gt 0)
				{
				#$Property -match $pt.name
					if($Property -match $pt.name){
						$Visible = 1
					}else{
						$Visible = 0
					}

				}else{
						$Visible = 1
				}
				$hashtable = @{
						Name = $pt.Name
						Width = 20
						SortOrder = 500
						Visible = $Visible
				}
				$obj = New-Object -TypeName PSObject -Property $hashtable
				$obj.PSObject.typenames.insert(0,'PoshSQL.Highlight')
				$PQFT += $obj
			}
#}}}
#Width adjustment {{{
			$noofproperty = ($PQFT | ? {$_.visible -eq 1} | measure).count
			$residual = $hostwidth % $noofproperty
			$hostwidth -= $residual
			$widthtoadd = $hostwidth/$noofproperty
			$PQFT | ? {$_.Visible -eq 1 } | % {
				if($residual -gt 0){
					$_.Width = $widthtoadd + 1
					$residual -= 1
				}
				else{
					$_.Width = $widthtoadd
				}
			}
#}}}
#Order adjustment {{{
			$Property | % -Begin{$counter = 1} -process{
				& {
					
					param([string]$x)
					$PQFT | ? {$_.Visible -eq 1 } | %  -Process {
							if($_.Name -eq $x)
							{
								$_.sortOrder = $counter
								set-variable -Name counter -value ($counter+1) -scope 1
							}
					}
				} $_
			} 
#}}}
#Display Object Header {{{
			write-host
			$PQFT| ? {$_.Visible -eq 1}|sort -property sortorder | % {
				write-host $(AlignData $_.Name -Width $_.width)-nonewline -for cyan
			}
			write-host
			$PQFT | ? {$_.Visible -eq 1}|sort -property sortorder | % {
				write-host $(AlignData ('-' * $_.name.Length) -Width $_.Width)-nonewline -for Cyan
			}
			write-host
			$columnheader = $false
		}
#}}}
# Identify Highlight candidates {{{
		if($InputObject| % $Condition){
			$hicolor = $Fcolor 
			$hibcolor = $Bcolor
		}else{
			$hicolor = $hostcolor 
			$hibcolor = $hostbcolor 
		}
#}}}
#Display Object Rows {{{
		$PQFT| ? {$_.Visible -eq 1} |sort -property sortorder| % {
			write-host $(AlignData $InputObject.psobject.properties[$_.Name].value -Width $_.Width
					)-nonewline -for $hicolor -Back $hibcolor
		} 
			write-host
	}
	End{
	
		#write-host $(AlignData ('-' * $hostwidth)  -Width $hostwidth)-nonewline -for Cyan
	}
#}}}
}
